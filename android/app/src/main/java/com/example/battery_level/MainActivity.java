package com.example.battery_level;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import androidx.annotation.NonNull;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL1 = "samples.flutter.dev/battery";
    private static final String CHANNEL2 = "samples.flutter.dev/myMethodChannel";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL1)
            .setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("getBatteryLevel")) {
                        int batteryLevel = getBatteryLevel();

                        if (batteryLevel != -1) {
                            result.success(batteryLevel);
                        } else {
                            result.error("UNAVAILABLE", "Battery level not available.", null);
                        }
                    } else {
                        result.notImplemented();
                    }
                }
            );

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL2)
                .setMethodCallHandler( new MyMethodChannel());
    }

    private int getBatteryLevel() {
        int batteryLevel = -1;
        if(VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
            batteryLevel =  batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        }
        else {
            Intent intent = new ContextWrapper(getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }

        return batteryLevel;
    }

}

class MyMethodChannel implements MethodCallHandler {

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "myChannelCalled":
                Log.d("tag1","custom method is called1");
                result.success(this.myChannelCalled());
                break;
            case "myChannelCalledWithArg":
                final String creator = call.argument("created");
                Log.d("tag2","custom method is called2");
                result.success(this.myChannelCalledWithArg(creator));
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private String myChannelCalled() {
        return "hi~ I'm MyMethodChannel in android";
    }

    private String myChannelCalledWithArg(String creator) {
        return creator;
    }

}
