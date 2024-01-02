package com.ahmedhnewa.services.security.social_authentication

import com.ahmedhnewa.services.http_client.HttpService
import com.ahmedhnewa.services.secret_variables.SecretVariablesName
import com.ahmedhnewa.services.secret_variables.SecretVariablesService
import com.ahmedhnewa.utils.constants.Constants
import com.ahmedhnewa.utils.constants.DomainVerificationConstants
import com.auth0.jwt.JWT
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier
import com.google.api.client.http.javanet.NetHttpTransport
import com.google.api.client.json.gson.GsonFactory
import io.ktor.client.*
import io.ktor.client.plugins.*
import io.ktor.client.request.*
import java.util.*

class SocialAuthenticationServiceImpl(
    private val httpClient: HttpClient = HttpService.client
) : SocialAuthenticationService {

    private val googleIdTokenVerifier: GoogleIdTokenVerifier =
        GoogleIdTokenVerifier.Builder(NetHttpTransport(), GsonFactory())
            .setAudience(Collections.singletonList(SecretVariablesService.require(SecretVariablesName.GoogleClientId)))
            .build()

    companion object {
        const val FACEBOOK_BASE_URL = "https://graph.facebook.com/debug_token"
    }

    private val facebookAppAccessToken: String = SecretVariablesService.require(SecretVariablesName.FacebookAppAccessToken)

    override suspend fun authenticateWith(socialAuthData: SocialAuthentication): SocialAuthUserData? {
        return when (socialAuthData) {
            is SocialAuthentication.Google -> {
                val idToken = googleIdTokenVerifier.verify(socialAuthData.idToken) ?: return null
                val payload = idToken.payload

                val email = payload.email
                val emailVerified = (payload["email_verified"] as Boolean?) ?: false
                val pictureUrl = (payload["picture"] as String? ?: "")
                val name = (payload["name"] as String?) ?: ""
                SocialAuthUserData(
                    email = email,
                    emailVerified = emailVerified,
                    pictureUrl = pictureUrl,
                    name = name
                )
            }

            is SocialAuthentication.Apple -> try {
                val kid = JWT.decode(socialAuthData.identityToken).getHeaderClaim("kid").asString()
                val appleKey = SignInWithApple.getAppleSingingKey(kid) ?: return null
                val validatedJwt = SignInWithApple.verifyJWT(socialAuthData.identityToken, appleKey) ?: return null

                val audience = validatedJwt.audience.first()
                val subject = validatedJwt.subject

                if (subject == socialAuthData.userId && (audience == Constants.MobileAppId.IOS || audience == DomainVerificationConstants.APPLE.APPLE_AUTH_SERVICE_ID)) {
                    return SocialAuthUserData(
                        email = validatedJwt.getClaim("email").asString(),
                        emailVerified = (validatedJwt.getClaim("email_verified").asString().toBooleanStrictOrNull()
                            ?: false),
                        pictureUrl = "",
                        name = ""
                    )
                }

                null
            } catch (e: Exception) {
                println("Error = ${e.message}")
                null
            }

            is SocialAuthentication.Facebook -> {
                val accessToken = socialAuthData.accessToken
                return try {
                    httpClient.get(FACEBOOK_BASE_URL) {
                        parameter("input_token", accessToken)
                        parameter("access_token", facebookAppAccessToken)
                    }
//                    SocialAuthUserData(
//                        email = validatedJwt.getClaim("email").asString(),
//                        emailVerified = (validatedJwt.getClaim("email_verified").asString().toBooleanStrictOrNull()
//                            ?: false),
//                        pictureUrl = "",
//                        name = ""
//                    )
                    null
                } catch (e: ResponseException) {
                    println("Error = ${e.message}")
                    null
                }
            }
        }
    }

}