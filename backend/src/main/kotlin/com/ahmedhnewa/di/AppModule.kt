package com.ahmedhnewa.di

import com.ahmedhnewa.data.chat.ChatDataSource
import com.ahmedhnewa.data.chat.datasources.MongoChatDataSource
import com.ahmedhnewa.data.offer.OfferDataSource
import com.ahmedhnewa.data.offer.datasources.MongoOfferDataSource
import com.ahmedhnewa.data.order.OrderDataSource
import com.ahmedhnewa.data.order.datasources.MongoOrderDataSource
import com.ahmedhnewa.data.product.ProductDataSource
import com.ahmedhnewa.data.product.category.ProductCategoryDataSource
import com.ahmedhnewa.data.product.category.datasources.MongoProductCategoryDataSource
import com.ahmedhnewa.data.product.datasources.MongoProductDataSource
import com.ahmedhnewa.data.user.UserDataSource
import com.ahmedhnewa.data.user.datasources.MongoUserDataSource
import com.ahmedhnewa.routes.chat.ChatRoomController
import com.ahmedhnewa.services.mail.JavaMailSenderService
import com.ahmedhnewa.services.mail.MailSenderService
import com.ahmedhnewa.services.notifications.NotificationService
import com.ahmedhnewa.services.notifications.one_signal.KtorOneSignalNotificationService
import com.ahmedhnewa.services.secret_variables.SecretVariablesName
import com.ahmedhnewa.services.secret_variables.SecretVariablesService
import com.ahmedhnewa.services.security.hashing.HashingService
import com.ahmedhnewa.services.security.hashing.SHA256HashingService
import com.ahmedhnewa.services.security.payment_methods.PaymentMethodsService
import com.ahmedhnewa.services.security.payment_methods.PaymentMethodsServiceImpl
import com.ahmedhnewa.services.security.social_authentication.SocialAuthenticationService
import com.ahmedhnewa.services.security.social_authentication.SocialAuthenticationServiceImpl
import com.ahmedhnewa.services.security.token.JwtService
import com.ahmedhnewa.services.security.token.JwtServiceImpl
import com.ahmedhnewa.services.security.verification_token.TokenVerificationService
import com.ahmedhnewa.services.security.verification_token.TokenVerificationServiceImpl
import com.ahmedhnewa.services.telegram.KtorTelegramBotService
import com.ahmedhnewa.services.telegram.TelegramBotService
import com.ahmedhnewa.utils.constants.Constants
import io.ktor.server.application.*
import org.koin.dsl.module
import org.koin.ktor.plugin.Koin
import org.koin.logger.slf4jLogger
import org.litote.kmongo.coroutine.coroutine
import org.litote.kmongo.reactivestreams.KMongo

fun Application.dependencyInjection() {
    install(Koin) {
        slf4jLogger()
        modules(mainModule, servicesModule, dataSourcesModule)
    }
}

val mainModule = module {
    single {
        val databaseUrl = SecretVariablesService.require(SecretVariablesName.DatabaseUrl)
//        val settings = MongoClientSettings.builder()
//            .uuidRepresentation(UuidRepresentation.STANDARD)
//            .applyConnectionString(ConnectionString(databaseUrl))
//            .build()
        KMongo.createClient(
            connectionString = databaseUrl,
        )
            .coroutine
            .getDatabase(Constants.APP_DATABASE_NAME)
    }
}

val servicesModule = module {
    single<JwtService> {
        JwtServiceImpl()
    }
    single<HashingService> {
        SHA256HashingService()
    }
    single<TokenVerificationService> {
        TokenVerificationServiceImpl()
    }
    single<MailSenderService> {
        JavaMailSenderService()
    }
    single<TelegramBotService> {
        KtorTelegramBotService()
    }
    single<NotificationService> {
        KtorOneSignalNotificationService()
//        KtorFcmNotificationService()
    }
    single<SocialAuthenticationService> {
        SocialAuthenticationServiceImpl()
    }
    single<PaymentMethodsService> {
        PaymentMethodsServiceImpl()
    }
}

val dataSourcesModule = module {
    single<UserDataSource> {
        MongoUserDataSource(get())
    }
    single<ProductCategoryDataSource> {
        MongoProductCategoryDataSource(get())
    }
    single<ProductDataSource> {
        MongoProductDataSource(get(), get())
    }
    single<OrderDataSource> {
        MongoOrderDataSource(get())
    }
    single<ChatDataSource> {
        MongoChatDataSource(get())
    }
    single {
        ChatRoomController(get(), get(), get(), get())
    }
    single<OfferDataSource> {
        MongoOfferDataSource(get())
    }
}