package com.example.gstreamervideo;

import android.app.ActionBar;
import android.content.Context;
import android.os.Environment;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;
import org.freedesktop.gstreamer.GStreamer;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        try {
            init(this);
        } catch (Exception e) {
            Toast.makeText(this, e.getMessage(), Toast.LENGTH_LONG).show();
            finish();
            return;
        }
        setContentView(R.layout.activity_main);
        String str = Environment.getExternalStorageDirectory().getAbsolutePath() + "/output.h264";
        Log.i("zhou","path:" + str);
        NativeStart(str);
    }
    public static void init(Context context) throws Exception {
        System.loadLibrary("gstreamer_android");
        GStreamer.init(context);
        System.loadLibrary("gstvideo");
    }

    public native void NativeStart(String str);
}
