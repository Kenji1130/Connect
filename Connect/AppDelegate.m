//
//  AppDelegate.m
//  Connect
//
//  Created by Daniel on 10/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "AppDelegate.h"
#import "CNProfileViewController.h"
@import Batch;

NSString *const kPinterestAppID = @"4886880364739441997";

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (instancetype)sharedInstance {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Configure Firebase
    [FIRApp configure];
    
    // Set Firebase database reference
    self.dbRef = [[FIRDatabase database] reference];
    self.storage = [FIRStorage storage];
    self.storageRef = [self.storage reference];
    
    // Initialize Fabric
    [[Twitter sharedInstance] startWithConsumerKey:kTwitterCustomerKey consumerSecret:kTwitterSecretKey];
    [Fabric with:@[ [Twitter class], [Digits class]]];
    
    // Pinterest
    [PDKClient configureSharedInstanceWithAppId:kPinterestAppID];
    
    // Facebook SDK
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    // Start Batch SDK.
    [Batch startWithAPIKey:kBatchDevAPIKey];
    // Register for push notifications
    [BatchPush registerForRemoteNotifications];
    
    [self setupAppearance];
    
    // Check if user has already logged in
    NSString *loggedUserID = [[NSUserDefaults standardUserDefaults] objectForKey:kLoggedUserID];
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

- (void)saveUserIDForBatch: (NSString*) userID{
    BatchUserDataEditor *editor = [BatchUser editor];
    [editor setIdentifier:userID];
    [editor save]; // Do not forget to save the changes!
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
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSString *deeplink = [BatchPush deeplinkFromUserInfo:userInfo];
    NSLog(@"Deep Link: %@", deeplink);
}

@end
