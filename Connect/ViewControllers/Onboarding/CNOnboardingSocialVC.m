//
//  CNOnboardingSocialVC.m
//  Connect
//
//  Created by mac on 3/16/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingSocialVC.h"
#import "CNOnboardingPhoneInputVC.h"
#import "CNInstagramCV.h"

@interface CNOnboardingSocialVC () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnFB;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnInstagram;
@property (weak, nonatomic) IBOutlet UIButton *btnSnapchat;
    
@end

@implementation CNOnboardingSocialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configLayout{
    [[_btnFB layer] setBorderColor:kAppTintColor.CGColor];
    [[_btnTwitter layer] setBorderColor:kAppTintColor.CGColor];
    [[_btnInstagram layer] setBorderColor:kAppTintColor.CGColor];
    [[_btnSnapchat layer] setBorderColor:kAppTintColor.CGColor];
}
    

#pragma mark - IBActions
    
- (IBAction)onBackBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSkipeClicked:(id)sender {
      CNOnboardingPhoneInputVC *vc = (CNOnboardingPhoneInputVC *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingPhoneInputVC class])];
    vc.profileImage = _profileImage;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Facebook Login
- (IBAction)connectWithFB:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FBSDKLoginManager *logIn = [[FBSDKLoginManager alloc] init];
    [logIn logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        //TODO: process error or result.
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (error) {
            NSLog(@"%@", (NSString *)error);
            [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:@"Facebook  Connection Failed."];
            
        }else if (result.isCancelled) {
            NSLog(@"Login Cancelled");
            
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
                 
//                 NSDictionary *temp = (NSDictionary *)result;
//                 NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
//                 [userInfo setObject:[temp objectForKey:@"id"] forKey:@"user_facebook_id"];
                 
             } else {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }
    
}
    
#pragma mark - Twitter Login
- (IBAction)connectWithTwitter:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        if (session) {
            NSLog(@"Twitter Login Successed!");
            [self getTwitterAuth];
        }
        else{
            NSLog(@"Twitter Login Failed! %@", [error localizedDescription]);
            [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:@"Twitter Connection Failed."];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}
    
- (void)getTwitterAuth{
    TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
    NSURLRequest *request = [client URLRequestWithMethod:@"GET"
                                                     URL:@"https://api.twitter.com/1.1/account/verify_credentials.json"
                                              parameters:@{@"include_email": @"true", @"skip_status": @"true"}
                                                   error:nil];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if(request){
        
        [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (data) {
                NSError *jsonError;
                NSDictionary *jsonAuth = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                NSLog(@"jsonAuth : %@", jsonAuth);
                
                NSString *user_id = [jsonAuth objectForKey:@"id_str"];
                [params setValue:user_id forKey:@"user_id"];
                
                NSString *screen_name = [jsonAuth objectForKey:@"screen_name"];
                [params setObject:screen_name forKey:@"screen_name"];
                
                [self fetchUserInfoFromTwitter:params];
                
            }
            else{
                NSLog(@"Error : %@", connectionError);
            }
        }];
    }
}
    
- (void)fetchUserInfoFromTwitter : (NSMutableDictionary*)param{
    
    TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
    NSURLRequest *request = [client URLRequestWithMethod:@"GET"
                                                     URL:@"https://api.twitter.com/1.1/users/show.json"
                                              parameters:param
                                                   error:nil];
    
    if (request) {
        [client sendTwitterRequest:request completion:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (data) {
                NSDictionary *jsonUser = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"jsonUser : %@", jsonUser);
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            else{
                NSLog(@"Error : %@", connectionError);
            }
        }];
    }
    
}

#pragma mark - Instagram Login
- (IBAction)connectWithInstagram:(id)sender {
    CNInstagramCV *vc = (CNInstagramCV *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNInstagramCV class])];
    [self presentViewController:vc animated:YES completion:nil];
}
    
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
