package net.freshplatform.plugins

import net.freshplatform.data.chat.ChatDataSource
import net.freshplatform.data.offer.OfferDataSource
import net.freshplatform.data.order.OrderDataSource
import net.freshplatform.data.product.ProductDataSource
import net.freshplatform.data.product.category.ProductCategoryDataSource
import net.freshplatform.data.user.UserDataSource
import net.freshplatform.routes.chat.ChatRoomController
import net.freshplatform.routes.chat.ChatRoutes
import net.freshplatform.routes.chat.admin.ChatAdminRoutes
import net.freshplatform.routes.offers.OfferRoutes
import net.freshplatform.routes.orders.OrderRoutes
import net.freshplatform.routes.orders.admin.OrderAdminRoutes
import net.freshplatform.routes.orders.payment_gateways.PaymentGatewaysRoutes
import net.freshplatform.routes.product.ProductRoutes
import net.freshplatform.routes.product.category.ProductCategoryRoutes
import net.freshplatform.routes.user.UserRoutes
import net.freshplatform.routes.user.admin.UserAdminRoutes
import net.freshplatform.services.mail.MailSenderService
import net.freshplatform.services.notifications.NotificationService
import net.freshplatform.services.security.hashing.HashingService
import net.freshplatform.services.security.payment_methods.PaymentMethodsService
import net.freshplatform.services.security.social_authentication.SocialAuthenticationService
import net.freshplatform.services.security.token.JwtService
import net.freshplatform.services.security.verification_token.TokenVerificationService
import net.freshplatform.services.telegram.TelegramBotService
import net.freshplatform.utils.constants.Constants
import net.freshplatform.utils.constants.DomainVerificationConstants
import net.freshplatform.utils.extensions.getFileFromUserWorkingDirectory
import net.freshplatform.utils.extensions.request.*
import net.freshplatform.utils.extensions.webcontent.webContentHeader
import io.ktor.http.*
import io.ktor.serialization.*
import io.ktor.server.application.*
import io.ktor.server.html.*
import io.ktor.server.http.content.*
import io.ktor.server.plugins.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.request.ContentTransformationException
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.html.*
import kotlinx.serialization.SerializationException
import org.koin.ktor.ext.inject

