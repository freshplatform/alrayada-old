package net.freshplatform.routes.user

import net.freshplatform.data.user.User
import net.freshplatform.data.user.UserData
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.data.user.UserDeviceNotificationsToken
import net.freshplatform.services.mail.EmailMessage
import net.freshplatform.services.mail.MailSenderService
import net.freshplatform.services.security.hashing.HashingService
import net.freshplatform.services.security.hashing.SaltedHash
import net.freshplatform.services.security.social_authentication.SocialAuthUserData
import net.freshplatform.services.security.social_authentication.SocialAuthentication
import net.freshplatform.services.security.social_authentication.SocialAuthenticationService
import net.freshplatform.services.security.token.JwtService
import net.freshplatform.services.security.verification_token.TokenVerificationService
import net.freshplatform.services.telegram.TelegramBotService
import net.freshplatform.utils.constants.Constants
import net.freshplatform.utils.constants.PatternsConstants
import net.freshplatform.utils.extensions.isPasswordStrong
import net.freshplatform.utils.extensions.isValidEmail
import net.freshplatform.utils.extensions.request.*
import net.freshplatform.utils.extensions.webcontent.webContentHeader
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.html.*
import io.ktor.server.plugins.ratelimit.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.html.*
import net.freshplatform.routes.RouteBase
import net.freshplatform.utils.extensions.isProductionMode
import java.time.LocalDateTime

