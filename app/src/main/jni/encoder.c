//
// Created by zhougang on 2019/7/31.
//

#include <jni.h>
#include <stdio.h>
#include "android/log.h"
#include "encoder.h"
#include "gst/gst.h"
#include <gst/app/gstappsink.h>
#include "stdlib.h"
gchar* dump_path;
static void Dump_H264(uint8_t* outbuf, gint size)
{
    static FILE* g_fp_264 = NULL;
    if (g_fp_264 == NULL)
    {
        g_fp_264 = fopen(dump_path, "wb");

    }
    if (g_fp_264 != NULL) {
        fwrite(outbuf, size, 1, g_fp_264);
    }

}
static GstFlowReturn new_sample(GstAppSink* gstappsink, gpointer opaque)
{

    GstSample* sample = gst_app_sink_pull_sample(gstappsink);
    GstBuffer* gst_buffer = gst_sample_get_buffer(sample);
    gst_buffer_ref(gst_buffer);
    gst_sample_unref(sample);
    GstMapInfo info;
    if (gst_buffer_map(gst_buffer,&info, GST_MAP_READ)) {
        Dump_H264(info.data, info.size);
        gst_buffer_unmap(gst_buffer, &info);
    }
    gst_buffer_unref(gst_buffer);
    return GST_FLOW_OK;
}

JNIEXPORT void
JNICALL Java_com_example_gstreamervideo_MainActivity_NativeStart(JNIEnv *env,jobject obj,jstring path){

    dump_path = (*env)->GetStringUTFChars(env, path, NULL);
    __android_log_print(6,"zhou","dump path: %s", dump_path);
#if defined(ANDROID)
    int x = 0;
    __android_log_print(6,"zhou","x：%d",x);
#endif
    gchar* desc =
            g_strdup_printf("autoaudiosrc ! openslessink");
    GError* err = NULL;
    __android_log_print(6,"zhou","GStreamer pipeline: %s", desc);

    GstElement* pipeline = gst_parse_launch_full(desc, NULL, GST_PARSE_FLAG_FATAL_ERRORS, &err);
    //GstAppSink* appsink = GST_APP_SINK(gst_bin_get_by_name(GST_BIN(pipeline), "sink"));
    //GstAppSinkCallbacks appsink_cbs = { NULL, NULL, &new_sample, {NULL} };
    //gst_app_sink_set_callbacks(appsink, &appsink_cbs, NULL, NULL);
    g_free(desc);
    if (!pipeline || err) {
        __android_log_print(6, "zhou", "GStreamer error: %s", err->message);
        g_clear_error(&err);
        return;
    }

    if (gst_element_set_state(pipeline, GST_STATE_PLAYING) == GST_STATE_CHANGE_FAILURE) {
        __android_log_write(6, "zhou", "set state failure");
        return;
    }
}
