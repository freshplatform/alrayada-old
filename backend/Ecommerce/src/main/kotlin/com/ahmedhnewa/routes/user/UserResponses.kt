package com.ahmedhnewa.routes.user

import kotlinx.serialization.Serializable
import com.ahmedhnewa.data.user.UserResponse

@Serializable
data class AuthSignInResponse(
    val token: String,
    val expiresIn: Long,
    val expiresAt: Long,
    val user: UserResponse
)