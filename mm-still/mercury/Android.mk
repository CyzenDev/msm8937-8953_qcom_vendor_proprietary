ifneq ($(BUILD_TINY_ANDROID),true)

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

#===============================================================================
#             Deploy the headers that can be exposed
#===============================================================================

LOCAL_COPY_HEADERS_TO := mm-still/mercury
LOCAL_COPY_HEADERS += inc/mercury_lib.h

#===============================================================================
#             Compile Shared library libmercury.so
#===============================================================================

LOCAL_C_INCLUDES := $(LOCAL_PATH)/inc
ifneq ($(strip $(USE_BIONIC_HEADER)),true)
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../../hardware/qcom/camera
ifeq ($(TARGET_COMPILE_WITH_MSM_KERNEL),true)
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include/
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
endif
else
LOCAL_C_INCLUDES+= bionic/libc/kernel/common/media
endif

ifeq ($(strip $(TARGET_USES_ION)),true)
LOCAL_CFLAGS += -DUSE_ION
endif

ifeq ($(strip $(NEW_LOG_API)),true)
LOCAL_CFLAGS += -DNEW_LOG_API
endif

LOCAL_SRC_FILES := src/mercury_lib.c
LOCAL_SRC_FILES +=  src/mercury_lib_hw.c

LOCAL_SHARED_LIBRARIES := libcutils
LOCAL_MODULE := libmercury
LOCAL_MODULE_TAGS := optional
LOCAL_PRELINK_MODULE := false

LOCAL_MODULE_OWNER := qcom
LOCAL_PROPRIETARY_MODULE := true

LOCAL_32_BIT_ONLY := true
include $(BUILD_SHARED_LIBRARY)

#===============================================================================
#             Compile test app test_mercury
#===============================================================================

#include $(CLEAR_VARS)

#LOCAL_C_INCLUDES:= $(LOCAL_PATH)/inc
#LOCAL_C_INCLUDES+= $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include/media
#LOCAL_C_INCLUDES+= $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include/

#LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

#ifeq ($(strip $(TARGET_USES_ION)),true)
#LOCAL_CFLAGS += -DUSE_ION
#endif

#LOCAL_SRC_FILES := test/test_mercury.c
#LOCAL_SRC_FILES += test/mercury_app.c

#LOCAL_SHARED_LIBRARIES 	:= libmercury libcutils
#LOCAL_MODULE :=test_mercury
#LOCAL_MODULE_TAGS := optional

#include $(BUILD_EXECUTABLE)

endif #BUILD_TINY_ANDROID
