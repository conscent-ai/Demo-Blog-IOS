# Conscent Plugin

This is a step-by-step guide to include Conscent Plugin in your app. This plugin is developed in Swift and supports IOS 13.0 and above.

###

Open project in Xcode. Let Xcode compile it, When project is compiled, hit build. After above process, the project is ready to use.
For generating new xcframework, go to terminal and type cd "\(path to IOS plugin folder on your desktop)"
and
paste the code in terminal and hit enter

xcodebuild archive \
-scheme CCPlugin \
-configuration Release \
-destination 'generic/platform=iOS Simulator' \
-archivePath './build/CCPlugin.framework-iphonesimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

after you see archive successful
paste the code in terminal and hit enter

xcodebuild archive \
-scheme CCPlugin \
-configuration Release \
-destination 'generic/platform=iOS' \
-archivePath './build/CCPlugin.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

after you see archive successful
paste the code in terminal and hit enter

xcodebuild -create-xcframework \
-framework './build/CCPlugin.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/CCPlugin.framework' \
-framework './build/CCPlugin.framework-iphoneos.xcarchive/Products/Library/Frameworks/CCPlugin.framework' \
-output './build/CCPlugin.xcframework'

Note:- If the terminal shows an error “CCPlugin.framework” couldn’t be copied to “ios-arm64” because an item with the same name already exists." Go to build folder in IOS plugin and delete xcframework folder and run the above command again

Now go to IOS plugin folder and see the build folder, inside it you are going to see a folder named CCPlugin.xcframework that is your framework which you can drag and drop in your project.

### Files Information:

- CCPluginStatusVC.swift
  This file contains the paywall View controller and its methods

\*CCPlugin.swift
This file contains the total flow and all the functionality of the framework

\*Constants.swift
This file is storing and managing the login challenge and session in user's device

- Model.swift
  This File contains all data classes used inside app i.e. used in API calling request, response handling and internal to plug-in functionality.

- Helper.swift
  This file is contains all the Helper methods such as fixing the view controller in view , rendering the dashed line and some other functionality that helps at various places at code.

CCPluginStoryboard.storyboard
This file contains the view file for paywall

NetworkProperties.swift
This file contains all information for all APIs end-point, API method used and parameters to be passed.

NetworkClient.swift
This file manages all the networking in the framework

CommonClass.swift
This file has methods to check internet connection and some other network helper functions

## Internal functions

handleFreeConsumption
This is the function used to check if content is free or not

handleContentID
This is the funcion used to get details about the content like it's price etc.

openBrowser
This is the function used to redirect the user to browser to make the payment

handleRelaunchApp
This is the function to handle the relaunch of the app when it's redirected from the browser

handlePostLoginChallenge
This is the function for creating login challenge.

handleLoginChallenge
This is the function for checking user's login challenge.

handleSessionID
This function is used for checking user's session for a particular content.

showPayWall
This function is the second public function and starts the flow of checking the content and displaying the paywall and also stores various properties supplied by the user

Images.bundle
This file contains all the images used at various places in the framework

configure.swift
This function sets the client id and environment and is the first public function that the user will call

======================End======================
