# Native iOS SDK Exploration: A Tenjin Integration & Xcode Bug Analysis

This repository documents a hands-on integration of the Tenjin iOS SDK into a native SwiftUI application.

What began as a standard SDK evaluation evolved into a deep-dive diagnosis of a critical Xcode bug that blocks the standard Swift Package Manager (SPM) workflow. This journey highlights the real-world challenges developers face with tooling instability and the methodical process required to overcome them and successfully integrate a legacy Objective-C SDK into a modern SwiftUI app.

This project is the third and final piece of a multi-platform analysis of the Tenjin developer experience. You can view the other two explorations here:
* [**Native Android (Kotlin/Compose) Exploration**](https://github.com/komangsidhiartha/tenjin-sdk-exploratory-android-compose)
* [**Flutter Exploration**](https://github.com/komangsidhiartha/tenjin_exploratory_sample_flutter)

## The Integration Journey: A Multi-Layered Challenge

### 1. Prerequisite: Dashboard Setup & Key Retrieval

Before any code can be written, the first step is to create an application within the Tenjin dashboard to obtain the necessary SDK Key. This presents the first point of friction in the onboarding flow, as the documentation jumps directly into code integration without first outlining this mandatory administrative step.

### 2. The Initial Blocker: A Critical Xcode SPM Bug

The standard procedure for adding an SPM package (`File > Add Packages...`) using the official Tenjin iOS SDK URL repeatedly failed with a misleading "Received invalid response" error. A methodical diagnostic process was undertaken:
1.  **Network Verification:** A `git clone` from the command line succeeded, proving the network and repository URL were valid.
2.  **Control Experiment:** An attempt to add Alamofire, a known-good package, also failed with the same error.
3.  **Diagnosis:** This sequence definitively proved the failure lies within **Xcode's remote package fetching mechanism**, not the Tenjin repository.
4.  **Workaround:** The repository was cloned locally and successfully added to the project using Xcode's "Add Local..." package option.

### 3. The Legacy Bridge: Integrating an Objective-C SDK

With the package added, the integration proceeded. As correctly stated in the Tenjin iOS SDK guide, the library is an Objective-C binary (`.xcframework`), not a pure Swift package. This required two manual configuration steps:
1.  **Objective-C Bridging Header:** A bridging header was created and configured to expose the Objective-C classes to the Swift code, as per the documentation.
2.  **Header Search Paths:** The build still failed with a `'TenjinSDK.h' file not found` error. The solution was to manually add the path to the framework's internal `Headers` directory in the project's "Header Search Paths" build setting. This is a common but undocumented final step when integrating local binary frameworks.

### 4. The Lifecycle Mismatch: SwiftUI and `didFinishLaunchingWithOptions`

The Tenjin SDK requires initialization in the `didFinishLaunchingWithOptions` method, which is absent in the modern SwiftUI app lifecycle. The correct, Apple-sanctioned solution was implemented:
* An `AppDelegate` class was created to house the SDK initialization logic.
* This class was attached to the SwiftUI App lifecycle using the `@UIApplicationDelegateAdaptor` property wrapper.

```swift
@main
struct YourApp: App {
  // Attach the App Delegate to the SwiftUI lifecycle
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
```

### 5. The Final Hurdle: Code Signing & Provisioning

Initial attempts to run on a physical device failed due to an expired personal developer account. The issue was resolved by correctly configuring the project's "Signing & Capabilities" to use an active developer account, allowing for successful deployment and testing on a physical device.

### How to Run This Project

1.  Clone the Tenjin iOS SDK repository to your local machine.
2.  In Xcode, add the SDK using **File > Add Packages... > Add Local...** and select the cloned directory.
3.  Configure the **Objective-C Bridging Header** as described in the Tenjin documentation.
4.  In **Build Settings**, add the path to the framework's `Headers` directory to **Header Search Paths**.
5.  In AppDelegate.swift, locate the application(_:didFinishLaunchingWithOptions:) method and replace "YOUR_TENJIN_API_KEY" with your key.
6.  Configure your **Signing & Capabilities** with an active developer account.
7.  Build and run on a physical iOS device.

## Key Findings & Developer Experience (DX) Suggestions

1.  **Xcode SPM Bug is a Major Blocker:** The most severe DX issue is an external bug in Xcode that blocks remote SPM integration. The Tenjin documentation could be enhanced with a "Troubleshooting" section that suggests the "Add Local..." workaround.
2.  **Documentation Inconsistency Across Platforms:** This investigation revealed a significant documentation parity issue across the Tenjin SDK ecosystem.
    * The **Native Android & iOS guides** are complete, including their respective mandatory setup steps (`AD_ID` permission and Bridging Header).
    * The **Flutter guide**, however, omits the mandatory `AD_ID` permission for Android, creating a critical information gap that blocks successful user attribution for cross-platform developers.
3.  **Modernization Gaps:** The SDK's reliance on Objective-C and the `AppDelegate` lifecycle creates friction for developers working in a pure SwiftUI environment. While documented, these steps represent a departure from modern, "plug-and-play" Swift packages.

## Conclusion

The Tenjin iOS SDK is functionally robust and works as expected on a physical device once the complex integration hurdles are overcome.

The primary opportunity for improving the developer experience lies in addressing ecosystem-wide consistency. By achieving documentation parity between the native and cross-platform guides, and by providing troubleshooting steps for common tooling failures like the Xcode SPM bug, Tenjin can create a smoother, more predictable, and more professional onboarding journey for all developers.
