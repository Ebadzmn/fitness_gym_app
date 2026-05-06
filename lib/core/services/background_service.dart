import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String notificationChannelId = 'workout_timer_channel';
const int notificationId = 888;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // Create notification channel for Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId,
    'Workout Timer',
    description: 'This channel is used for workout timer notifications',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'Workout Session',
      initialNotificationContent: 'Stopwatch is ready',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer? timer;
  bool isRunning = false;
  
  // Persistence keys
  const String keyStartTime = 'workout_timer_start_time';
  const String keyOffsetSeconds = 'workout_timer_offset_seconds';
  const String keyIsRunning = 'workout_timer_is_running';

  final prefs = await SharedPreferences.getInstance();

  Future<void> updateTimer() async {
    final startTimeStr = prefs.getString(keyStartTime);
    final offsetSeconds = prefs.getInt(keyOffsetSeconds) ?? 0;
    
    int currentSeconds = offsetSeconds;
    if (startTimeStr != null) {
      final startTime = DateTime.parse(startTimeStr);
      currentSeconds += DateTime.now().difference(startTime).inSeconds;
    }

    service.invoke('update', {
      "seconds": currentSeconds,
    });

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "Workout Running",
          content: "Time: ${_formatDuration(currentSeconds)}",
        );
      }
    }
  }

  service.on('startTimer').listen((event) async {
    if (isRunning) return;
    
    isRunning = true;
    final now = DateTime.now();
    await prefs.setString(keyStartTime, now.toIso8601String());
    await prefs.setBool(keyIsRunning, true);

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) => updateTimer());
  });

  service.on('pauseTimer').listen((event) async {
    if (!isRunning) return;
    
    isRunning = false;
    timer?.cancel();

    final startTimeStr = prefs.getString(keyStartTime);
    final offsetSeconds = prefs.getInt(keyOffsetSeconds) ?? 0;
    
    if (startTimeStr != null) {
      final startTime = DateTime.parse(startTimeStr);
      final elapsedSinceStart = DateTime.now().difference(startTime).inSeconds;
      await prefs.setInt(keyOffsetSeconds, offsetSeconds + elapsedSinceStart);
      await prefs.remove(keyStartTime);
    }
    
    await prefs.setBool(keyIsRunning, false);
  });

  service.on('resetTimer').listen((event) async {
    isRunning = false;
    timer?.cancel();
    await prefs.remove(keyStartTime);
    await prefs.setInt(keyOffsetSeconds, 0);
    await prefs.setBool(keyIsRunning, false);
    
    service.invoke('update', {"seconds": 0});
  });

  // Resume state on start
  final persistedIsRunning = prefs.getBool(keyIsRunning) ?? false;
  if (persistedIsRunning) {
    isRunning = true;
    timer = Timer.periodic(const Duration(seconds: 1), (t) => updateTimer());
  } else {
    // Just sync the current offset
    final offset = prefs.getInt(keyOffsetSeconds) ?? 0;
    service.invoke('update', {"seconds": offset});
  }
}

String _formatDuration(int seconds) {
  final h = (seconds ~/ 3600).toString().padLeft(2, '0');
  final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
  final s = (seconds % 60).toString().padLeft(2, '0');
  return "$h:$m:$s";
}
