package com.ahmedhnewa.plugins

import io.ktor.server.application.*
import io.ktor.server.plugins.callloging.*
import io.ktor.server.request.*
import org.slf4j.event.Level

fun Application.configureMonitoring() {
    install(CallLogging) {
        level = Level.ERROR
        filter { call -> call.request.path().startsWith("/") }
//        format { call ->
//            val now = LocalDateTime.now()
//            val date = now.toLocalDate()
//            val time = now.toLocalTime().toString().substringBeforeLast('.')
//            val remoteHost = call.request.origin.remoteHost
//            val requestPath = call.request.path()
//            val responseStatus = call.response.status()
//            "$date $time [$remoteHost] \"$requestPath\" $responseStatus"
//        }
    }
}
