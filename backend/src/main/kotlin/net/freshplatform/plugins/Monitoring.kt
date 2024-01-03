package net.freshplatform.plugins

import io.ktor.server.application.*
import io.ktor.server.plugins.*
import io.ktor.server.plugins.callloging.*
import io.ktor.server.request.*
import org.slf4j.event.Level

fun Application.configureMonitoring() {
    install(CallLogging) {
        level = Level.INFO
        filter { call -> call.request.path().startsWith("/") }
        format { call ->
            val remoteHost = call.request.origin.remoteHost
            val requestPath = call.request.path()
            val responseStatus = call.response.status()
            "[$remoteHost] \"$requestPath\" $responseStatus"
            ""
        }
    }
}
