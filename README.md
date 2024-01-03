# Fresh Platform

An ecommerce application developed by Fresh Platform for Alrayada company.

## Getting Started

# Global
Init the flutter-fire in the project
Edit Constants
Edit ServerConfigurations in shared package

# App links paths:
/products
/orders/paymentGateways/zainCashRedirect

# Ios
SERVER_CLIENT_ID in ios/Runner/GoogleService-Info.plist
Manage the signing of the app using Xcode

apple-app-site-association in .well-known and generate it with help of [This](https://youtu.be/IEXn7QIwPFo) and [this](https://developer.apple.com/documentation/xcode/supporting-associated-domains)
Also don't forget to update Associated domains in Xcode signing and capabilities

And also setup the sign in web service in apple developer
and the upload push notifications key to Firebase messaging

# Android
Add the upload-keystore.jks and key.properties for app upload signing

assetlinks.json in .well-known and generate the file using [This](https://developers.google.com/digital-asset-links/tools/generator)
Also don't forget to update AndroidManifest.xml, the domain verification
Add sign in with apple redirection and others...


    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

      <application
        android:name="${applicationName}"
        android:enableOnBackInvokedCallback="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/application_name"
        android:localeConfig="@xml/locales_config">
        <activity

            <meta-data
                android:name="flutter_deeplinking_enabled"
                android:value="true" />

            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW" />

                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />

                <data
                    android:host="api.alrayada.net"
                    android:pathPrefix="/products"
                    android:scheme="https" />
            </intent-filter>

        </activity>
        <!-- Don't delete the meta-data below.
             This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />

        <!-- Set up the Sign in with Apple activity, such that it's callable from the browser-redirect -->
        <activity
            android:name="com.aboutyou.dart_packages.sign_in_with_apple.SignInWithAppleCallback"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />

                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />

                <data android:scheme="signinwithapple" />
                <data android:path="/callback" />
            </intent-filter>
        </activity>

        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="@string/default_notification_channel_id" />

    </application>


    <queries>
        <intent>
            <action android:name="android.intent.action.VIEW" />
            <data android:scheme="tel" />
        </intent>
    </queries>

# Web
google-signin-client_id meta value and description