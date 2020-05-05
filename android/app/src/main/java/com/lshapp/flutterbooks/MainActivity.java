package com.lshapp.flutterbooks;

import static android.Manifest.permission.CAMERA;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import android.util.Log;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
/**
 * @author longshaohua
 */
public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.io/permission";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if ("requestCameraPermissions".equals(call.method)) {
                        result.success(requestCameraPermissions());
                    } else if ("launchURL".equals(call.method)) {
                        launchURL(call.argument("url"));
                    } else {
                        result.notImplemented();
                    }
                });
    }

    private String requestCameraPermissions() {
        //判断是否授权了相机权限，以及版本是否大于 23 Build.VERSION_CODES.M
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                ContextCompat.checkSelfPermission(
                        this,
                        CAMERA
                ) != PackageManager.PERMISSION_GRANTED

        ) {
            requestPermissions(new String[]{CAMERA}, 1);
            return "请求权限";
        } else {
            //已授权，或者低于 23 Build.VERSION_CODES.M 无需要授权
            return "已经授权";
        }
    }

    private void launchURL(String url) {
        Log.d("launchURL","launchURL="+url);
        Intent intent = new Intent();
        intent.setAction("android.intent.action.VIEW");
        Uri contentUrl = Uri.parse(url);
        intent.setData(contentUrl);
        startActivity(intent);
    }

}
