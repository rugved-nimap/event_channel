package com.example.event_channel;

import androidx.annotation.NonNull;

import java.util.Objects;
import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private final String EVENT_CHANNEL = "com.example.event_channel";
    private final String METHOD_CHANNEL = "com.example.method_channel";

    Timer timer = new Timer();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (Objects.equals(call.method, "getData")) {
                        result.success(Integer.toString(getRandomNumber()));
                    } else {
                        result.notImplemented();
                    }
                }
        );

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), EVENT_CHANNEL).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        startCounting(events);
                    }

                    @Override
                    public void onCancel(Object arguments) {

                    }
                }
        );
    }

    private void startCounting(final EventChannel.EventSink eventSink) {
        timer.schedule(
                new TimerTask() {
                    int count = 1;
                    @Override
                    public void run() {
                        runOnUiThread(() -> {
                            if (eventSink!=null) {
                                eventSink.success(count++);
                            }
                        });
                    }
                }, 0, 1000
        );
    }

    private int getRandomNumber() {
        Random random = new Random();
        return random.nextInt(1000);
    }

}
