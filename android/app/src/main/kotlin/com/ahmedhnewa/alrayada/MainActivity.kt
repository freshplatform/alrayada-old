package com.ahmedhnewa.alrayada

import android.os.Bundle
import android.view.WindowManager
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.lifecycle.lifecycleScope
import com.ahmedhnewa.alrayada.google.GoogleInAppReviewManager
import com.ahmedhnewa.alrayada.google.GoogleInAppUpdateManager
import com.ahmedhnewa.alrayada.google.isGooglePlayServicesAvailable
import com.ahmedhnewa.alrayada.utils.AppShare
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch


class MainActivity : FlutterActivity() {
    private lateinit var googleInAppUpdateManager: GoogleInAppUpdateManager
    private lateinit var googleInAppReviewManager: GoogleInAppReviewManager
    override fun onCreate(savedInstanceState: Bundle?) {
        installSplashScreen()
        super.onCreate(savedInstanceState)
        googleInAppUpdateManager = GoogleInAppUpdateManager(this)
        googleInAppReviewManager = GoogleInAppReviewManager(context, activity)
    }

    override fun onResume() {
        super.onResume()
        lifecycleScope.launch(Dispatchers.IO) { googleInAppUpdateManager.onResumeAppUpdate() }
    }

    override fun onDestroy() {
        super.onDestroy()
        googleInAppUpdateManager.unregisterUpdateListener()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "$packageName/app"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "updateAndroidAppByGooglePlay" -> lifecycleScope.launch(Dispatchers.IO) {
                    if (!isGooglePlayServicesAvailable(context)) return@launch
                    val success = googleInAppUpdateManager.updateApp()
                    result.success(success)
                }
                "showAndroidAppFeedbackDialogByGooglePlay" -> lifecycleScope.launch(Dispatchers.IO) {
                    if (!isGooglePlayServicesAvailable(context)) return@launch
                    googleInAppReviewManager.showFeedbackDialog()
                    result.success(null)
                }
                "getPackageInfo" -> {
                    val buildName = BuildConfig.VERSION_NAME
                    val buildNumber = BuildConfig.VERSION_CODE

                    result.success(mapOf(
                        "packageName" to getString(R.string.application_name),
                        "buildNumber" to buildNumber,
                        "buildName" to buildName
                    ))
                }

                "setWindowPrivate" -> {
                    val secureWindow = call.arguments as Boolean?
                    if (secureWindow == null) {
                        result.error("NULL", "Secure argument is null", null)
                        return@setMethodCallHandler
                    }
                    if (secureWindow) {
                        window.setFlags(
                            WindowManager.LayoutParams.FLAG_SECURE,
                            WindowManager.LayoutParams.FLAG_SECURE
                        )
                        result.success(null)
                        return@setMethodCallHandler
                    }
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(null)
                }

                "shareText" -> {
                    val arguments = (call.arguments as Map<*, *>)
                    val text = arguments["text"] as String?
                    if (text == null) {
                        result.error("INVALID_PARAMETER", "Please enter a valid link", null)
                        return@setMethodCallHandler
                    }
                    val subject = arguments["subject"] as String?
                    try {
                        AppShare.shareText(text, subject, context)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error(e.localizedMessage ?: "UNKNOWN_ERROR", e.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
