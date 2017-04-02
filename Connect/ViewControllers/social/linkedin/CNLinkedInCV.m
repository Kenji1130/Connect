//
//  CNLinkedInCV.m
//  Connect
//
//  Created by mac on 3/28/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNLinkedInCV.h"
#import "LinkedInHelper.h"


@interface CNLinkedInCV ()

@property (strong, nonatomic) LinkedInHelper *linkedIn;

@end

@implementation CNLinkedInCV{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self login];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    [linkedIn logout];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)login{
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    
    // If user has already connected via linkedin in and access token is still valid then
    // No need to fetch authorizationCode and then accessToken again!
    
    if (linkedIn.isValidToken) {
        
        linkedIn.customSubPermissions = [NSString stringWithFormat:@"%@,%@", first_name, last_name];
        
        // So Fetch member info by elderyly access token
        [linkedIn autoFetchUserInfoWithSuccess:^(NSDictionary *userInfo) {
            // Whole User Info
            
            NSString * desc = [NSString stringWithFormat:@"first name : %@\n last name : %@", userInfo[@"firstName"], userInfo[@"lastName"] ];
            [self showAlert:desc];
            
            NSLog(@"user Info : %@", userInfo);
        } failUserInfo:^(NSError *error) {
            NSLog(@"error : %@", error.userInfo.description);
        }];
    } else {
        
        linkedIn.cancelButtonText = @"Close"; // Or any other language But Default is Close
        
        NSArray *permissions = @[@(BasicProfile),
                                 @(EmailAddress),
                                 @(Share),
                                 @(CompanyAdmin)];
        
        linkedIn.showActivityIndicator = YES;
        
//warning - Your LinkedIn App ClientId - ClientSecret - RedirectUrl - And state
        
        [linkedIn requestMeWithSenderViewController:self
                                           clientId:kLinkedInClientID
                                       clientSecret:kLinkedInClientSecret
                                        redirectUrl:kLinkedInRedirectURL
                                        permissions:permissions
                                              state:@"adsfregasagagerrqer32"
                                    successUserInfo:^(NSDictionary *userInfo) {
                                        
                                        
                                        NSString * desc = [NSString stringWithFormat:@"first name : %@\n last name : %@",
                                                           userInfo[@"firstName"], userInfo[@"lastName"] ];
                                        [self showAlert:desc];
                                        
                                        // Whole User Info
                                        NSLog(@"user Info : %@", userInfo);
                                        // You can also fetch user's those informations like below
                                        NSLog(@"job title : %@",     [LinkedInHelper sharedInstance].title);
                                        NSLog(@"company Name : %@",  [LinkedInHelper sharedInstance].companyName);
                                        NSLog(@"email address : %@", [LinkedInHelper sharedInstance].emailAddress);
                                        NSLog(@"Photo Url : %@",     [LinkedInHelper sharedInstance].photo);
                                        NSLog(@"Industry : %@",      [LinkedInHelper sharedInstance].industry);
                                    }
                                  failUserInfoBlock:^(NSError *error) {
                                      NSLog(@"error : %@", error.userInfo.description);
                                  }
         ];
    }

}


- (void)showAlert:(NSString *)desc {
    
    [[[UIAlertView alloc] initWithTitle:@"Simple User info" message:desc delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

@end
