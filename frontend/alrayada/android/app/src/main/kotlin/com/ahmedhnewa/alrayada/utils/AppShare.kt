package com.ahmedhnewa.alrayada.utils

import android.content.Context
import android.util.Log
import androidx.core.app.ShareCompat
import com.ahmedhnewa.alrayada.R
import io.flutter.BuildConfig

object AppShare {
    private const val TAG = "AppShare"

    fun shareText(text: String, subject: String?, context: Context) {
        try {
            ShareCompat.IntentBuilder(context)
                .setType("text/plain")
                .setChooserTitle(R.string.choose_one)
                .setText(text)
                .setSubject(subject)
                .startChooser()
        } catch (e: Exception) {
            if (BuildConfig.DEBUG) {
                Log.d(TAG, "shareLink: error = ${e.message}")
            }
        }
    }
}