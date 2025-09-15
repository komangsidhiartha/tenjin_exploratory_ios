//
//  AppDelegate.swift
//  TenjinIosSdkExploratory
//
//  Created by Komang Sidhi Artha on 15/09/25.
//

import Foundation
import UIKit
import TenjinSDK

// This class will act as the traditional App Delegate.
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print(">> App did finish launching. Initializing Tenjin SDK...")
        
        // --- TENJIN SDK INITIALIZATION ---
        // This is the correct and safe place to call the SDK setup.
        TenjinSDK.getInstance("DVHECL19KPEYKNFXBXXH4RBZD2LEACPI")
        TenjinSDK.connect()
        TenjinSDK.debugLogs()
        // ---------------------------------
        
        return true
    }
}
