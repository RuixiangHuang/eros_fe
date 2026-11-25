import UIKit
import Flutter
import flutter_downloader

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)

        // 使用 UIScene 生命周期后，applicationDidEnterBackground 等回调不再触发，
        // 改为监听 scene 通知来处理最近任务中的模糊效果
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(sceneDidEnterBackground(_:)),
                           name: UIScene.didEnterBackgroundNotification, object: nil)
        center.addObserver(self, selector: #selector(sceneDidBecomeActive(_:)),
                           name: UIScene.didActivateNotification, object: nil)
        center.addObserver(self, selector: #selector(sceneWillEnterForeground(_:)),
                           name: UIScene.willEnterForegroundNotification, object: nil)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // UIScene 生命周期下，插件在隐式引擎创建后注册
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    }

    @objc func step(displaylink: CADisplayLink) {
        // Will be called once a frame has been built while matching desired frame rate
    }

    @objc private func sceneDidEnterBackground(_ notification: Notification) {
        print("sceneDidEnterBackground")
        addBlurEffect(window: Self.window(of: notification))
    }

    @objc private func sceneDidBecomeActive(_ notification: Notification) {
        print("sceneDidBecomeActive")
        SecurityBlurEffect.removeBlurEffect(window: Self.window(of: notification))
    }

    @objc private func sceneWillEnterForeground(_ notification: Notification) {
        print("sceneWillEnterForeground")
        SecurityBlurEffect.removeBlurEffect(window: Self.window(of: notification))
    }

    private static func window(of notification: Notification) -> UIWindow? {
        guard let scene = notification.object as? UIWindowScene else { return nil }
        return scene.windows.first(where: { $0.isKeyWindow }) ?? scene.windows.first
    }

    func addBlurEffect(window: UIWindow?) {
        let BLURRED_IN_RECENT_TASK = "flutter.blurredInRecentTasks"

        let isBlurredInRecentTasks = UserDefaults.standard.bool(forKey: BLURRED_IN_RECENT_TASK)

        print("isBlurredInRecentTasks :", isBlurredInRecentTasks)
        if isBlurredInRecentTasks {
            SecurityBlurEffect.addBlurEffect(window: window)
        }
    }
}

private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
        FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}
