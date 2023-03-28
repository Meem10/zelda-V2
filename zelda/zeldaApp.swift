//
//  zeldaApp.swift
//  zelda
//
//  Created by Aamer Essa on 14/01/2023.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

//import FBSDKCoreKit


class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
//      FBSDKCoreKit.ApplicationDelegate.shared.application(
//          application,
//          didFinishLaunchingWithOptions: launchOptions
//      )
    return true
  }
    @available(iOS 9.0, *)
    func application(
                _ app: UIApplication,
                open url: URL,
                options: [UIApplication.OpenURLOptionsKey : Any] = [:]
            ) -> Bool {
                var flag:Bool = false
//                if ApplicationDelegate.shared.application(app,open: url,sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//                ){
//                   flag = ApplicationDelegate.shared.application(
//                        app,
//                        open: url,
//                        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                        annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//                    )
                    
//                } else {
                   flag = GIDSignIn.sharedInstance.handle(url)
                //}
                
                return flag
            }
    
    

}

@main
struct zeldaApp: App {
    
    @StateObject var appState = AppState.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
          
        
            
        }
    }
}

class AppState: ObservableObject{
    static let shared = AppState()
    @Published var gameID = UUID()
}
