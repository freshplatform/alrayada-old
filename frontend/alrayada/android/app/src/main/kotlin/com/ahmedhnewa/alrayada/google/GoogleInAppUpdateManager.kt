package com.ahmedhnewa.alrayada.google

import android.app.Activity.RESULT_OK
import android.util.Log
import android.widget.Toast
import androidx.lifecycle.lifecycleScope
import com.ahmedhnewa.alrayada.R
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.appupdate.AppUpdateOptions
import com.google.android.play.core.install.InstallStateUpdatedListener
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.InstallStatus
import com.google.android.play.core.install.model.UpdateAvailability
import com.google.android.play.core.ktx.isFlexibleUpdateAllowed
import com.google.android.play.core.ktx.isImmediateUpdateAllowed
import io.flutter.BuildConfig
import io.flutter.embedding.android.FlutterActivity
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await
import kotlin.time.Duration.Companion.seconds

class GoogleInAppUpdateManager(
    private val activity: FlutterActivity
) {
    private val appUpdateManager = AppUpdateManagerFactory.create(activity)
    private val appUpdateType = AppUpdateType.IMMEDIATE

    companion object {
        private const val TAG = "InAppUpdateManager"
    }

    private val installStateUpdatedListener = InstallStateUpdatedListener { state ->
        when(state.installStatus()) {
            InstallStatus.DOWNLOADING -> log("Downloading update ${state.bytesDownloaded()}...")
            InstallStatus.INSTALLING -> log("Installing the update...")
            InstallStatus.FAILED -> log("Install the update has been failed.")
            InstallStatus.CANCELED -> log("Install the update has been canceled.")
            InstallStatus.UNKNOWN -> log("Unknown error while install the update.")
            InstallStatus.INSTALLED -> log("The update has been successfully installed.")
            InstallStatus.DOWNLOADED -> {
                Toast.makeText(activity, R.string.in_app_update_download_successful_msg, Toast.LENGTH_SHORT).show()
                activity.lifecycleScope.launch(Dispatchers.IO) {
                    delay(5.seconds)
                    appUpdateManager.completeUpdate().await()
                }
            }
            else -> Unit
        }
    }

    init {
        if (appUpdateType == AppUpdateType.FLEXIBLE) {
            appUpdateManager.registerListener(installStateUpdatedListener)
        }
    }

    fun unregisterUpdateListener() {
        if (appUpdateType == AppUpdateType.FLEXIBLE) {
            appUpdateManager.unregisterListener(installStateUpdatedListener)
        }
    }

    private fun log(message: String) {
        if (!BuildConfig.DEBUG) return
        Log.d(TAG, message)
    }

    suspend fun onResumeAppUpdate() {
        log("${GoogleInAppUpdateManager::onResumeAppUpdate.name}() has been called")
        if (appUpdateType != AppUpdateType.IMMEDIATE) return
        try {
            val appUpdateInfo = appUpdateManager.appUpdateInfo.await()
            if (appUpdateInfo.updateAvailability() != UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS) {
                return
            }
            val result = appUpdateManager.startUpdateFlow(
                appUpdateInfo,
                activity,
                AppUpdateOptions.defaultOptions(AppUpdateType.FLEXIBLE)
            ).await()
            log("${GoogleInAppUpdateManager::onResumeAppUpdate.name}() result is $result")
        } catch (e: Exception) {
            log("exception in ${GoogleInAppUpdateManager::onResumeAppUpdate.name}() ${e.message}")
        }
    }

    suspend fun updateApp(): Boolean {
        log("${GoogleInAppUpdateManager::updateApp.name}() has been called")
        return try {
            val appUpdateInfo = appUpdateManager.appUpdateInfo.await()
            val isUpdateAllowed = when(appUpdateType) {
                AppUpdateType.IMMEDIATE -> appUpdateInfo.isImmediateUpdateAllowed
                AppUpdateType.FLEXIBLE -> appUpdateInfo.isFlexibleUpdateAllowed
                else -> false
            }
            if (appUpdateInfo.updateAvailability() != UpdateAvailability.UPDATE_AVAILABLE) return false
            if (!isUpdateAllowed) return false
            val result = appUpdateManager.startUpdateFlow(
                appUpdateInfo,
                activity,
                AppUpdateOptions.defaultOptions(appUpdateType)
            ).await()
            log("${GoogleInAppUpdateManager::updateApp.name}() result is $result")
            result == RESULT_OK
        } catch (e: Exception) {
            log("exception in ${GoogleInAppUpdateManager::updateApp.name}() ${e.message}")
            false
        }
    }

}