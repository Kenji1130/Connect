//
//  CNLinkedInCV.m
//  Connect
//
//  Created by mac on 3/28/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNLinkedInCV.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"

@interface CNLinkedInCV ()

@end

@implementation CNLinkedInCV{
    LIALinkedInHttpClient *_client;

}

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _client = [self client];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connectWithLinkedIn{
    [self.client getAuthorizationCode:^(NSString *code) {
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            NSLog(@"Access Token: %@",accessToken);

            [self requestMeWithToken:accessToken];
        }                   failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
    }                     failure:^(NSError *error) {
        NSLog(@"Authorization failed %@", error);
    }];
}

- (void)requestMeWithToken:(NSString *)accessToken {

    [self.client GET:[[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}

- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"https://www.linkedin.com/feed/"
                                                                                    clientId:kLinkedInClientID
                                                                                clientSecret:kLinkedInClientSecret
                                                                                       state:[NSString stringWithFormat:@"linkedin%f", [NSDate date].timeIntervalSince1970]
                                                                               grantedAccess:@[@"r_basicprofile", @"r_emailaddress",@"w_share"]];
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}

@end
