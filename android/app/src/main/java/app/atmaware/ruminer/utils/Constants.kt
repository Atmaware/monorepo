package app.atmaware.ruminer.utils

import app.atmaware.ruminer.BuildConfig

object Constants {
  const val apiURL = BuildConfig.RUMINER_API_URL
  const val dataStoreName = "ruminer-datastore"
}

object AppleConstants {
    const val clientId = "app.ruminer"
    const val redirectURI = BuildConfig.RUMINER_API_URL + "/api/mobile-auth/android-apple-redirect"
    const val scope = "name%20email"
    const val authUrl = "https://appleid.apple.com/auth/authorize"
}

const val FORGOT_PASSWORD_URL = "${BuildConfig.RUMINER_WEB_URL}/auth/forgot-password"
const val SELF_HOSTING_URL = "https://docs.ruminer.app/self-hosting/self-hosting.html"
