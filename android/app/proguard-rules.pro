# Prevent ImageIO classes from being stripped
-dontwarn javax.imageio.**
-dontwarn com.github.jaiimageio.**

-keep class javax.imageio.** { *; }
-keep class com.github.jaiimageio.** { *; }

# QR Code Tools plugin keep rules
-keep class com.aifeii.qrcode.** { *; }

# Keep service provider classes (SPI)
-keep class **.spi.** { *; }






# --- OkHttp ---
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

# --- uCrop ---
-keep class com.yalantis.ucrop.** { *; }
-dontwarn com.yalantis.ucrop.**



# Gson
-keep class com.google.gson.** { *; }

# Lifecycle
-keep class androidx.lifecycle.** { *; }

