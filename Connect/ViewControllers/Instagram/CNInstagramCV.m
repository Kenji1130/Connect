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

@end

@implementation CNInstagramCV

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.scrollView.bounces = NO;
    
    NSURL *authURL = [[InstagramEngine sharedEngine] authorizationURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
        NSError *error;
        if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:request.URL error:&error])
        {
            [self authenticationSuccess];
        }
        return YES;
}
    
- (void)authenticationSuccess{
    [self dismissViewControllerAnimated:YES completion:nil];
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
