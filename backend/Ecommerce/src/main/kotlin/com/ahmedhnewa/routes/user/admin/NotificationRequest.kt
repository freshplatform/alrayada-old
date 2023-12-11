package com.ahmedhnewa.routes.user.admin

import kotlinx.serialization.Serializable
import com.ahmedhnewa.utils.extensions.isValidEmail

@Serializable
data class NotificationRequest(
    val title: String,
    val body: String,
    val email: String
) {
    fun validate(): String? = when {
        title.isBlank() -> "Title can't be empty"
        body.isBlank() -> "Body can't be empty"
        !email.isValidEmail() -> "Email should be valid"
        else -> null
    }
}