fun Application.configureRouting() {
    val jwtService by inject<JwtService>()
    val hashingService by inject<HashingService>()
    val tokenVerificationService by inject<TokenVerificationService>()
    val mailSenderService by inject<MailSenderService>()
    val telegramBotService by inject<TelegramBotService>()
    val notificationService by inject<NotificationService>()
    val socialAuthenticationService by inject<SocialAuthenticationService>()
    val paymentMethodsService by inject<PaymentMethodsService>()

    val userDataSource by inject<UserDataSource>()
    val productDataSource by inject<ProductDataSource>()
    val productCategoryDataSource by inject<ProductCategoryDataSource>()
    val orderDataSource by inject<OrderDataSource>()
    val chatDataSource by inject<ChatDataSource>()
    val offerDataSource by inject<OfferDataSource>()

//    for (i in 1..1000) {
//        runBlocking {
//            userDataSource.insertUser(User(
//                uuid = UUID.randomUUID().toString(),
//                tokenVerifications = emptySet(),
//                email = "ahmed.hnewa@testasd.dsadsa",
//                password = "",
//                salt = "",
//                data = UserData(
//                    labOwnerName = "HiTest",
//                    labName = "HiTest",
//                    labOwnerPhoneNumber = "073232132131",
//                    labPhoneNumber = "06321321321",
//                    city = IraqGovernorate.Anbar
//                ),
//                createdAt = LocalDateTime.now(),
//                deviceNotificationsToken = UserDeviceNotificationsToken()
//            ))
//        }
//    }

    install(StatusPages) {
        exception<Throwable> { call, cause ->
            call.respondJsonText(text = "500: $cause", status = HttpStatusCode.InternalServerError)
            cause.printStackTrace()
        }
        exception<SerializationException> { call, cause ->
            call.respondJsonText(text = "Invalid json: $cause", status = HttpStatusCode.BadRequest)
        }
        exception<IllegalArgumentException> { call, cause ->
            call.respondJsonText(text = "Invalid: $cause", status = HttpStatusCode.BadRequest)
        }
        exception<ContentTransformationException> { call, cause ->
            call.respondJsonText(HttpStatusCode.BadRequest, "Invalid request format: ${cause.message}")
        }
        exception<BadRequestException> { call, cause ->
            call.respondJsonText(HttpStatusCode.BadRequest, "Bad request: ${cause.message}")
        }
        exception<RouteProtectedException> { call, _ ->
            call.respondJsonText(HttpStatusCode.Unauthorized, "You don't have access to this api")
        }
        exception<JsonConvertException> { call, cause ->
            call.respondJsonText(HttpStatusCode.InternalServerError, "Error while convert json = ${cause.message}")
        }
        exception<UserShouldAuthenticatedException> { call, cause ->
            call.respondJsonText(HttpStatusCode.BadRequest, cause.message.toString())
        }
        exception<RequestBodyMustValidException> { call, cause ->
            call.respondJsonText(HttpStatusCode.BadRequest, cause.message.toString())
        }
    }
    install(Resources)

    routing {
        route("/.well-known") {
            route("/apple-app-site-association") {
                handle {
                    call.respondText(
                        status = HttpStatusCode.OK,
                        text = DomainVerificationConstants.APPLE.JSON_DATA,
                        contentType = ContentType.Application.Json // Sometimes should not be used
                    )
                }
            }
            route("/assetlinks.json") {
                handle {
                    call.respondText(
                        status = HttpStatusCode.OK,
                        text = DomainVerificationConstants.Google.JSON_DATA,
                        contentType = ContentType.Application.Json
                    )
                }
            }
        }

        get("/getServerClientUrl") {
            val baseUrl = call.getServerClientUrl()
            call.respondJsonText(HttpStatusCode.OK, baseUrl)
        }

        route("/api") {

            route("/support") {
                val chatRoomController by inject<ChatRoomController>()
                val chatRoutes = ChatRoutes(this, chatDataSource, chatRoomController)
                chatRoutes.userChat()

                route("/admin") {
                    val chatAdminRoutes = ChatAdminRoutes(this, chatDataSource, userDataSource, chatRoomController)
                    chatAdminRoutes.chat()
                    chatAdminRoutes.getRooms()
                    chatAdminRoutes.deleteRoom()
                    chatAdminRoutes.roomsStatus() // Not used in project
                }
                chatRoutes.loadMessages() // Not used in project
            }
            route("/offers") {
                val offerRoutes = OfferRoutes(this, offerDataSource)
                offerRoutes.getAll()
                offerRoutes.createOne()
                offerRoutes.deleteOne()
            }
            route("/authentication") {
                val userRoutes = UserRoutes(
                    this,
                    userDataSource,
                    hashingService,
                    jwtService,
                    tokenVerificationService,
                    mailSenderService,
                    socialAuthenticationService,
                    telegramBotService
                )
                userRoutes.socialAuthentication()
                userRoutes.signInWithAppleWeb()
                userRoutes.signUp()
                userRoutes.signIn()
                userRoutes.getUserData()
                userRoutes.verifyEmailAccount()
                userRoutes.updateUserData()
                userRoutes.updateDeviceToken()
                userRoutes.forgotPassword()
                userRoutes.resetPasswordForm()
                userRoutes.resetPassword()
                userRoutes.updatePassword()
                userRoutes.deleteSelfAccount()

                route("/admin/users") {
                    val userAdminRoutes = UserAdminRoutes(this, userDataSource, notificationService)
                    userAdminRoutes.getAllUsers()
                    userAdminRoutes.activateAccount()
                    userAdminRoutes.deactivateAccount()
                    userAdminRoutes.deleteAccount()
                    userAdminRoutes.sendNotification()
                }
            }
            route("/products") {
                route("/categories") {
                    val productCategoryRoutes =
                        ProductCategoryRoutes(this, productCategoryDataSource, productDataSource)
                    productCategoryRoutes.getAll()
                    productCategoryRoutes.getOneById()
                    productCategoryRoutes.createOne()
                    productCategoryRoutes.updateOne()
                    productCategoryRoutes.deleteOne()
                }

                val productRoutes = ProductRoutes(this, productDataSource, productCategoryDataSource)
                productRoutes.getAll()
                productRoutes.getBestSelling()
                productRoutes.getOneById()
                productRoutes.getAllByCategory()
                productRoutes.createOne()
                productRoutes.updateOne()
                productRoutes.deleteOne()
            }
            route("/orders") {
                val orderRoute = OrderRoutes(
                    this, orderDataSource, productDataSource, userDataSource, telegramBotService, paymentMethodsService
                )
                orderRoute.getAll()
                orderRoute.checkout()
                orderRoute.isOrderPaidRoute()
                orderRoute.cancelOrder()
                orderRoute.getStatistics()

                route("/admin") {
                    val orderAdminRoutes = OrderAdminRoutes(this, orderDataSource, userDataSource, notificationService)
                    orderAdminRoutes.deleteOrder()
                    orderAdminRoutes.approveOrder()
                    orderAdminRoutes.rejectOrder()
                }

                route("/paymentGateways") {
                    val paymentGatewaysRoutes = PaymentGatewaysRoutes(this, orderDataSource)
                    paymentGatewaysRoutes.zainCash()
                }

            }
        }
        get("/") {
            call.respondHtml {
                webContentHeader("Homepage")
                body {
                    div(
                        classes = "center-screen",
                    ) {
                        div("card") {
                            +"Welcome to ${Constants.APP_NAME} app!! to use the app please install it on the Apple Store or google play or huawei store."
                            br()
                            +"By using the app, and it services, you are accept our "
                            a(href = "/privacy-policy") {
                                +"Privacy policy"
                            }
                        }
                    }
                }
            }
        }
        get("/privacy-policy") {
            call.respondHtml {
                webContentHeader("Privacy policy")
                body {
                    div(
                        classes = "center-screen",
                    ) {
                        div("card") {
                            h1 { +"Privacy policy" }
                            +("We respect your privacy and we don't collect any" +
                                    " personal data through our app. We don't require" +
                                    " you to create an account, provide any personal" +
                                    " information or share any data with us. " +
                                    "We don't track your location or use cookies " +
                                    "to monitor your activity. We don't sell, trade " +
                                    "or share any information with third parties.")
                            +(" We only use the information that is necessary " +
                                    "to operate the app and provide " +
                                    "you with the best user experience possible.\n" + "\n" +
                                    "We prioritize the security and confidentiality of your personal information. In our app, we utilize Firebase Crashlytics, a tool provided by Google, to help us identify and fix any technical issues or errors that may occur while you're using our app.\n" +
                                    "\n" +
                                    "It's important to note that Firebase Crashlytics is designed to collect information related to app crashes and errors, specifically focusing on technical data about the performance and stability of the app itself. This includes details such as the line of code where the crash occurred, the device model, operating system version, and other similar technical information.\n" +
                                    "\n" +
                                    "Please be assured that we do not collect or have access to any of your sensitive or personally identifiable information through Firebase Crashlytics. The data we gather is strictly limited to technical aspects of the app's performance and is used solely for the purpose of improving the app's stability and providing you with a better user experience, " +
                                    "\n" +
                                    "We respect your privacy and understand the importance of protecting your personal data. Rest assured that we do not share this technical data with any third parties or use it for any other purposes apart from app improvement and bug fixing. Your trust is of utmost importance to us, and we are committed to being transparent about our data collection practices." +
                                    "If you have any questions about our privacy policy " +
                                    "or how we handle your data, please contact us at ")
                            a(href = "mailto:${Constants.SUPPORT_EMAIL}") {
                                +"${Constants.SUPPORT_EMAIL}."
                            }
                            br()
                            +"This app has been developed by "
                            a(href = Constants.DEVELOPER_WEBSITE) {
                                +"Ahmed Hnewa"
                            }
                        }
                    }
                }
            }
        }
        get("/delete-account-instructions") {
            call.respondHtml {
                webContentHeader("Delete account instructions")
                body {
                    div(
                        classes = "center-screen",
                    ) {
                        div("card") {
                            +("We respect your privacy, to remove your created account, open the mobile app that you used to create the account, " +
                                    "it's available on google play and apple store, " +
                                    "go to account tab, sign in if you didn't, " +
                                    "click on account data, " +
                                    "then click on delete account button and confirm the process, " +
                                    "and your account will be completely should be deleted from our system.")
                            +("If you have any questions about our privacy policy or how we handle your data, please contact us at ")
                            a(href = "mailto:${Constants.SUPPORT_EMAIL}") { +"${Constants.SUPPORT_EMAIL}." }
                        }
                    }
                }
            }
        }
        val filesFolder = "/${Constants.Folders.SERVER_PUBLIC_FILES}/".getFileFromUserWorkingDirectory()
        staticFiles("/", filesFolder)
        staticResources("/", "static")
    }
}
