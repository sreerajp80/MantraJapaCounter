import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("org.jetbrains.kotlin.plugin.compose") version "2.3.0"
    id("kotlin-kapt")
}

android {
    namespace = "com.sreerajp.mantrajapacounter"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.sreerajp.mantrajapacounter"
        minSdk = 29
        targetSdk = 35
        versionCode = 12
        versionName = "4.34"

        buildConfigField("long", "BUILD_TIME", System.currentTimeMillis().toString())

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary = true
        }
    }

    buildTypes {
        release {
            // SECURITY NOTE: Consider enabling minification for production builds
            // This provides code obfuscation and smaller APK size
            // Set to true and test thoroughly before release
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlin {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_17)
        }
    }
    buildFeatures {
        buildConfig = true
        compose = true
    }
    //composeOptions {
    //    kotlinCompilerExtensionVersion = "1.5.15"
    // }
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }

    // Custom APK naming configuration
    applicationVariants.all {
        outputs.forEach { output ->
            if (output is com.android.build.gradle.internal.api.BaseVariantOutputImpl) {
                val buildType = buildType.name
                val version = versionName

                output.outputFileName = when (buildType) {
                    "release" -> "MantraJapaCounter-v${version}.apk"
                    "debug" -> "MantraJapaCounter-v${version}-debug.apk"
                    else -> "MantraJapaCounter-${buildType}-v${version}.apk"
                }
            }
        }
    }

    sourceSets {
        // Adds exported schema location as test app assets
        getByName("androidTest").assets.srcDirs("$projectDir/schemas")
    }
}

dependencies {
    implementation(libs.androidx.core.ktx.v1170)
    implementation(libs.androidx.lifecycle.runtime.ktx.v293)
    implementation(libs.androidx.activity.compose.v1110)
    implementation(platform(libs.androidx.compose.bom.v20250900))
    implementation(libs.androidx.compose.ui)
    implementation(libs.androidx.compose.ui.graphics)
    implementation(libs.androidx.compose.ui.tooling.preview)
    implementation(libs.androidx.compose.material3)

    // Additional Compose dependencies
    implementation(libs.androidx.compose.material.icons.extended)
    implementation(libs.androidx.lifecycle.viewmodel.compose)

    // JSON serialization
    implementation(libs.gson)

    // SharedPreferences
    implementation(libs.androidx.preference.ktx)

    // Room components
    implementation(libs.androidx.room.runtime)
    implementation(libs.androidx.room.ktx)
    kapt(libs.androidx.room.compiler)

    // Window size class and insets for modern UI
    implementation(libs.androidx.compose.material3.window.size.class1)

    // Testing
    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit.v130)
    androidTestImplementation(libs.androidx.espresso.core.v370)
    androidTestImplementation(platform(libs.androidx.compose.bom.v20250900))
    androidTestImplementation(libs.androidx.compose.ui.test.junit4)
    debugImplementation(libs.androidx.compose.ui.tooling)
    debugImplementation(libs.androidx.compose.ui.test.manifest)
}

kapt {
    correctErrorTypes = true
    arguments {
        arg("room.schemaLocation", "$projectDir/schemas")
    }
}

// Configuration to resolve annotation conflicts
configurations.all {
    resolutionStrategy {
        force("org.jetbrains:annotations:23.0.0")
    }
}
