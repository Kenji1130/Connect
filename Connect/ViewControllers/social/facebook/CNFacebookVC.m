//
//  CNFacebookVC.m
//  Connect
//
//  Created by mac on 3/27/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNFacebookVC.h"


@interface CNFacebookVC ()

@end

@implementation CNFacebookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

- (void)initView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FBSDKLoginManager *logIn = [[FBSDKLoginManager alloc] init];
    [logIn logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        //TODO: process error or result.
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            [self.delegate facebookLoginFailed:self withError:error.localizedDescription];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if (result.isCancelled) {
            NSLog(@"Login Cancelled");
            [self.delegate facebookLoginCancelled:self];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            NSLog(@"Logged in with token : @%@", result.token);
            if ([result.grantedPermissions containsObject:@"email"]) {
                NSLog(@"result is:%@",result);
                [self fetchUserInfoFromFB];
            }
        }
        
    }];

}

- (void)fetchUserInfoFromFB{
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken] tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, gender, location, friends, hometown, friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"facebook fetched info : %@", result);
                 
                 NSDictionary *userInfo = (NSDictionary *)result;
                 [self.delegate facebookLoginSuccess:self withDictionary:userInfo];
                 [self.navigationController popViewControllerAnimated:YES];


                 
             } else {
                 NSLog(@"Error %@",error);
                 [self.delegate facebookLoginFailed:self withError:error.localizedDescription];
                 [self.navigationController popViewControllerAnimated:YES];

             }
         }];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