class UserRoutes(
    private val router: Route,
    private val userDataSource: UserDataSource,
    private val hashingService: HashingService,
    private val jwtService: JwtService,
    private val tokenVerificationService: TokenVerificationService,
    private val mailSenderService: MailSenderService,
    private val socialAuthenticationService: SocialAuthenticationService,
    private val telegramBotService: TelegramBotService
) : RouteBase() {
    companion object {
        const val SIGN_IN_ROUTE_NAME = "signIn"
        const val SIGN_UP_ROUTE_NAME = "signUp"
    }


    private suspend fun notifyTelegramChatAboutRegister(user: User) {
        val msg = buildString {
            append("A new user has inserted in the database\n")
            append("Lab owner name: <b>${user.data.labOwnerName}</b>\n")
            append("Lab name: <b>${user.data.labName}</b>\n")
            append("Lab owner phone: <b>${user.data.labOwnerPhoneNumber}</b>\n")
            append("Lab phone: <b>${user.data.labPhoneNumber}</b>\n")
        }
        telegramBotService.sendMessage(text = msg)
    }

    /**
     * Apple redirect url for Android
     * */
    fun signInWithAppleWeb() = router.route("/socialLogin/signInWithApple") {
        handle {
            val parameters = call.receiveParameters()
            val params = Parameters.build {
                parameters.forEach { s, strings ->
                    append(s, strings.first())
                }
            }
            // Android
            call.respondRedirect("intent://callback?${params.formUrlEncode()}#Intent;package=${Constants.MobileAppId.ANDROID};scheme=signinwithapple;end")
        }
    }

    fun socialAuthentication() = router.post("/socialLogin") {
        call.protectRouteToAppOnly()
        val socialUserData: SocialAuthUserData
        val socialAuthRequest: SocialAuthentication

        when (call.requireParameter("provider")) {
            SocialAuthentication.Google::class.simpleName -> {
                val googleSocialRequest = call.receiveBodyAs<SocialAuthentication.Google>()
                socialAuthRequest = googleSocialRequest
                socialUserData = socialAuthenticationService.authenticateWith(
                    SocialAuthentication.Google(
                        googleSocialRequest.idToken,
                        googleSocialRequest.signUpUserData,
                        socialAuthRequest.deviceToken
                    )
                ) ?: kotlin.run {
                    call.respondJsonText(HttpStatusCode.BadRequest, "Token of google account is not valid!")
                    return@post
                }
            }

            SocialAuthentication.Apple::class.simpleName -> {
                val appleSocialRequest = call.receiveBodyAs<SocialAuthentication.Apple>()
                socialAuthRequest = appleSocialRequest
                val identityToken = appleSocialRequest.identityToken
                val userId = appleSocialRequest.userId
                socialUserData = socialAuthenticationService.authenticateWith(
                    SocialAuthentication.Apple(
                        identityToken,
                        userId,
                        appleSocialRequest.signUpUserData,
                        socialAuthRequest.deviceToken
                    )
                ) ?: kotlin.run {
                    call.respondJsonText(HttpStatusCode.BadRequest, "Token of apple account is not valid!")
                    return@post
                }
            }

            else -> {
                call.respondJsonText(HttpStatusCode.BadRequest, "Unsupported provider.")
                return@post
            }
        }

        if (!socialUserData.emailVerified) {
            call.respondJsonText(HttpStatusCode.BadRequest, "Email is not verified.")
            return@post
        }

        var isSignIn = true
        val user = userDataSource.getUserByEmail(socialUserData.email) ?: kotlin.run {
            val signUpUserData = socialAuthRequest.signUpUserData
            if (signUpUserData == null) {
                call.respondJsonText(
                    HttpStatusCode.BadRequest,
                    "There is no matching email account, so please provider sign up data to create the account"
                )
                return@post
            }
            isSignIn = false
            val user = User(
                email = socialUserData.email,
                password = "",
                salt = "",
                uuid = User.generateUniqueUUID(userDataSource),
                tokenVerifications = setOf(tokenVerificationService.generate(User.Companion.TokenVerificationData.EmailVerification.NAME)),
                emailVerified = true,
                data = signUpUserData,
                createdAt = LocalDateTime.now(),
                deviceNotificationsToken = socialAuthRequest.deviceToken,
                pictureUrl = socialUserData.pictureUrl
            )
            val success = userDataSource.insertUser(user)
            if (!success) {
                call.respondJsonText(HttpStatusCode.InternalServerError, "Error while insert the user to the database")
                return@post
            }
            notifyTelegramChatAboutRegister(user)
            user
        }
        if (isSignIn) {
            userDataSource.updateDeviceTokenByUUID(
                newDeviceToken = socialAuthRequest.deviceToken,
                userUUID = user.uuid
            )
        }
        val jwtValue = jwtService.generateUserToken(user.stringId())
        call.respond(
            HttpStatusCode.OK,
            AuthSignInResponse(
                token = jwtValue.token,
                expiresIn = jwtValue.expiresIn,
                expiresAt = jwtValue.expiresAt,
                user = user.toResponse(call),
            ),
        )
    }

    fun signUp() = router.rateLimit(RateLimitName(SIGN_UP_ROUTE_NAME)) {
        post("/${SIGN_UP_ROUTE_NAME}") {
            call.protectRouteToAppOnly()
            val request = call.receiveBodyAs<AuthSignUpRequest>()
            val error = request.validate()
            if (error != null) {
                call.respondJsonText(HttpStatusCode.BadRequest, error)
                return@post
            }
            val isEmailUsed = userDataSource.getUserByEmail(request.email) != null
            if (isEmailUsed) {
                call.respondJsonText(
                    HttpStatusCode.Conflict,
                    "Email already in use. Please use a different email or try logging in."
                )
                return@post
            }
            val password = hashingService.generateSaltedHash(request.password)
            val emailVerificationData =
                tokenVerificationService.generate(User.Companion.TokenVerificationData.EmailVerification.NAME)
            val newUser = User(
                email = request.email.lowercase(),
                password = password.hash,
                salt = password.salt,
                uuid = User.generateUniqueUUID(userDataSource),
                tokenVerifications = setOf(emailVerificationData),
//                emailVerificationData = tokenVerificationService.generate(),
//                forgotPasswordData = null,
                data = request.userData,
                createdAt = LocalDateTime.now(),
                deviceNotificationsToken = request.deviceToken
            )
            val createUserSuccess = userDataSource.insertUser(newUser)
            if (!createUserSuccess) {
                call.respondJsonText(
                    HttpStatusCode.InternalServerError,
                    "Sorry, there is error while register the account, please try again later"
                )
                return@post
            }
            val verificationLink =
                call.generateEmailVerificationLink(
                    email = newUser.email,
                    token = emailVerificationData.token
                )
            val sendEmailSuccess = mailSenderService.sendEmail(
                EmailMessage(
                    to = newUser.email,
                    subject = "Email account verification link",
                    body = "Hi, you have sign up on our platform,\n" +
                            " to confirm your email, we need you to open this link\n" +
                            "$verificationLink\n\nif you didn't do that," +
                            " please ignore this message"
                )
            )
            if (!isProductionMode()) {
                println("Here is your verification link: $verificationLink")
            }
            if (!sendEmailSuccess) {
                call.respondJsonText(
                    HttpStatusCode.InternalServerError,
                    "An error occurred while sending the email verification link, please try again by sign in or contact us"
                )
                return@post
            }
            notifyTelegramChatAboutRegister(newUser)
            call.respondJsonText(
                HttpStatusCode.Created,
                "We have sent you email verification link to your email to confirm it"
            )
        }
    }

    /*
    * If you want to change the route path
    * Remember to change it from generateEmailVerificationLink() too
    * */
    fun verifyEmailAccount() = router.get("/verifyEmailAccount") {
        val email = call.requireParameter("email")
        var message = "Email has successfully verified."
        var status = HttpStatusCode.OK
        if (!email.isValidEmail()) {
            message = "Please enter a" + " valid email address."
            status = HttpStatusCode.BadRequest
        }
        val enteredVerifyToken = call.requireParameter("token")
        val user = userDataSource.getUserByEmail(email)
        val emailTokenVerification = user?.let { User.Companion.TokenVerificationData.EmailVerification.find(it) }

        if (user == null) {
            status = HttpStatusCode.NotFound
            message = "Sorry, we couldn't" + " find this account."
        } else {
            if (user.emailVerified) {
                message = "Account is already verified."
                status = HttpStatusCode.BadRequest
            } else if (emailTokenVerification == null) {
                message = "Internal server error, email verification data is null, please contact us"
                status = HttpStatusCode.InternalServerError
            } else if (emailTokenVerification.hasTokenExpired()) {
                message = "Token has been expired."
                status = HttpStatusCode.Gone
            } else if (emailTokenVerification.token != enteredVerifyToken) {
                message = "Token is not valid."
                status = HttpStatusCode.BadRequest
            } else if (!userDataSource.verifyEmail(user.email)) {
                message = "Error while " +
                        "verify the account, please try again later."
                status = HttpStatusCode.InternalServerError
            }
        }

        call.respondHtml(
            status = status
        ) {
            webContentHeader("Verify email")
            body {
                div(
                    classes = "center-screen",
                ) {
                    div("card") {
                        +message
                    }
                }
            }
        }
    }

    fun signIn() = router.rateLimit(RateLimitName(SIGN_IN_ROUTE_NAME)) {
        post("/$SIGN_IN_ROUTE_NAME") {
            call.protectRouteToAppOnly()
            val request = call.receiveBodyAs<AuthSignInRequest>()
            val error = request.validate()
            if (error != null) {
                call.respondJsonText(HttpStatusCode.BadRequest, error)
                return@post
            }
            // Required for security, because social login set the password as empty
            if (request.password.isBlank()) {
                call.respondJsonText(HttpStatusCode.BadRequest, "Password is blank")
                return@post
            }
            val user = userDataSource.getUserByEmail(request.email) ?: kotlin.run {
                call.respondJsonText(
                    HttpStatusCode.NotFound,
                    "Email not found. Please check your email address and try again."
                )
                return@post
            }
            val isValidPassword = hashingService.verify(
                request.password,
                saltedHash = SaltedHash(
                    hash = user.password,
                    salt = user.salt
                )
            )
            if (!isValidPassword) {
                call.respondJsonText(HttpStatusCode.Unauthorized, "Incorrect password.")
                return@post
            }
            if (!user.emailVerified) {
                val emailTokenVerification = User.Companion.TokenVerificationData.EmailVerification.find(user)
                if (emailTokenVerification == null) {
                    call.respondJsonText(HttpStatusCode.InternalServerError, "This was not supposed to happen")
                    return@post
                }
                if (!emailTokenVerification.hasTokenExpired()) {
                    call.respondJsonText(
                        HttpStatusCode.Gone,
                        "Verification link is already sent," +
                                " it will expire after ${emailTokenVerification.minutesToExpire()} minutes."
                    )
                    return@post
                }
                val emailVerificationData =
                    tokenVerificationService.generate(User.Companion.TokenVerificationData.EmailVerification.NAME)
                val updateSuccess = userDataSource.updateEmailVerificationData(
                    request.email,
                    emailVerificationData
                )
                if (!updateSuccess) {
                    call.respondJsonText(
                        HttpStatusCode.InternalServerError, "Your email" +
                                " account is not verified" +
                                " We tried to update email verification link," +
                                " but we have some error," +
                                " Please try again later or contact us."
                    )
                    return@post
                }
                val verificationLink = call.generateEmailVerificationLink(
                    email = user.email,
                    token = emailTokenVerification.token
                )
                val sendEmailSuccess = mailSenderService.sendEmail(
                    EmailMessage(
                        to = user.email,
                        subject = "Email account verification link",
                        body = "Hi, you have sign up on our platform,\n" +
                                " to confirm your email, we need you to open this link\n" +
                                verificationLink + "\n\nif you didn't do that, please " +
                                "ignore this message"
                    )
                )
                if (!sendEmailSuccess) {
                    call.respondJsonText(
                        HttpStatusCode.InternalServerError, "Your email" +
                                " account is not verified" +
                                " We tried to send you email verification link," +
                                " but we have some error," +
                                " Please try again later or contact us."
                    )
                    return@post
                }
                call.respondJsonText(
                    HttpStatusCode.TemporaryRedirect, "Your email account is not" +
                            " verified" +
                            ", we have sent you" +
                            " the link to confirm that email belong to you," +
                            " please open it."
                )
                return@post
            }
            request.deviceToken?.let { deviceToken ->
                userDataSource.updateDeviceTokenByUUID(deviceToken, user.stringId())
            }
            val jwtValue = jwtService.generateUserToken(user.stringId())
            call.respond(
                HttpStatusCode.OK,
                AuthSignInResponse(
                    token = jwtValue.token,
                    expiresIn = jwtValue.expiresIn,
                    expiresAt = jwtValue.expiresAt,
                    user = user.toResponse(call)
                ),
            )
        }
    }

    fun forgotPassword() = router.post("/forgotPassword") {
        call.protectRouteToAppOnly()
        val email = call.requireParameter("email")
        val user = userDataSource.getUserByEmail(email) ?: kotlin.run {
            call.respondJsonText(
                HttpStatusCode.NotFound,
                "Email not found. Please check your email address and try again."
            )
            return@post
        }
        val forgotPasswordData = User.Companion.TokenVerificationData.ForgotPassword.find(user)
        if (forgotPasswordData != null && !forgotPasswordData.hasTokenExpired()) {
            call.respondJsonText(
                HttpStatusCode.Conflict, "We already have sent you link " +
                        "to reset your password, and it will expire" +
                        " after ${forgotPasswordData.minutesToExpire()} minutes"
            )
            return@post
        }
        val forgotPasswordVerification =
            tokenVerificationService.generate(User.Companion.TokenVerificationData.ForgotPassword.NAME)
        val success = userDataSource.updateForgotPasswordData(
            email = email,
            tokenVerification = forgotPasswordVerification
        )
        if (!success) {
            call.respondJsonText(
                HttpStatusCode.InternalServerError,
                "Error while updating forgot password link, Please try again later or contact us."
            )
            return@post
        }
        val resetPasswordUrl = call.generateResetPasswordFormVerificationLink(
            email = user.email,
            token = forgotPasswordVerification.token,
        )
        val sendEmailSuccess = mailSenderService.sendEmail(
            EmailMessage(
                to = user.email,
                subject = "Forgot password link",
                body = "You did request reset your password, if it was you" +
                        "\nplease open the following link\n${resetPasswordUrl}\n\n" +
                        "if you didn't request that, please ignore this message"
            )
        )
        if (!sendEmailSuccess) {
            call.respondJsonText(
                HttpStatusCode.InternalServerError,
                "Error while " +
                        "send forgot password link, Please try again later or" +
                        " contact us."
            )
        }
        call.respondJsonText(
            HttpStatusCode.OK, "We have sent you reset password link" +
                    " to your email inbox."
        )
    }

    /*
   * If you want to change the route path
   * Remember to change it from generateResetPasswordFormVerificationLink() too
   * */
    fun resetPasswordForm() = router.get("/resetPasswordForm") {
        val email = call.requireParameter("email")
        val token = call.requireParameter("token")
        call.respondHtml {
            webContentHeader("Reset password")
            body {
                div(
                    classes = "center-screen",
                ) {
                    form(
                        action = "/api/authentication/resetPassword",
                        method = FormMethod.get,
                        classes = "card",
                    ) {
                        name = "resetPasswordForm"
                        hiddenInput {
                            name = "token"
                            value = token
                            required = true
                        }
                        hiddenInput {
                            name = "email"
                            value = email
                            required = true
                        }
                        label {
                            this.htmlFor = "newPassword"
                            b { +"New Password" }
                        }
                        passwordInput {
                            name = "newPassword"
                            placeholder = "Enter password"
                            required = true
                            pattern = PatternsConstants.PASSWORD
                        }
                        div {
                            style = "padding-top: 10px"
                        }
                        submitInput { value = "Send" }
//                    buttonInput {
//                        type = InputType.submit
//                        value = "Send"
//                    }
                    }
                }
            }
        }
    }

    fun resetPassword() = router.get("/resetPassword") {
        val email = call.requireParameter("email")
        val token = call.requireParameter("token")
        val newPasswordPlainText = call.requireParameter("newPassword")

        if (!email.isValidEmail()) {
            call.respondJsonText(HttpStatusCode.BadRequest, "Please enter a valid email address.")
            return@get
        }
        val user = userDataSource.getUserByEmail(email) ?: kotlin.run {
            call.respondJsonText(
                HttpStatusCode.NotFound,
                "Email not found. Please check your email address and try again."
            )
            return@get
        }
        val forgotPasswordData = User.Companion.TokenVerificationData.ForgotPassword.find(user)
        if (forgotPasswordData == null) {
            call.respondJsonText(HttpStatusCode.BadRequest, "You didn't request reset password link.")
            return@get
        }
        if (forgotPasswordData.hasTokenExpired()) {
            call.respondJsonText(HttpStatusCode.Gone, "Request has been expired.")
            return@get
        }
        if (token != forgotPasswordData.token) {
            call.respondJsonText(HttpStatusCode.Unauthorized, "Token is not correct.")
            return@get
        }
        val newPassword = hashingService.generateSaltedHash(newPasswordPlainText)
        val updateProcessSuccess = userDataSource.updateUserPasswordByUUID(
            newPassword = newPassword.hash,
            salt = newPassword.salt,
            userUUID = user.uuid
        )
        if (!updateProcessSuccess) {
            call.respondJsonText(HttpStatusCode.InternalServerError, "Error while updating the password.")
            return@get
        }
        call.respondJsonText(HttpStatusCode.OK, "Password has been successfully updated")
    }

    fun getUserData() = router.authenticate {
        get("/user") {
            call.respond(HttpStatusCode.OK, call.requireAuthenticatedUser().toResponse(call))
        }
    }

    fun updateUserData() = router.authenticate {
        put("/userData") {
            val userData = call.receiveBodyAs<UserData>()
            val error = userData.validate()
            if (error != null) {
                call.respondJsonText(HttpStatusCode.BadRequest, error)
                return@put
            }
            val user = call.requireAuthenticatedUser()
            val updateSuccess = userDataSource.updateUserDataByUUID(
                userData = userData,
                userUUID = user.uuid
            )
            if (!updateSuccess) {
                call.respondJsonText(
                    HttpStatusCode.InternalServerError, "Error while" +
                            " update the user data."
                )
                return@put
            }

            call.respondJsonText(HttpStatusCode.OK, "User data has been updated.")
        }
    }

    fun updateDeviceToken() = router.authenticate {
        patch("/updateDeviceToken") {
            val deviceToken = call.receiveBodyAs<UserDeviceNotificationsToken>()
            val valid = deviceToken.validate()
            if (!valid) {
                call.respondJsonText(
                    HttpStatusCode.BadRequest,
                    "The string body which is deviceToken should not be empty."
                )
                return@patch
            }
            val currentUser = call.requireAuthenticatedUser()
            val updateSuccess = userDataSource.updateDeviceTokenByUUID(
                deviceToken,
                currentUser.uuid
            )
            if (!updateSuccess) {
                call.respondJsonText(HttpStatusCode.InternalServerError, "Error while update the device token.")
                return@patch
            }
            call.respondJsonText(HttpStatusCode.OK, "deviceToken has been updated")
        }
    }

    fun updatePassword() = router.authenticate {
        patch("/updatePassword") {
            val currentPassword = call.requireParameter("currentPassword")
            val newPassword = call.requireParameter("newPassword")
            val user = call.requireAuthenticatedUser()

            if (currentPassword == newPassword) {
                call.respondJsonText(HttpStatusCode.BadRequest, "Please choose a new password.")
                return@patch
            }
            if (!newPassword.isPasswordStrong()) {
                call.respondJsonText(HttpStatusCode.BadRequest, "Please enter a strong password")
                return@patch
            }
            val currentPasswordValid = hashingService.verify(
                value = currentPassword,
                saltedHash = SaltedHash(
                    hash = user.password,
                    salt = user.salt,
                )
            )
            if (!currentPasswordValid) {
                call.respondJsonText(HttpStatusCode.Unauthorized, "Current password is invalid password.")
                return@patch
            }
            val password = hashingService.generateSaltedHash(newPassword)
            val updateSuccess = userDataSource.updateUserPasswordByUUID(
                newPassword = password.hash,
                salt = password.salt,
                userUUID = user.uuid
            )
            if (!updateSuccess) {
                call.respondJsonText(HttpStatusCode.InternalServerError, "Error while update the password.")
                return@patch
            }
            call.respondJsonText(HttpStatusCode.OK, "Password has been updated.")
        }
    }

    fun deleteSelfAccount() = router.authenticate {
        delete("/deleteAccount") {
            val user = call.requireAuthenticatedUser()
            val deleteSuccess = userDataSource.deleteUserByUUID(user.stringId())
            if (!deleteSuccess) {
                call.respondJsonText(HttpStatusCode.InternalServerError, "Error while delete the user")
                return@delete
            }
            call.respondJsonText(HttpStatusCode.OK, "User has been successfully deleted!")
        }
    }

    override fun Route.register() {
        socialAuthentication()
        signInWithAppleWeb()
        signUp()
        signIn()
        getUserData()
        verifyEmailAccount()
        updateUserData()
        updateDeviceToken()
        forgotPassword()
        resetPasswordForm()
        resetPassword()
        updatePassword()
        deleteSelfAccount()
    }
}