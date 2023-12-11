package com.ahmedhnewa.services.security.payment_methods

import com.ahmedhnewa.data.order.PaymentMethod
import com.ahmedhnewa.services.http_client.HttpService
import com.ahmedhnewa.services.security.payment_methods.zain_cash.ZainCashPaymentRequest
import com.ahmedhnewa.services.security.payment_methods.zain_cash.ZainCashPaymentResponse
import com.ahmedhnewa.utils.constants.PaymentMethodsConstants
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import java.util.*

class PaymentMethodsServiceImpl(
    private val client: HttpClient = HttpService.client
) : PaymentMethodsService {
    @Throws(PaymentExceptionException::class)
    override suspend fun processPayment(
        paymentMethod: PaymentMethod,
        paymentData: Map<String, Any>,
        orderNumber: String,
        amount: Double,
        serviceType: String,
        baseUrl: String
    ): Any {
        return when (paymentMethod) {
            PaymentMethod.Cash -> Unit
            PaymentMethod.ZainCash -> {
                val zainCashConfigurations = PaymentMethodsConstants.ZainCash.configurations
                val token = PaymentMethodsConstants.ZainCash.generateCreatePaymentToken(
                    zainCashConfigurations,
                    amount,
                    "A order",
                    orderNumber,
                    baseUrl
                )
                try {
                    val response = client.post("${zainCashConfigurations.url}transaction/init") {
                        contentType(ContentType.Application.Json)
                        setBody(ZainCashPaymentRequest(token, zainCashConfigurations.merchantId))
                    }
                    return response.body<ZainCashPaymentResponse>()
                } catch (e: Exception) {
                    println(e.message)
                    throw PaymentExceptionException(e.message.toString())
                }
            }

            PaymentMethod.CreditCard -> TODO()
        }
    }
}