# Triangle Tots iOS App

Native iOS app for Triangle Tots using Turbo Native.

## Quick Start

1. Read [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md) for detailed setup steps
2. Install Xcode 15+ from Mac App Store
3. Install CocoaPods: `sudo gem install cocoapods`
4. Follow the setup instructions to create the Xcode project

## Project Structure

```
ios-app/
├── SETUP_INSTRUCTIONS.md          # Detailed setup guide
├── README.md                        # This file
├── Podfile                         # CocoaPods dependencies
├── TurboConfig.json                # Turbo Native path configuration
└── TriangleTots/
    ├── AppDelegate.swift           # App lifecycle
    ├── SceneDelegate.swift         # Main session and navigation
    ├── Configuration/
    │   └── AppConfiguration.swift  # Server URLs and app config
    ├── Bridge/
    │   ├── LocationBridge.swift    # Native location → Web
    │   └── StorageBridge.swift     # Native storage → Web
    ├── Storage/
    │   ├── LocationStore.swift     # UserDefaults for location
    │   └── InteractionStore.swift  # UserDefaults for interactions
    └── Navigation/
        └── TabBarController.swift  # (future) Custom tab bar
```

## Features

### Implemented

✅ **Turbo Native Shell**
- Tab bar navigation (Now / Weekend / All)
- Native navigation stack
- Session management with cookies

✅ **Location Bridge**
- Native CLLocationManager integration
- Permission handling
- Automatic location injection into requests
- Location persistence in UserDefaults

✅ **Storage Bridge**
- Native storage for ratings (thumbs up/down)
- Native storage for "mark as done"
- Automatic sync with Rails backend
- Persists across app restarts

✅ **Native Navigation**
- Push/replace/modal presentation modes
- Back button handling
- Tab switching with state preservation

### To Be Added (Phase 4)

- Pull-to-refresh
- Native sharing
- Push notifications
- Offline detection
- App icons and launch screen

## Development

### Running Locally

1. Start Rails server:
   ```bash
   cd "/Users/tobiaskahn/Documents/code/triangle tots"
   bin/rails server
   ```

2. Open in Xcode:
   ```bash
   cd ios-app
   open TriangleTots.xcworkspace
   ```

3. Select simulator and press Cmd+R to run

### Testing on Device

1. Connect iPhone/iPad via USB
2. In Xcode, select your device from the device dropdown
3. Update `Configuration/AppConfiguration.swift` with your computer's IP:
   ```swift
   static let baseURL = URL(string: "http://YOUR_IP:3000")!
   ```
4. Press Cmd+R to build and run

### Debugging

- **View web console**: In Xcode → Debug → View Debugging → Captured View Hierarchy
- **Print statements**: View in Xcode console (Cmd+Shift+Y)
- **Network requests**: Enable logging in SceneDelegate

## Configuration

### URLs

Edit [Configuration/AppConfiguration.swift](TriangleTots/Configuration/AppConfiguration.swift):

```swift
#if DEBUG
static let baseURL = URL(string: "http://localhost:3000")!
#else
static let baseURL = URL(string: "https://your-production-url.com")!
#endif
```

### Turbo Navigation

Edit [TurboConfig.json](TurboConfig.json) to configure:
- Which URLs open in modals
- Which URLs push vs replace
- URL patterns for different behaviors

## Troubleshooting

See [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md#troubleshooting) for common issues and solutions.

## Next Steps

1. ✅ Create Xcode project
2. ✅ Install dependencies
3. ✅ Add Swift files
4. ✅ Configure Info.plist
5. ✅ Test in simulator
6. ⬜ Test on real device
7. ⬜ Add app icon
8. ⬜ Configure for TestFlight
9. ⬜ Submit to App Store

## Resources

- [Turbo Native iOS Documentation](https://github.com/hotwired/turbo-ios)
- [Main Implementation Plan](../ios_plans.md)
- [Rails Backend Changes](../README.md)
