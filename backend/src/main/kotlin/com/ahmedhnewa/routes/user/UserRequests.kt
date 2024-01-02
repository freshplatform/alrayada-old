package com.ahmedhnewa.routes.user

import com.ahmedhnewa.data.user.UserData
import com.ahmedhnewa.data.user.UserDeviceNotificationsToken
import com.ahmedhnewa.utils.extensions.isPasswordStrong
import com.ahmedhnewa.utils.extensions.isValidEmail
import kotlinx.serialization.Serializable

@Serializable
data class AuthSignUpRequest(
    val email: String,
    val password: String,
    val deviceToken: UserDeviceNotificationsToken,
    val userData: UserData
) {
    fun validate(): String? {
        return when {
            !email.isValidEmail() -> "Please enter valid email address"
            email.length > 100 -> "Email is too long"
            password.length >= 255 -> "Password is too long"
            password.length < 8 -> "Password is too short"
            !password.isPasswordStrong() -> "Please enter a strong password" // TODO("Recheck this on client and server")
            userData.validate() != null -> userData.validate()
            else -> null
        }
    }
}

@Serializable
data class AuthSignInRequest(
    val email: String,
    val password: String,
    val deviceToken: UserDeviceNotificationsToken?,
) {
    fun validate(): String? {
        return when {
            !email.isValidEmail() -> "Please enter valid email address"
            password.isBlank() -> "Please enter your password"
            email.length > 100 -> "Email is too long"
            password.length >= 50 -> "Password is too long"
            password.length < 8 -> "Password is too short"
            else -> null
        }
    }
}