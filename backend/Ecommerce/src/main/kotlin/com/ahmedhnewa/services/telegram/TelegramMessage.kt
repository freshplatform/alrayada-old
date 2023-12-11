package com.ahmedhnewa.services.telegram

import com.ahmedhnewa.utils.constants.TelegramConstants
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TelegramMessage(
    val text: String,
    @SerialName("chat_id")
    val chatId: String = TelegramConstants.getChatId(),
    @SerialName("parse_mode")
    val parseMode: String = "HTML"
)
