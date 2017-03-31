//
//  CNSocialMediaAddVC.m
//  Connect
//
//  Created by mac on 3/30/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNSocialMediaAddVC.h"
#import "CNFacebookVC.h"
#import "CNTwitterVC.h"
#import "CNInstagramCV.h"
#import "CNSaveSuccessView.h"
@import PopupKit;

@interface CNSocialMediaAddVC () <CNFacebookDelegate, CNTwitterDelegate,CNInstagramDelegate,CNSaveSuccessViewDelegate>

@property (strong, nonatomic) UINavigationController *navController;

@property (weak, nonatomic) IBOutlet UISwitch *toggleFacebook;
@property (weak, nonatomic) IBOutlet UISwitch *toggleTwitter;
@property (weak, nonatomic) IBOutlet UISwitch *toggleInstagram;
@property (weak, nonatomic) IBOutlet UISwitch *toggleLinkedIn;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSnapchat;
@property (weak, nonatomic) IBOutlet UISwitch *toggleVine;
@property (weak, nonatomic) IBOutlet UISwitch *togglePhone;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSkype;

@property (strong, nonatomic) FIRDatabaseReference *socialRef;
@property (strong, nonatomic) FIRDatabaseReference *userRef;

@property (strong, nonatomic) CNSaveSuccessView *saveSuccessView;

@end

@implementation CNSocialMediaAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self configLayout];
}

- (void)initData{
    self.user = [CNUser currentUser];
    self.socialRef = [[[[AppDelegate sharedInstance].dbRef child:@"users"] child:self.user.userID] child:@"social"];
}

- (void)configLayout{
    [self.toggleFacebook setOn:self.user.facebook.active];
    [self.toggleTwitter setOn:self.user.twitter.active];
    [self.toggleInstagram setOn:self.user.instagram.active];
    [self.toggleLinkedIn setOn:self.user.linkedIn.active];
    [self.toggleSnapchat setOn:self.user.snapchat.active];
    [self.toggleVine setOn:self.user.vine.active];
    [self.togglePhone setOn:self.user.phone.active];
    [self.toggleSkype setOn:self.user.skype.active];
    
    self.saveSuccessView = (CNSaveSuccessView *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CNSaveSuccessView class]) owner:nil options:nil] firstObject];
    self.saveSuccessView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPopUp: (UIView *) view{
    // Show in popup
    PopupViewLayout layout = PopupViewLayoutMake(PopupViewHorizontalLayoutCenter,
                                                 PopupViewVerticalLayoutCenter);
    
    PopupView* popup = [PopupView popupViewWithContentView:view
                                                  showType:PopupViewShowTypeSlideInFromBottom
                                               dismissType:PopupViewDismissTypeSlideOutToBottom
                                                  maskType:PopupViewMaskTypeDarkBlur
                            shouldDismissOnBackgroundTouch:NO shouldDismissOnContentTouch:NO];
    
    [popup showWithLayout:layout];
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Facebook
- (IBAction)toggleForFacebook:(UISwitch*)sender {
    if (self.user.facebook.name != nil) {
        [[[self.socialRef child:@"facebook"] child:@"active"] setValue:[NSNumber numberWithBool:sender.on]];
    } else{
        if (sender.isOn) {
            [self showFacebookLogin];
        }
    }
}

- (void)showFacebookLogin{
    CNFacebookVC *vc = (CNFacebookVC*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNFacebookVC class])];
    vc.delegate = self;
    _navController = [[UINavigationController alloc] initWithRootViewController:vc];
    _navController.navigationBar.hidden = true;
    [self presentViewController:_navController animated:YES completion:nil];
}

#pragma mark - CNFacebookDelegate
- (void)facebookLoginSuccess:(UIViewController *)facebookController withDictionary:(NSDictionary *)userInfo{
    [_navController dismissViewControllerAnimated:YES completion:nil];
    [CNUser currentUser].facebook = [[CNFacebook sharedInstance] initWithDictionary:userInfo];
    
    CNUser *user = [CNUser currentUser];
    NSMutableDictionary *facebook = [[NSMutableDictionary alloc] init];
    [facebook setObject:user.facebook.name forKey:@"name"];
    [facebook setObject:[NSNumber numberWithBool:user.facebook.hidden] forKey:@"hidden"];
    [facebook setObject:[NSNumber numberWithBool:true] forKey:@"active"];
    
    [[self.socialRef child:@"facebook"]setValue:facebook];
    
}

- (void)facebookLoginFailed:(UIViewController *)facebookController withError:(NSString *)error{
    [_navController dismissViewControllerAnimated:YES completion:nil];
    [[CNUtilities shared] showAlert:self withTitle:@"Facebook Login Failed" withMessage:error];
    [self.toggleFacebook setOn:false];

}

