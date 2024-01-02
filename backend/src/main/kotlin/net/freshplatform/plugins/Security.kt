package net.freshplatform.plugins

import net.freshplatform.routes.user.UserRoutes
import net.freshplatform.services.secret_variables.SecretVariablesName
import net.freshplatform.services.secret_variables.SecretVariablesService
import net.freshplatform.services.security.token.getTokenConfig
import net.freshplatform.utils.constants.Constants
import net.freshplatform.utils.extensions.getUserWorkingDirectory
import net.freshplatform.utils.extensions.request.respondJsonText
import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*
import io.ktor.server.plugins.*
import io.ktor.server.plugins.ratelimit.*
import io.ktor.server.request.*
import java.io.File
import kotlin.random.Random
import kotlin.time.Duration.Companion.minutes
import kotlin.time.Duration.Companion.seconds

object AppSecurity {
    val apiKey: String by lazy {
        SecretVariablesService.require(SecretVariablesName.ApiKey)
    }
}

fun Application.configureSecurity() {
    install(RateLimit) {
        global {
            rateLimiter(limit = 50, refillPeriod = 60.seconds)
        }
        register(RateLimitName(UserRoutes.SIGNIN_ROUTE_NAME)) {
            rateLimiter(limit = 5, refillPeriod = Random.nextInt(from = 2, until = 10).minutes)
        }
        register(RateLimitName(UserRoutes.SIGNUP_ROUTE_NAME)) {
            rateLimiter(limit = 3, refillPeriod = 30.minutes)
        }
    }

    intercept(ApplicationCallPipeline.Call) {
        // Log every request
        val remoteHost = call.request.origin.remoteHost
        val requestPath = call.request.path()

        println("$remoteHost = $requestPath")

        // Add lock requests functionallity
        val file = File(getUserWorkingDirectory(), Constants.Folders.LOCKED_FILE_NAME)
        if (file.exists()) {
            call.respondJsonText(HttpStatusCode.ServiceUnavailable, "Sorry, but the server is unavailable right now, please check back later.")
            finish()
        }

        // Add development mode functionallity

//        if (ApplicationState.developmentMode) {
////            val allowedIpAddress = (mSystem.getenv("ALLOWED_IP_ADDRESS") ?: "")
////                .trim().split(",")
//            val developmentToken = call.request.header("DevelopmentToken") ?: ""
//            if (developmentToken != Constants.DEVELOPMENT_TOKEN) {
//                call.respondJsonText(HttpStatusCode.ServiceUnavailable, "Sorry, the server is undergoing maintenance, please check back later.")
//                finish()
//            }
//        }
    }

    // TODO("Implement under development mode")

    if (!environment.developmentMode) {
        println("Enable route protection to app only")
    }

    authentication {
        jwt {
            val tokenConfig = getTokenConfig()

            realm = tokenConfig.realm
            verifier(
                JWT.require(Algorithm.HMAC256(tokenConfig.secret))
                    .withAudience(tokenConfig.audience)
                    .withIssuer(tokenConfig.issuer)
                    .build()
            )
            validate { credential ->
                if (credential.payload.audience.contains(tokenConfig.audience) &&
                    credential.payload.getClaim("userId").asString() != null
                ) {
                    JWTPrincipal(credential.payload)
                } else null
            }
            challenge { _, _ ->
                call.respondJsonText(HttpStatusCode.Unauthorized, "You must be authenticated to continue.")
            }
        }
    }
}
