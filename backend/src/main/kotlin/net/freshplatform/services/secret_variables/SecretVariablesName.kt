package net.freshplatform.services.secret_variables

enum class SecretVariablesName(val value: String) {
    DatabaseUrl("DATABASE_URL"),
    ApiKey("API_KEY"),
    JwtSecret("JWT_SECRET"),

    /**
     * For ktor server to auto reload and get more logs
     * */
    ServerDevelopmentMode("SERVER_DEVELOPMENT_MODE"),

    /**
     * Used to have different behavior depending on if this a development mode or not
     * */
    ProductionMode("PRODUCTION_MODE"),
    /**
     * Used to know if the running server in the cloud or not, to have path for 'files' folder for example
     * */
    ProductionServer("PRODUCTION_SERVER"),
    ServerPort("PORT"),
    EmailUsername("EMAIL_USERNAME"),
    EmailPassword("EMAIL_PASSWORD"),
    FromEmail("FROM_EMAIL"),
    TelegramBotToken("TELEGRAM_BOT_TOKEN"),
    TelegramProductionChatId("TELEGRAM_PRODUCTION_CHAT_ID"),
    TelegramTestingChatId("TELEGRAM_TESTING_CHAT_ID"),
    GoogleClientId("GOOGLE_CLIENT_ID"),
    ZainCashMerchantId("ZAIN_CASH_MERCHANT_ID"),
    ZainCashMerchantSecret("ZAIN_CASH_MERCHANT_SECRET"),
    ZainCashMerchantMsiSdn("ZAIN_CASH_MERCHANT_MSISDN"),
    ZainCashApiUrl("ZAIN_CASH_API_URL"),
    DollarInDinar("DOLLAR_IN_DINAR"),
    OneSignalAppId("ONE_SIGNAL_APP_ID"),
    OneSignalRestApiKey("ONE_SIGNAL_REST_API_KEY")
}