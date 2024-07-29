
Conscent Plugin for developers
======================

This is a step by step guide to include Conscent Plugin in your app. This plugin is developed in Swift and supports IOS 13.0 and above.

## Step-1  Setup-1
1.Drag the xcframework folder in the your projects under framework and add it to your project.(Please look at the readme section to see how to create a xcframework folder)
2.Select your target and go into Frameworks,Libraries and Embedded Content section ,and in CCPlugin.xcframework change embed mode to embed and sign
3.First Clean and then Build your project.

## Step-2 Setup-2
1. First Import the Framework CCPlugin
2. In your View Controller class, pass client_id and Environment Mode to be used in your app as below sample:
CCplugin.shared.configure(mode: .stage, clientID: clientID)
3. Mode can be set as 
CCplugin.shared.mode.stage
CCplugin.shared.mode.sandbox
CCplugin.shared.mode.production
by Default the Mode is stage
4. You can pass the accent color by using CCplugin.shared.accent color and modify the accent color in the paywall
5. There is a also a property named debug mode CCplugin.shared.debugMode which can be set true or false to show toasts if the contentID or clientID entered is wrong it is only for development purposes


## Step-3 Functions

To check if an article/content is free/paid or a payment needs to be done, in your class, use as below sample:
Parameters detail can be checked below for more information.

3.1 This step is for PayWall Screen
CCplugin.shared.showPayWall(contentID: contentID, viewLayout: ViewLayoutInfo(vc: self, view: webView), delegate: self,,subscriberDelegate:CCPluginSubscribeBtnTapDelegate? = nil,signInDelegate:CCPluginSignBtnTapDelegate? = nil)

3.2 This step is for Subscription Screen
CCplugin.shared.initSubscriptions(contentID: contentID, viewLayout: ViewLayoutInfo(vc: self, view: paywall), completiondelegate: self)

Parameters detail:-
*contentID: This will be your article or content id for which detail needs to be checked.
* ViewLayoutInfo : This is a struct which has 2 values VC and view , pass the view on which you are going to show your content and VC(View controller) in which the view is present
*delegate: This will be used handle the success and failure cases , pass the class as the delegate where you want to handle success or Failure ,this delegate is of the protocol CCPluginCompletionHandlerDelegate which has 2 methods success and failure which will be triggered in case of success and failure of the process
* success: This is the success callback which will get called for every successful processing.The method success will be triggered in this case in your delegate class
* failure: This is the failure callback which will get called for every failed processing. The method failure will be triggered in this case in the your delegate class
*subscriberDelegate This is a optional callback which will be called if you pass your class as its delegate ,It will be triggred When the subscription button is taped but if you don't pass in your delegate it will not show the subscription view
*signInDelegate This is a optional callback which will be called if you pass your class as its delegate ,It will be triggered When the sign in button is taped , but if you don't pass in your delegate it will not show the Sign-in view


## Step-4 Final Touches
In your Project go to your target and in the URL types add a new one 
with URL schemes "conscent"
This is important to handle redirection or app launches from the browser
Then in the Scene delegate add the function
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) 
add call this function CCplugin.shared.handleRelaunchApp(url: url)


## Step-5 Important Points

1. Keep in mind there is only instance of the CCPlugin so a new function call will override the last function call 
2. Please show or load your content only after the success callback to avoid showing paid content for free in case of server or internet issue
3. Don't forget step 4 otherwise you will have to refresh the content screen everytime you make a payment for a paid content
4. The blocker View supports both portrait and landscape orientation
5. Make sure the height of the paywall view is more than 600 in portrait and 336 in landscape to avoid any view obstruction , alternatively if you're not passing the subscriber view you can have the paywall height of 313 in portrait , 336 in landscape
6. If you don't have a valid session ID the logIn with Conscent button will not show
7. if you have valid session you will se the user's account balance in the paywall
8. The view automatically centers all of its content so it's fine if you don't want the subscription view


Please look at the Sample Project for more Details

======================End======================