- (void)facebookLoginCancelled:(UIViewController *)facebookController{
    [_navController dismissViewControllerAnimated:YES completion:nil];
    [self.toggleFacebook setOn:false];

}

#pragma mark - Twitter
- (IBAction)toggleForTwitter:(UISwitch*)sender {
    if (self.user.twitter.name != nil) {
        [[[self.socialRef child:@"twitter"] child:@"active"] setValue:[NSNumber numberWithBool:sender.on]];
    } else{
        [self showTwitterLogin];
    }
}

- (void)showTwitterLogin{
    CNTwitterVC *twitterVC = (CNTwitterVC*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNTwitterVC class])];
    twitterVC.delegate = self;
    _navController = [[UINavigationController alloc] initWithRootViewController:twitterVC];
    _navController.navigationBar.hidden = true;
    [self presentViewController:_navController animated:YES completion:nil];
}

#pragma mark - CNTwitterDelegate

- (void)twitterLoginSuccess:(UIViewController *)twitterController withDictionary:(NSDictionary *)userInfo{
    [_navController dismissViewControllerAnimated:YES completion:nil];

    [CNUser currentUser].twitter = [[CNTwitter sharedInstance] initWithDictionary:userInfo fromTwitter:true];
    
    CNUser *user = [CNUser currentUser];
    NSMutableDictionary *twitter = [[NSMutableDictionary alloc] init];
    [twitter setObject:user.twitter.name forKey:@"name"];
    [twitter setObject:[NSNumber numberWithBool:user.twitter.hidden] forKey:@"hidden"];
    [twitter setObject:[NSNumber numberWithBool:true] forKey:@"active"];
    
    [[self.socialRef child:@"twitter"] setValue:twitter];
}

- (void)twitterLoginCancelled:(UIViewController *)twitterController{
    [_navController dismissViewControllerAnimated:YES completion:nil];
    [self.toggleTwitter setOn:false];

}

- (void)twitterLoginFailed:(UIViewController *)twitterController withError:(NSString *)error{
    [_navController dismissViewControllerAnimated:YES completion:nil];
    [[CNUtilities shared] showAlert:self withTitle:@"Twitter Login Failed" withMessage:error];
    [self.toggleTwitter setOn:false];
}

#pragma mark - Instagram
- (IBAction)toggleForInstagram:(UISwitch*)sender {
    if (self.user.instagram.name != nil) {
        [[[self.socialRef child:@"instagram"] child:@"active"] setValue:[NSNumber numberWithBool:sender.on]];
    } else{
        [self showInstagramLogin];
    }
}

- (void)showInstagramLogin{
    CNInstagramCV *instagramVC = (CNInstagramCV*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNInstagramCV class])];
    instagramVC.delegate = self;
    _navController = [[UINavigationController alloc] initWithRootViewController:instagramVC];
    _navController.navigationBar.hidden = true;
    [self presentViewController:_navController animated:YES completion:nil];
}

#pragma mark: - CNInstagramDelegate
- (void)instagramLoginSuccess:(UIViewController *)instagramController withDictionary:(NSDictionary *)userInfo{
    [_navController dismissViewControllerAnimated:YES completion:nil];

    [CNUser currentUser].instagram = [[CNInstagram sharedInstance] initWithDictionary:userInfo];
    
    CNUser *user = [CNUser currentUser];
    NSMutableDictionary *instagram = [[NSMutableDictionary alloc] init];
    [instagram setObject:user.instagram.name forKey:@"name"];
    [instagram setObject:[NSNumber numberWithBool:user.instagram.hidden] forKey:@"hidden"];
    [instagram setObject:[NSNumber numberWithBool:true] forKey:@"active"];
    
    [[self.socialRef child:@"instagram"] setValue:instagram];
}

- (void)instagramLoginFailed:(UIViewController *)instagramController withError:(NSString *)error{
    [_navController dismissViewControllerAnimated:YES completion:nil];
    [[CNUtilities shared] showAlert:self withTitle:@"Instagram Login Failed" withMessage:error];
    [self.toggleInstagram setOn:false];
}

- (void)instagramLoginCancelled:(UIViewController *)instagramController{
    [self.toggleInstagram setOn:false];
}

#pragma mark - LinkedIn
- (IBAction)toggleForLinkeIn:(UISwitch*)sender {
    if (self.user.linkedIn.name != nil) {
        [[[self.socialRef child:@"linkedIn"] child:@"active"] setValue:[NSNumber numberWithBool:sender.on]];
    } else{
        [self showLinkedInLogin];
    }
}

- (void)showLinkedInLogin{
    
}

- (IBAction)onSave:(id)sender {
    [self showPopUp:self.saveSuccessView];
}

#pragma mark - CNSaveSuccessViewDelegate
- (void)save{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
