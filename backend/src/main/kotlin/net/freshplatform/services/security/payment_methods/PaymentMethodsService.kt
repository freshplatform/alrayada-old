package net.freshplatform.services.security.payment_methods

import net.freshplatform.data.order.PaymentMethod

class PaymentExceptionException(val error: String = ""): Exception(error)

interface PaymentMethodsService {
    @Throws(PaymentExceptionException::class)
    suspend fun processPayment(
        paymentMethod: PaymentMethod,
        paymentData: Map<String, Any>,
        orderNumber: String,
        amount: Double,
        serviceType: String,
        baseUrl: String
    ): Any
}