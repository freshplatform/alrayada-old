package com.ahmedhnewa.alrayada.google

import android.app.Activity
import android.content.Context
import android.util.Log
import com.google.android.play.core.ktx.launchReview
import com.google.android.play.core.ktx.requestReview
import com.google.android.play.core.review.ReviewManagerFactory
import io.flutter.BuildConfig

class GoogleInAppReviewManager(
    context: Context,
    private val activity: Activity
) {
    companion object {
        private const val TAG = "GoogleInAppReviewManage"
    }

    private val reviewManager = ReviewManagerFactory.create(context)
    suspend fun showFeedbackDialog() {
        try {
            val reviewInfo = reviewManager.requestReview()
            reviewManager.launchReview(activity, reviewInfo)
        } catch (e: Exception) {
            log(e.message.toString())
        }
    }

    private fun log(message: String) {
        if (!BuildConfig.DEBUG) return
        Log.d(TAG, message)
    }
}