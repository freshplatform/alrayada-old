package com.ahmedhnewa.utils.extensions

import com.ahmedhnewa.utils.constants.PatternsConstants
import com.ahmedhnewa.utils.helpers.PatternsHelper
import kotlinx.serialization.builtins.serializer
import kotlinx.serialization.json.Json
import java.io.File
import java.util.regex.Pattern

fun String.isValidEmail() = PatternsHelper.EMAIL_ADDRESS.matcher(this).matches()
fun String.toPattern(): Pattern = Pattern.compile(this)
fun String.matchPattern(pattern: String): Boolean = pattern.toPattern().matcher(this).matches()
fun String.isPasswordStrong() = this.matchPattern(PatternsConstants.PASSWORD)
//fun getUserDirectory(): String = System.getProperty("user.dir")
fun getUserWorkingDirectory(): String {
    if (!isProductionServer()) {
        return File(".").canonicalPath
    }
    return File(object {}.javaClass.protectionDomain.codeSource.location.toURI().path).parent
}
fun String.getFileFromUserWorkingDirectory(): File = File(getUserWorkingDirectory(), this)
//fun String.toFile() = File(this)
fun String.toJson(): String = Json.encodeToString(String.serializer(), this)