import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      // 自定义注册
      LaunchPlugin.register(with: registrar(forPlugin: "LaunchPlugin")!)
      
    let bl = super.application(application, didFinishLaunchingWithOptions: launchOptions)
      window.backgroundColor = UIColor.white
      return bl
  }
}


enum MethodType: String {
    case launch
}

class LaunchPlugin:NSObject, FlutterPlugin {
    
    static func register(with registrar: FlutterPluginRegistrar) {
        
        let instance:LaunchPlugin? = LaunchPlugin()
        
        // 初始化交互通道FlutterBasicMessageChannel
        let channel0 = FlutterMethodChannel(name: "flutter.launch", binaryMessenger: registrar.messenger())
        if instance == nil {
            channel0.setMethodCallHandler(nil)
        } else {
            channel0.setMethodCallHandler { call, callback in
                // msg来自flutter的数据
                // 拿到数据设置instance参数，或调用instance的方法作为参数传递
                // 在方法执行完将结果放入callback回调给flutter
                print("哈哈：\(call as Any)")
                if call.method == "onLaunch" {
                    let param = call.arguments as? [String: Any]
                    let result = instance?.onLaunch(params: param ?? [:])
                    callback(result)
                }else {
                    callback(0)
                }
                
            }
        }
        
        
        // 初始化交互通道FlutterMethodChannel
        let channel1 = FlutterMethodChannel(name: "native.launch", binaryMessenger: registrar.messenger())
        if let instance = instance {
            registrar.addMethodCallDelegate(instance, channel: channel1)
            
        }
        
        // 用于设置stream回调
//        let channel2 = FlutterEventChannel(name: "dev.flutter.stream.data", binaryMessenger: registrar.messenger())
//        channel2.setStreamHandler(&flutterStreamHandler)
        
        //可用于设置属性使用
        let basicChannel =  FlutterBasicMessageChannel(name: "AppLaunch.onTestBaseChannel", binaryMessenger: registrar.messenger())
        basicChannel.setMessageHandler { message, callback in
            print("message:\(message as Any)")
        }
        
        
    }
    // flutter调用方法
    func onLaunch(params: [String: Any])-> Int {
        print(params)
        return 1
    }
    
    // 协议代理
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getNativeData" {
            result([
                "type": MethodType.launch.rawValue,
                "message": "我是自定义注册组件的参数信息"
            ])
        }else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    
}

