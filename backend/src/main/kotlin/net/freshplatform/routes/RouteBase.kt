package net.freshplatform.routes

import io.ktor.server.routing.*

abstract class RouteBase {

    abstract fun Route.register()
}