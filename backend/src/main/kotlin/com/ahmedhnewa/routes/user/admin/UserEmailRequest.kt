package com.ahmedhnewa.routes.user.admin

import kotlinx.serialization.Serializable
import com.ahmedhnewa.utils.extensions.isValidEmail

@Serializable
data class UserEmailRequest(
    val email: String
) {
    fun validate(): String? {
        return when {
            !email.isValidEmail() -> "Please enter valid email address"
            else -> null
        }
    }
}