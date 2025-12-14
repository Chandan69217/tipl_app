# Prevent ImageIO classes from being stripped
-dontwarn javax.imageio.**
-dontwarn com.github.jaiimageio.**

-keep class javax.imageio.** { *; }
-keep class com.github.jaiimageio.** { *; }

# QR Code Tools plugin keep rules
-keep class com.aifeii.qrcode.** { *; }

# Keep service provider classes (SPI)
-keep class **.spi.** { *; }
