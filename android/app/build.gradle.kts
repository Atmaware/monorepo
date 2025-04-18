import java.io.FileInputStream
import java.util.Properties

plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.org.jetbrains.kotlin.android)
    id("dagger.hilt.android.plugin")
    alias(libs.plugins.ksp)
    alias(libs.plugins.apollo)
    alias(libs.plugins.compose.compiler)
}

val keystorePropertiesFile = rootProject.file("app/external/keystore.properties")
val keystoreProperties = Properties()

if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { input ->
        keystoreProperties.load(input)
    }
}

android {
    namespace = "app.atmaware.ruminer"

    compileSdk = 34

    defaultConfig {
        applicationId = "app.atmaware.ruminer"
        minSdk = 26
        targetSdk = 34
        versionCode = 2260000
        versionName = "0.226.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary = true
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = "key0"
            storeFile = file("external/ruminer-prod.keystore")
            storePassword = keystoreProperties["prodStorePassword"] as String?
            keyPassword = keystoreProperties["prodKeyPassword"] as String?
        }/*        debug {
                    if (keystoreProperties["demoStorePassword"] && keystoreProperties["demoKeyPassword"]) {
                        keyAlias = "androiddebugkey"
                        storeFile = file("external/ruminer-demo.keystore")
                        storePassword = keystoreProperties["demoStorePassword"] as String
                        keyPassword = keystoreProperties["demoKeyPassword"] as String
                    }
                }*/
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug")
            applicationIdSuffix = ".debug"
            buildConfigField("String", "RUMINER_API_URL", "\"https://ruminer.atmaware.com\"")
            buildConfigField("String", "RUMINER_WEB_URL", "\"https://ruminer.atmaware.com\"")
            buildConfigField(
                "String",
                "RUMINER_GAUTH_SERVER_CLIENT_ID",
                "\"129117411613-c8tjthrdqh47a5of25kvq24dmnoifc9r.apps.googleusercontent.com\""
            )
        }
        release {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("release")
            buildConfigField("String", "RUMINER_API_URL", "\"https://ruminer.atmaware.com\"")
            buildConfigField("String", "RUMINER_WEB_URL", "\"https://ruminer.atmaware.com\"")
            buildConfigField(
                "String",
                "RUMINER_GAUTH_SERVER_CLIENT_ID",
                "\"129117411613-jcs5lqvik173qkqbccp9i4ckcbc1sul9.apps.googleusercontent.com\""
            )
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }
    buildFeatures {
        compose = true
        buildConfig = true
    }

    packaging {
        resources {
            excludes += listOf("/META-INF/{AL2.0,LGPL2.1}")
        }
    }
}

dependencies {

    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)

    implementation(libs.androidx.credentials.auth)
    implementation(libs.androidx.credentials)
    implementation(libs.googleid)

    val bom = platform(libs.androidx.compose.bom)
    implementation(bom)
    androidTestImplementation(bom)
    implementation(libs.androidx.compose.material)
    implementation(libs.androidx.compose.material.iconsExtended)
    implementation(libs.androidx.compose.material3)
    implementation(libs.androidx.compose.ui.tooling.preview)
    implementation(libs.androidx.compose.ui.util)
    implementation(libs.androidx.activity.compose)
    implementation(libs.androidx.navigation.compose)
    implementation(libs.androidx.hilt.navigation.compose)
    androidTestImplementation(libs.androidx.compose.ui.test)
    debugImplementation(libs.androidx.compose.ui.tooling)
    debugImplementation(libs.androidx.compose.ui.tooling.preview)
    debugImplementation(libs.androidx.compose.ui.testManifest)

    testImplementation(libs.junit4)
    androidTestImplementation(libs.androidx.test.ext)
    androidTestImplementation(libs.androidx.test.espresso.core)

    implementation(libs.androidx.lifecycle.viewModelKtx)
    implementation(libs.androidx.lifecycle.viewModelCompose)
    implementation(libs.androidx.lifecycle.viewmodelSavedstate)

    implementation(libs.androidx.lifecycle.livedata.ktx)
    implementation(libs.androidx.compose.runtime.livedata)

    implementation(libs.retrofit.core)
    implementation(libs.retrofit.converter.gson)

    implementation(libs.kotlinx.coroutines.android)

    implementation(libs.androidx.security.crypto)
    implementation(libs.androidx.dataStore.preferences)

    implementation(libs.hilt.android)
    ksp(libs.hilt.compiler)

    implementation(libs.apollo.runtime)

    implementation(libs.accompanist.flowlayout)

    implementation(libs.coil.kt.compose)

    implementation(libs.room.runtime)
    implementation(libs.room.ktx)
    annotationProcessor(libs.room.compiler)
    ksp(libs.room.compiler)

    implementation(libs.gson)
    implementation(libs.pspdfkit)
    implementation(libs.posthog)
    implementation(libs.intercom)
    implementation(libs.compose.markdown)
    implementation(libs.chiptextfield.m3)

    implementation(libs.androidx.lifecycle.runtimeCompose)

    implementation(libs.androidx.core.splashscreen)

    implementation(libs.work.runtime.ktx)
    implementation(libs.hilt.work)
    ksp(libs.hilt.work.compiler)
}

apollo {
    service("service") {
        outputDirConnection {
            connectToKotlinSourceSet("main")
        }
        packageName.set("app.atmaware.ruminer.graphql.generated")
    }
}

tasks.register("printVersion") {
    doLast {
        println("ruminerVersion: ${android.defaultConfig.versionName}")
    }
}
