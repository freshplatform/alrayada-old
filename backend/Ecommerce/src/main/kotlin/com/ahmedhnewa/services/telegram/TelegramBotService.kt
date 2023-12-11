package com.ahmedhnewa.services.telegram

import com.ahmedhnewa.services.secret_variables.SecretVariablesName
import com.ahmedhnewa.services.secret_variables.SecretVariablesService

interface TelegramBotService {
    companion object {
        const val API_URL = "https://api.telegram.org"
        val telegramBotToken = SecretVariablesService.require(SecretVariablesName.TelegramBotToken)
    }
    suspend fun sendMessage(
        telegramMessage: TelegramMessage,
        telegramBotToken: String = TelegramBotService.telegramBotToken,
    ): Boolean

    suspend fun sendMessage(
        text: String
    ): Boolean
}