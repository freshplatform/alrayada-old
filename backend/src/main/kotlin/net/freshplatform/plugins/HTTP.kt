package net.freshplatform.plugins

import net.freshplatform.utils.extensions.isProductionServer
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.plugins.cachingheaders.*
import io.ktor.server.plugins.compression.*
import io.ktor.server.plugins.cors.routing.*
import io.ktor.server.plugins.defaultheaders.*
import io.ktor.server.plugins.httpsredirect.*

val HttpHeaders.ApiKey: String
    get() = "Api"

fun Application.configureHTTP() {
    configureHTTPS()
    install(DefaultHeaders) {
        header("X-Engine", "Ktor") // will send this header with each response )
    }
    install(CORS) {
        allowMethod(HttpMethod.Options)
        allowMethod(HttpMethod.Put)
        allowMethod(HttpMethod.Delete)
        allowMethod(HttpMethod.Patch)
        allowHeader(HttpHeaders.ContentType)
        allowHeader(HttpHeaders.Authorization)
        allowHeader(HttpHeaders.ApiKey)
//        allowHost("https://appleid.apple.com/")
//        val cloudflareIpRanges = listOf(
//        )
//        val ips = listOf("172.70.242.126", "172.70.243.60")
//        cloudflareIpRanges.forEach {
//            allowHost(it)
//        }
//        anyHost() // @TODO: Don't do this in production if possible. Try to limit it.
        allowCredentials = true
        allowSameOrigin = true
        allowHost("apple.com", schemes = listOf("https"), subDomains = listOf("appleid"))
    }
    install(Compression) {
        gzip {
            priority = 1.0
        }
        deflate {
            priority = 10.0
            minimumSize(1024) // condition
        }
    }
    install(CachingHeaders) {
        options { _, outgoingContent ->
            when (outgoingContent.contentType?.withoutParameters()) {
                ContentType.Text.CSS -> CachingOptions(CacheControl.MaxAge(maxAgeSeconds = 24 * 60 * 60))
                else -> null
            }
        }
    }
}


/**
 * Force https in production server
 * */
private fun Application.configureHTTPS() {
    if (!isProductionServer()) return
    install(HttpsRedirect) {
        // The port to redirect to. By default, 443, the default HTTPS port.
        sslPort = 443
        // 301 Moved Permanently, or 302 Found redirect.
        permanentRedirect = true
    }
}