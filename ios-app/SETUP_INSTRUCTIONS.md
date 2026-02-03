# Triangle Tots iOS App Setup Instructions

## Prerequisites

1. **Install Xcode 15+** from the Mac App Store
2. **Install CocoaPods**: `sudo gem install cocoapods`
3. **Enroll in Apple Developer Program** ($99/year) - required for TestFlight and App Store

## Step 1: Create Xcode Project

1. Open Xcode
2. Click "Create New Project"
3. Choose "iOS" → "App"
4. Click "Next"
5. Fill in project details:
   - **Product Name**: TriangleTots
   - **Team**: Select your Apple Developer team
   - **Organization Identifier**: com.yourcompany (use your domain in reverse)
   - **Interface**: Storyboard
   - **Language**: Swift
   - **Storage**: None
6. Click "Next"
7. Choose this `ios-app` folder as the location
8. Click "Create"

## Step 2: Install Dependencies

1. In Terminal, navigate to the ios-app folder:
   ```bash
   cd "/Users/tobiaskahn/Documents/code/triangle tots/ios-app"
   ```

2. Install CocoaPods dependencies:
   ```bash
   pod install
   ```

3. **IMPORTANT**: From now on, always open `TriangleTots.xcworkspace` (NOT .xcodeproj)

## Step 3: Copy Swift Files

1. In Xcode, right-click on the "TriangleTots" folder in the Project Navigator
2. Select "Add Files to TriangleTots..."
3. Navigate to the `ios-app/TriangleTots` folder we created
4. Select ALL the folders (Configuration, Bridge, Navigation, Storage)
5. Make sure "Copy items if needed" is CHECKED
6. Make sure "Create groups" is selected
7. Click "Add"

## Step 4: Add TurboConfig.json

1. In Xcode, right-click on "TriangleTots" folder
2. Select "New File..."
3. Choose "Empty" file
4. Name it `TurboConfig.json`
5. Paste the content from `TurboConfig.json` in the ios-app folder

## Step 5: Update Info.plist

1. In Xcode, open `Info.plist`
2. Right-click in the file → "Add Row"
3. Add the following keys:

**Location Permission:**
- Key: `NSLocationWhenInUseUsageDescription`
- Type: String
- Value: `We need your location to show activities near you and calculate distances.`

**Allow HTTP (for local development):**
- Key: `NSAppTransportSecurity`
- Type: Dictionary
  - Add child: `NSAllowsArbitraryLoads`
  - Type: Boolean
  - Value: YES

## Step 6: Configure App URLs

1. Open `Configuration/AppConfiguration.swift`
2. Update the URLs:
   - For local development: `http://localhost:3000`
   - For production: Your production URL

## Step 7: Update AppDelegate and SceneDelegate

Replace the default `AppDelegate.swift` and `SceneDelegate.swift` with the versions in the `ios-app/TriangleTots` folder.

## Step 8: Build and Run

1. In Xcode, select a simulator (iPhone 15 Pro recommended)
2. Click the "Play" button (or press Cmd+R)
3. The app should build and launch in the simulator

## Step 9: Test with Local Rails Server

1. Make sure your Rails server is running:
   ```bash
   cd "/Users/tobiaskahn/Documents/code/triangle tots"
   bin/rails server
   ```

2. In the iOS simulator, the app should load your Triangle Tots web app
3. Grant location permission when prompted
4. Test interactions:
   - Browse activities
   - Thumbs up/down (should use native storage)
   - Mark as done
   - Change location

## Troubleshooting

### "Could not find module 'Turbo'"
- Make sure you ran `pod install`
- Make sure you're opening the `.xcworkspace` file, not `.xcodeproj`

### "Cannot connect to localhost"
- The iOS simulator can access localhost directly
- If testing on a real device, use your computer's IP address instead

### Location permission not working
- Check that Info.plist has the `NSLocationWhenInUseUsageDescription` key
- Reset permissions: Settings → General → Transfer or Reset iPhone → Reset → Reset Location & Privacy

## Next Steps

Once the app is working:
1. Test all features thoroughly
2. Fix any bugs or issues
3. Prepare app icons and launch screen
4. Configure for TestFlight beta testing
5. Submit to App Store

## Development Workflow

1. Make changes to Swift files
2. Build and run in simulator (Cmd+R)
3. Test features
4. Make changes to Rails backend as needed
5. Iterate and refine

---

Need help? Check the main [ios_plans.md](../ios_plans.md) for the complete implementation guide.
