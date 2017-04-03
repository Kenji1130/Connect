//
//  CNOnboardingPersonalSocialVC.m
//  Connect
//
//  Created by mac on 4/2/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingPersonalSocialVC.h"
#import "CNInstagramCV.h"
#import "CNFacebookVC.h"
#import "CNTwitterVC.h"
#import "CNLinkedInCV.h"
#import "CNOnboardingBusinessSocialVC.h"


@interface CNOnboardingPersonalSocialVC () <UIWebViewDelegate, CNFacebookDelegate, CNTwitterDelegate, CNInstagramDelegate, CNLinkedInDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnFB;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnInstagram;
@property (weak, nonatomic) IBOutlet UIButton *btnLinkedIn;
@property (weak, nonatomic) IBOutlet UIButton *btnSkip;

@property (nonatomic, assign) BOOL isConnectedSoial;
@property (nonatomic, strong) FIRDatabaseReference *userRef;

@end

@implementation CNOnboardingPersonalSocialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isConnectedSoial = false;
    [self configLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // anpose of any resources that can be recreated.
}

- (void) configLayout{
    [[_btnFB layer] setBorderColor:kAppTintColor.CGColor];
    [[_btnTwitter layer] setBorderColor:kAppTintColor.CGColor];
    [[_btnInstagram layer] setBorderColor:kAppTintColor.CGColor];
    [[_btnLinkedIn layer] setBorderColor:kAppTintColor.CGColor];
}

- (IBAction)onSkipeClicked:(id)sender {
    if (_isConnectedSoial) {
        [self saveSocialInfo];
    } else {
        [[AppDelegate sharedInstance] showMain];
    }
    
    //    [self saveSocialInfo];
}

#pragma mark - Facebook Login
- (IBAction)connectWithFB:(id)sender {
    CNFacebookVC *facebookVC = (CNFacebookVC*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNFacebookVC class])];
    facebookVC.delegate = self;
    [self.navigationController pushViewController:facebookVC animated:YES];
}

#pragma mark - CNFacebookDelegate
- (void) facebookLoginSuccess:(CNFacebookVC *)facebookController withDictionary:(NSDictionary *)userInfo{
    
    [CNUser currentUser].pFacebook = [[CNFacebook alloc] initWithDictionary:userInfo fromSocial:YES];
    [self setConnected:self.btnFB];
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
- (void) twitterLoginSuccess:(CNTwitterVC *)twitterController withDictionary:(NSDictionary *)userInfo{
    [CNUser currentUser].pTwitter = [[CNTwitter alloc] initWithDictionary:userInfo fromSocial:true];
    [self setConnected:self.btnTwitter];
    
}

- (void) twitterLoginFailed:(CNTwitterVC *)twitterController withError:(NSString *)error{
    [[CNUtilities shared] showAlert:self withTitle:@"Twitter Login Failed" withMessage:error];
}


#pragma mark - Instagram Login
- (IBAction)connectWithInstagram:(id)sender {
    CNInstagramCV *instagramVC = (CNInstagramCV *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNInstagramCV class])];
    instagramVC.delegate = self;
    [self.navigationController pushViewController:instagramVC animated:YES];
}

#pragma mark - CNInstagramDelegate
- (void)instagramLoginSuccess:(UIViewController *)instagramController withDictionary:(NSDictionary *)userInfo{
    [CNUser currentUser].pInstagram = [[CNInstagram alloc] initWithDictionary:userInfo fromSocial:YES];
    [self setConnected:self.btnInstagram];
}

- (void)instagramLoginFailed:(UIViewController *)instagramController withError:(NSString *)error{
    [[CNUtilities shared] showAlert:self withTitle:@"Instagram Login Failed" withMessage:error];
    
}

#pragma mark - LinkedIn Login
- (IBAction)connectWithLinkedIn:(id)sender {
    CNLinkedInCV *linkedInVC = (CNLinkedInCV*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNLinkedInCV class])];
    linkedInVC.delegate = self;
    [self.navigationController pushViewController:linkedInVC animated:YES];
}

#pragma mark - CNLinkedInDelegate
- (void)linkedInLoginSuccess:(UIViewController *)linkedInController withDictionary:(NSDictionary *)userInfo{
    
}

- (void)linkedInLoginFailed:(UIViewController *)linkedInController withError:(NSString *)error{
    [[CNUtilities shared] showAlert:self withTitle:@"LinkedIn Login Failed" withMessage:error];
}


#pragma mark - Change Button Style after connect social account
- (void)setConnected:(UIButton*)button{
    [[button layer] setBorderColor:kAppTextColor.CGColor];
    [button setTitle:@"CONNECTED" forState:UIControlStateNormal];
    [button setEnabled:false];
    [self.btnSkip setTitle:@"SAVE" forState:UIControlStateNormal];
    
    _isConnectedSoial = true;
}


- (void)saveSocialInfo{
    self.userRef = [[[[[AppDelegate sharedInstance].dbRef child:@"users"] child:[CNUser currentUser].userID] child:@"social"] child:@"personal"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    CNUser *user = [CNUser currentUser];
    if (user.pFacebook != nil) {
        NSMutableDictionary *facebook = [[NSMutableDictionary alloc] init];
        [facebook setObject:user.pFacebook.name forKey:@"name"];
        [facebook setObject:[NSNumber numberWithBool:user.pFacebook.hidden] forKey:@"hidden"];
        [facebook setObject:[NSNumber numberWithBool:true] forKey:@"active"];
        [dict setObject:facebook forKey:@"facebook"];
    }
    if (user.pTwitter != nil) {
        NSMutableDictionary *twitter = [[NSMutableDictionary alloc] init];
        [twitter setObject:user.pTwitter.name forKey:@"name"];
        [twitter setObject:[NSNumber numberWithBool:user.pTwitter.hidden] forKey:@"hidden"];
        [twitter setObject:[NSNumber numberWithBool:true] forKey:@"active"];
        
        [dict setObject:twitter forKey:@"twitter"];
    }
    if (user.pInstagram != nil) {
        NSMutableDictionary *instagram = [[NSMutableDictionary alloc] init];
        [instagram setObject:user.pInstagram.name forKey:@"name"];
        [instagram setObject:[NSNumber numberWithBool:user.pInstagram.hidden] forKey:@"hidden"];
        [instagram setObject:[NSNumber numberWithBool:true] forKey:@"active"];
        
        [dict setObject:instagram forKey:@"instagram"];
    }
    if (user.pLinkedIn != nil) {
        NSMutableDictionary *linkedIn = [[NSMutableDictionary alloc] init];
        [linkedIn setObject:user.pLinkedIn.name forKey:@"name"];
        [linkedIn setObject:[NSNumber numberWithBool:user.pLinkedIn.hidden] forKey:@"hidden"];
        [linkedIn setObject:[NSNumber numberWithBool:true] forKey:@"active"];
        
        [dict setObject:linkedIn forKey:@"linkedIn"];
    }
    
    __weak typeof(self) weakSelf = self;

    [self.userRef setValue:dict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {

        if ([CNUser currentUser].profileType == CNProfileTypePersonal) {
            [[AppDelegate sharedInstance] showMain];

        } else {
            [weakSelf goBusinessSocial];
        }
    }];
}

- (void)goBusinessSocial{
    CNOnboardingBusinessSocialVC *vc = (CNOnboardingBusinessSocialVC*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingBusinessSocialVC class])];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
