
import SwiftUI
import AppTrackingTransparency
import AdSupport
import FirebaseCore
import FirebaseAnalytics
import FirebaseInstallations
import FirebaseRemoteConfigInternal

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    weak var initialVC: ViewController?
    
    var identifierAdvertising: String = ""
    var timer = 0
    var analyticsAppId: String = ""

    static var orientationLock = UIInterfaceOrientationMask.all
    
    private var myOwnDatabaseExternalId = ""
    private var remoteConfig: RemoteConfig?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        remoteConfig = RemoteConfig.remoteConfig()
        setupRemoteConfig()
        
        let viewController = ViewController()
        initialVC = viewController
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
        
        Task { @MainActor in
            analyticsAppId = await fetchAnalyticsAppInstanceId()
            myOwnDatabaseExternalId = analyticsAppId

            print("App Instance ID: \(analyticsAppId)")
        }

        start(viewController: viewController)
       
        return true
    }
    
    func fetchAnalyticsAppInstanceId() async -> String {
        do {
            if let appInstanceID = Analytics.appInstanceID() {
                return appInstanceID
            } else {
                return ""
            }
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    func setupRemoteConfig() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig?.configSettings = settings
    }
    
    func start(viewController: ViewController) {
        
        remoteConfig?.fetch { [weak self] status, error in
            guard let self = self else { return }

            if status == .success {
                self.remoteConfig?.activate { _, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            viewController.openApp()
                            return
                        }

                        if let stringFire = self.remoteConfig?.configValue(forKey: "code").stringValue {
                            if !stringFire.isEmpty {
                                if let finalURL = UserDefaults.standard.string(forKey: "finalURL") {
                                    viewController.openWeb(stringURL: finalURL)
                                    print("SECOND OPEN: \(finalURL)")
                                    return
                                }

                                if self.identifierAdvertising.isEmpty {
                                    self.timer = 5
                                    self.identifierAdvertising = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                                }

                                if self.identifierAdvertising.isEmpty {
                                    viewController.openApp()
                                    return
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(self.timer)) {
                                    let stringURL = viewController.createURL(
                                        mainURL: stringFire,
                                        deviceID: self.analyticsAppId,
                                        advertiseID: self.identifierAdvertising
                                    )
                                    print("URL: \(stringURL)")

                                    guard let url = URL(string: stringURL) else {
                                        viewController.openApp()
                                        return
                                    }

                                    if UIApplication.shared.canOpenURL(url) {
                                        viewController.openWeb(stringURL: stringURL)
                                    } else {
                                        viewController.openApp()
                                    }
                                }

                            } else {
                                viewController.openApp()
                            }
                        } else {
                            viewController.openApp()
                        }
                    }
                }
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        ATTrackingManager.requestTrackingAuthorization { (status) in
            self.timer = 10
            switch status {
            case .authorized:
                self.identifierAdvertising = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                self.timer = 1
            case .denied:
                print("Denied")
                self.identifierAdvertising = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            case .notDetermined:
                print("Not Determined")
            case .restricted:
                print("Restricted")
            @unknown default:
                print("Unknown")
            }
        }
    }
}

