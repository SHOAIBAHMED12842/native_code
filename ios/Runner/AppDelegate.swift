import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
  FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"course.flutter.dev/battery"
                                          binaryMessenger:controller];
  
  __weak typeof(self) weakSelf = self;
  [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    if ([@"getBatteryLevel" isEqualToString:call.method]) {
      int batteryLevel = [weakSelf getBatteryLevel];

      if (batteryLevel == -1) {
        result([FlutterError errorWithCode:@"UNAVAILABLE"
                              message:@"Battery info not available."
                              details:nil]);
      } else {
        result(@(batteryLevel));
      }
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions);
  }
  - (int)getBatteryLevel {
  UIDevice* device = UIDevice.currentDevice;
  device.batteryMonitoringEnabled = YES;
  if (device.batteryState == UIDeviceBatteryStateUnknown) {
    return -1;
  } else {
    return (int)(device.batteryLevel * 100);
  }
}
}
