package app.ruminer.ruminer.utils

import app.ruminer.ruminer.BuildConfig

object Constants {
  const val apiURL = BuildConfig.OMNIVORE_API_URL
  const val dataStoreName = "ruminer-datastore"
}

object AppleConstants {
    const val clientId = "app.ruminer"
    const val redirectURI = BuildConfig.OMNIVORE_API_URL + "/api/mobile-auth/android-apple-redirect"
    const val scope = "name%20email"
    const val authUrl = "https://appleid.apple.com/auth/authorize"
}

const val FORGOT_PASSWORD_URL = "${BuildConfig.OMNIVORE_WEB_URL}/auth/forgot-password"
const val SELF_HOSTING_URL = "https://docs.ruminer.app/self-hosting/self-hosting.html"
