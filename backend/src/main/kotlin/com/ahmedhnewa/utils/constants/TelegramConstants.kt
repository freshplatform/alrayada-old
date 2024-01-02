package com.ahmedhnewa.utils.constants

import com.ahmedhnewa.services.secret_variables.SecretVariablesName
import com.ahmedhnewa.services.secret_variables.SecretVariablesService
import com.ahmedhnewa.utils.extensions.isProductionMode

object TelegramConstants {

    fun getChatId(): String {
        if (isProductionMode()) {
            return SecretVariablesService.require(SecretVariablesName.TelegramProductionChatId)
        }
        return SecretVariablesService.require(SecretVariablesName.TelegramTestingChatId)
    }
}