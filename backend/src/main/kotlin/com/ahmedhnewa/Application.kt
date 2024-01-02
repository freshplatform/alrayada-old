package com.ahmedhnewa

import com.ahmedhnewa.di.dependencyInjection
import com.ahmedhnewa.plugins.*
import com.ahmedhnewa.services.secret_variables.SecretVariablesName
import com.ahmedhnewa.services.secret_variables.SecretVariablesService
import com.ahmedhnewa.utils.constants.Constants
import com.ahmedhnewa.utils.extensions.getUserWorkingDirectory
import com.ahmedhnewa.utils.extensions.isProductionMode
import com.ahmedhnewa.utils.extensions.isProductionServer
import io.github.cdimascio.dotenv.dotenv
import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import kotlin.time.Duration.Companion.seconds

//fun main(args: Array<String>): Unit =
//    io.ktor.server.netty.EngineMain.main(args)

val appDotenv = dotenv {
    ignoreIfMissing = true
    systemProperties = false
}

fun main() {
    val server = embeddedServer(
        factory = Netty,
        environment = applicationEngineEnvironment {
            val serverPort =
                SecretVariablesService.getString(
                    SecretVariablesName.ServerPort, Constants.DEFAULT_SERVER_PORT.toString()
                ).toInt()
            println("Server is running on port $serverPort")

            developmentMode =
                SecretVariablesService.getString(SecretVariablesName.ServerDevelopmentMode, "true").toBoolean()
            connector { port = serverPort }
            if (developmentMode) {
                watchPaths = listOf("classes", "resources")
            }
            module(Application::module)
        },
    )
    if (isProductionServer() && isProductionMode()) {
        Runtime.getRuntime().addShutdownHook(Thread {
            val delay = 5.seconds
            println("Shutdown the server in ${delay.inWholeSeconds} sec...")
            server.stop(
                delay.inWholeMilliseconds,
                delay.inWholeMilliseconds
            ) // Gracefully stop the server when the JVM shuts down
        })
    }
    val serverBaseUrl = server.environment.connectors
        .first()
        .let { connector ->
            val scheme = if (connector.type.name == "https") "https" else "http"
            val host = if (connector.host == "0.0.0.0") "localhost" else connector.host
            val port = connector.port

            "$scheme://$host:$port"
        }
    println("Server Base URL: $serverBaseUrl")
    server.start(wait = true)

}

//@Suppress("unused")
fun Application.module() {
    val serverDevelopmentMode = environment.developmentMode
    println("User directory = ${getUserWorkingDirectory()}")
    println("Server Development mode enable = $serverDevelopmentMode")
    println("Production mode = ${isProductionMode()}")
    println("Production server = ${isProductionServer()}")

    dependencyInjection()
    configureMonitoring()
    configureSerialization()
    configureSockets()
    configureHTTP()
    configureSecurity()
    configureRouting()
}
