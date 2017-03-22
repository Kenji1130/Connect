//
//  AppDelegate.m
//  Connect
//
//  Created by Daniel on 10/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

#import "AppDelegate.h"
#import "CNProfileViewController.h"

NSString *const kPinterestAppID = @"4886880364739441997";
NSString *const kGCMMessageIDKey = @"gcm.message_id";

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above. Implement FIRMessagingDelegate to receive data message via FCM for
// devices running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@implementation AppDelegate

+ (instancetype)sharedInstance {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    // Initialize Fabric
    [[Twitter sharedInstance] startWithConsumerKey:kTwitterCustomerKey consumerSecret:kTwitterSecretKey];
    [Fabric with:@[ [Twitter class], [Digits class]]];
    
    // Pinterest
    [PDKClient configureSharedInstanceWithAppId:kPinterestAppID];
    
    // Facebook SDK
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    // Configure Firebase
    [FIRApp configure];
    
    // Set Firebase database reference
    self.dbRef = [[FIRDatabase database] reference];
    self.storage = [FIRStorage storage];
    self.storageRef = [self.storage reference];
    
    // iOS 8 or later
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
        
        // For iOS 10 data message (sent via FCM)
        [FIRMessaging messaging].remoteMessageDelegate = self;
#endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    // [START add_token_refresh_observer]
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];

    [self setupAppearance];
    
    // Check if user has already logged in
    NSString *loggedUserID = [[CNUtilities shared] getLoggedUserID];
    if (loggedUserID != nil && ![loggedUserID isEqualToString:@""]) {
        // Get current user information
        [[[_dbRef child:@"users"] child:loggedUserID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            // Get user value
            if (![snapshot.value isEqual:[NSNull null]]) {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:snapshot.value];
                
                [[CNUser currentUser] configureUserWithDictionary:userInfo];
                [self showMain];
            }
        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    } else {
        [self showLogin];
    }
    
    return YES;
}

#pragma mark - Helpers

- (void)showLogin {
    // Shows splash screen
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"loginNavController"];
    self.window.rootViewController = navController;
}

- (void)showMain {
    // Shows main screen
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBarController = (UITabBarController *)[storyboard instantiateViewControllerWithIdentifier:@"mainTabController"];
    
    for (UITabBarItem *item in tabBarController.tabBar.items) {
        // Use the original UIImage
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
//    CNProfileViewController *profileVC = [(UINavigationController *)tabBarController.viewControllers[3] viewControllers].firstObject;
//    profileVC.isCurrentUser = YES;
    
    self.window.rootViewController = tabBarController;
}

- (void)setupAppearance {
    // Change tint, text, background colors on UI controls.
    
    UITabBar *tabBarAppearance = [UITabBar appearance];
    tabBarAppearance.barTintColor = [UIColor whiteColor];
    tabBarAppearance.tintColor = kAppTintColor;
    [tabBarAppearance setSelectionIndicatorImage:[[UIImage alloc] init]];
    
    // if ([UIBarButtonItem instancesRespondToSelector:@selector(appearanceWhenContainedInInstancesOfClasses:)]) {
        // [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTintColor:[UIColor blackColor]];
    // }
    
    // Remove the icon, which is located in the left view
    //    [[UISearchBar appearance] setImage:[UIImage new] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    // Give some left padding between the edge of the search bar and the text the user enters
    //    [UISearchBar appearance].searchTextPositionAdjustment = UIOffsetMake(-22, 0);
    
}

#pragma mark -

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([[Twitter sharedInstance] application:application openURL:url options:options]) {
        return YES;
    }
        
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}

    
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[FIRMessaging messaging] disconnect];
    NSLog(@"Disconnected from FCM");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    [self connectToFcm];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}
// [END receive_message]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionNone);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler();
}
#endif
// [END ios_10_message_handling]

// [START ios_10_data_message_handling]
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Receive data message on iOS 10 devices while app is in the foreground.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"%@", remoteMessage.appData);
}
#endif
// [END ios_10_data_message_handling]

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    [[CNUtilities shared] saveToken:refreshedToken];
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
    [self updateToken];
    
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    
    // Disconnect previous FCM connection if it exists.
    [[FIRMessaging messaging] disconnect];
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}
// [END connect_to_fcm]

- (void)updateToken{
    NSString *loggedUserID = [[CNUtilities shared] getLoggedUserID];
    NSString *token = [[CNUtilities shared] getToken];
    if (loggedUserID != nil && ![loggedUserID isEqualToString:@""] && token != nil && ![token isEqualToString:@""]) {
        [[[[self.dbRef child:@"users"] child:loggedUserID] child:@"token"] setValue:token];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to register for remote notifications: %@", error);
}

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
// the InstanceID token.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"APNs token retrieved: %@", deviceToken);
    
    // With swizzling disabled you must set the APNs token here.
    // [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
}

@end
