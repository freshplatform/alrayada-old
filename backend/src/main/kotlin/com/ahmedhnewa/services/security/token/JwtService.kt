package com.ahmedhnewa.services.security.token

import com.ahmedhnewa.services.secret_variables.SecretVariablesName
import com.ahmedhnewa.services.secret_variables.SecretVariablesService
import com.ahmedhnewa.utils.constants.Constants
import kotlin.time.Duration.Companion.days


fun getTokenConfig(): TokenConfig {
    val jwtSecret = SecretVariablesService.require(SecretVariablesName.JwtSecret)

    return TokenConfig(
        issuer = Constants.JwtConfig.DOMAIN,
        audience = Constants.JwtConfig.AUDIENCE,
        expiresIn = 90.days.inWholeMilliseconds /*90L * 1000L * 60L * 60L * 24L*/,
        secret = jwtSecret,
        realm = Constants.JwtConfig.REALM
    )
}

interface JwtService {
    fun generate(vararg claims: TokenClaim): JwtValue
    fun generateUserToken(userId: String): JwtValue
}