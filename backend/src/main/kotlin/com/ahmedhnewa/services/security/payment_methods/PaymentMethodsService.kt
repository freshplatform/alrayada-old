package com.ahmedhnewa.services.security.payment_methods

import com.ahmedhnewa.data.order.PaymentMethod

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