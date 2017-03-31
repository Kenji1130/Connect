//
//  CNTwitterVC.m
//  Connect
//
//  Created by mac on 3/27/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNTwitterVC.h"

@interface CNTwitterVC ()

@end

@implementation CNTwitterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

- (void) initView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (session) {
            NSLog(@"Twitter Login Successed!");
            [self getTwitterAuth];
        }
        else{
            NSLog(@"Twitter Login Failed! %@", [error localizedDescription]);
            [self.delegate twitterLoginFailed:self withError:error.localizedDescription];
            [self.navigationController popViewControllerAnimated:YES];

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
                [self.delegate twitterLoginFailed:self withError:connectionError.localizedDescription];
                
                [self.navigationController popViewControllerAnimated:YES];

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
                NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"jsonUser : %@", userInfo);
                [self.delegate twitterLoginSuccess:self withDictionary:userInfo];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else{
                NSLog(@"Error : %@", connectionError);
                [self.delegate twitterLoginFailed:self withError:connectionError.localizedDescription];
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
