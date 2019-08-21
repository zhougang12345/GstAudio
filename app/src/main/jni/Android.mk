LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := gstvideo
LOCAL_SRC_FILES := encoder.c

LOCAL_SHARED_LIBRARIES := gstreamer_android
LOCAL_LDLIBS := -llog -landroid -lEGL -lGLESv2 -ljnigraphics
include $(BUILD_SHARED_LIBRARY)

ifndef GSTREAMER_ROOT_ANDROID
$(error GSTREAMER_ROOT_ANDROID is not defined!)
endif

ifeq ($(TARGET_ARCH_ABI),armeabi)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/arm
else ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/armv7
else ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/arm64
else ifeq ($(TARGET_ARCH_ABI),x86)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/x86
else ifeq ($(TARGET_ARCH_ABI),x86_64)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/x86_64
else
$(error Target arch ABI not supported: $(TARGET_ARCH_ABI))
endif

GSTREAMER_NDK_BUILD_PATH  := $(GSTREAMER_ROOT)/share/gst-android/ndk-build/

include $(GSTREAMER_NDK_BUILD_PATH)/plugins.mk
GSTREAMER_PLUGINS         := $(GSTREAMER_PLUGINS_CORE)      \
                             $(GSTREAMER_PLUGINS_PLAYBACK)  \
                             $(GSTREAMER_PLUGINS_CODECS)    \
                             $(GSTREAMER_PLUGINS_NET)       \
                             $(GSTREAMER_PLUGINS_SYS)       \
                             $(GSTREAMER_PLUGINS_CODECS_RESTRICTED) \
                             $(GSTREAMER_CODECS_GPL)        \
                             $(GSTREAMER_PLUGINS_ENCODING)  \
                             $(GSTREAMER_PLUGINS_VIS)       \
                             $(GSTREAMER_PLUGINS_EFFECTS)   \
                             $(GSTREAMER_PLUGINS_NET_RESTRICTED)
G_IO_MODULES              := gnutls
GSTREAMER_EXTRA_DEPS      := gstreamer-player-1.0 gstreamer-video-1.0 glib-2.0 gstreamer-gl-1.0 gstreamer-app-1.0

include $(GSTREAMER_NDK_BUILD_PATH)/gstreamer-1.0.mk
