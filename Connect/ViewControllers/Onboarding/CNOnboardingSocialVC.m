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
#import "CNFacebookVC.h"
#import "CNTwitterVC.h"

@interface CNOnboardingSocialVC () <UIWebViewDelegate, CNFacebookDelegate, CNTwitterDelegate>
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
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Facebook Login
- (IBAction)connectWithFB:(id)sender {
    CNFacebookVC *facebookVC = (CNFacebookVC*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNFacebookVC class])];
    facebookVC.delegate = self;
    [self.navigationController pushViewController:facebookVC animated:YES];
}

#pragma mark - CNFacebookDelegate
- (void) facebookLoginSuccess:(CNFacebookVC *)facebookController withDictionary:(NSDictionary *)userInfo{
}

- (void) facebookLoginCancelled:(CNFacebookVC *)facebookController{
}

- (void) facebookLoginFailed:(CNFacebookVC *)facebookController withError:(NSString *)error{
    [[CNUtilities shared] showAlert:self withTitle:@"Facebook Login Failed" withMessage:error];
}

#pragma mark - Twitter Login
- (IBAction)connectWithTwitter:(id)sender {
    CNTwitterVC *twitterVC = (CNTwitterVC*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNTwitterVC class])];
    twitterVC.delegate = self;
    [self.navigationController pushViewController:twitterVC animated:YES];
    
}

#pragma mark - CNTwitterDelegate
- (void) twitterLoginSuccess:(CNTwitterVC *)twitterController withDictionary:(NSDictionary *)userInfoUIViewController{
    
}

- (void) twiterLoginFailed:(CNTwitterVC *)twitterController withError:(NSString *)error{
    
}



#pragma mark - Instagram Login
- (IBAction)connectWithInstagram:(id)sender {
    CNInstagramCV *instagramVC = (CNInstagramCV *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNInstagramCV class])];
    [self.navigationController pushViewController:instagramVC animated:YES];
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
