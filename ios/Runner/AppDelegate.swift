import UIKit
import Flutter
import GoogleMaps
import Firebase // Import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Google Maps
        GMSServices.provideAPIKey("AIzaSyAK4M5dY-0P9pDc12nBdHnsmyCkFJMENSQ")
        
        // Configure Firebase
        FirebaseApp.configure()
        
        // Register Flutter plugins
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
