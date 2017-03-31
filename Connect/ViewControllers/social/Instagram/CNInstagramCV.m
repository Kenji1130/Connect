//
//  CNInstagramCV.m
//  Connect
//
//  Created by mac on 3/17/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNInstagramCV.h"

@interface CNInstagramCV () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, weak)     InstagramEngine *instagramEngine;
@property (strong, nonatomic) NSURL *authURL;
@end

@implementation CNInstagramCV

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.scrollView.bounces = NO;
    self.instagramEngine = [InstagramEngine sharedEngine];

    _authURL = [self.instagramEngine authorizationURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:_authURL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.instagramEngine isSessionValid]) {
        [self.instagramEngine logout];
    }
    [self.delegate instagramLoginCancelled:self];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
    
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
        NSError *error;
        if ([self.instagramEngine receivedValidAccessTokenFromURL:request.URL error:&error])
        {
            [self getUserInfo];
            
        }
        return YES;
}

- (void)getUserInfo{
    [self.instagramEngine getSelfUserDetailsWithSuccess:^(InstagramUser * _Nonnull user) {
        NSLog(@"User Name: %@", user.username);
        NSDictionary *dict = @{@"name":user.username,
                              @"hidden": @false,
                              @"active": @true};
        [self.delegate instagramLoginSuccess:self withDictionary:dict];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        NSLog(@"Instagram : %@", error.localizedDescription);
        [self.delegate instagramLoginFailed:self withError:error.localizedDescription];
    }];
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:[NSURLRequest requestWithURL:_authURL]];
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
//        
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//    }
//    
//    [super viewWillDisappear:animated];
//
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
