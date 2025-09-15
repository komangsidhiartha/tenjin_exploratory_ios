//
//  TenjinIosSdkExploratoryApp.swift
//  TenjinIosSdkExploratory
//
//  Created by Komang Sidhi Artha on 14/09/25.
//

import SwiftUI

@main
struct TenjinIosSdkExploratoryApp: App {
    
    // We need to attach this so that the appDelegate lifecycle is hte correct AppDelegate when it is called within SwiftUI lifecycle
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
