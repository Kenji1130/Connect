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
    if (self.profileType == CNProfileTypePersonal) {
        self.socialRef = [[[[[AppDelegate sharedInstance].dbRef child:@"users"] child:self.user.userID] child:@"social"] child:@"personal"];
    } else{
        self.socialRef = [[[[[AppDelegate sharedInstance].dbRef child:@"users"] child:self.user.userID] child:@"social"] child:@"business"];
    }

}

- (void)configLayout{
    if (self.profileType == CNProfileTypePersonal) {
        [self.toggleFacebook setOn:self.user.pFacebook.active];
        [self.toggleTwitter setOn:self.user.pTwitter.active];
        [self.toggleInstagram setOn:self.user.pInstagram.active];
        [self.toggleLinkedIn setOn:self.user.pLinkedIn.active];
        [self.toggleSnapchat setOn:self.user.pSnapchat.active];
        [self.toggleVine setOn:self.user.pVine.active];
        [self.togglePhone setOn:self.user.pPhone.active];
        [self.toggleSkype setOn:self.user.pSkype.active];
    } else {
        [self.toggleFacebook setOn:self.user.bFacebook.active];
        [self.toggleTwitter setOn:self.user.bTwitter.active];
        [self.toggleInstagram setOn:self.user.bInstagram.active];
        [self.toggleLinkedIn setOn:self.user.bLinkedIn.active];
        [self.toggleSnapchat setOn:self.user.bSnapchat.active];
        [self.toggleVine setOn:self.user.bVine.active];
        [self.togglePhone setOn:self.user.bPhone.active];
        [self.toggleSkype setOn:self.user.bSkype.active];
    }

    
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
    CNFacebook *facebook;
    if (self.profileType == CNProfileTypePersonal) {
        facebook = self.user.pFacebook;
    } else {
        facebook = self.user.bFacebook;
    }
    if (facebook.name != nil) {
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
    
    CNFacebook *fb;

    if (self.profileType == CNProfileTypePersonal) {
         [CNUser currentUser].pFacebook = [[CNFacebook alloc] initWithDictionary:userInfo fromSocial:YES];
        fb = self.user.pFacebook;

    } else {
        [CNUser currentUser].bFacebook = [[CNFacebook alloc] initWithDictionary:userInfo fromSocial:YES];
        fb = self.user.bFacebook;

    }
 
    NSMutableDictionary *facebook = [[NSMutableDictionary alloc] init];
    [facebook setObject:fb.name forKey:@"name"];
    [facebook setObject:[NSNumber numberWithBool:fb.hidden] forKey:@"hidden"];
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
    CNTwitter *twitter;
    if (self.profileType == CNProfileTypePersonal) {
        twitter = self.user.pTwitter;
    } else{
        twitter = self.user.bTwitter;
    }
    
    if (twitter.name != nil) {
        [[[self.socialRef child:@"twitter"] child:@"active"] setValue:[NSNumber numberWithBool:sender.on]];
    } else{
        if (sender.on) {
            [self showTwitterLogin];
        }
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

    CNTwitter *tw;

    if (self.profileType == CNProfileTypePersonal) {
        [CNUser currentUser].pTwitter = [[CNTwitter alloc] initWithDictionary:userInfo fromSocial:true];
        tw = self.user.pTwitter;
    } else {
        [CNUser currentUser].bTwitter = [[CNTwitter alloc] initWithDictionary:userInfo fromSocial:true];
        tw = self.user.bTwitter;
    }
    

    NSMutableDictionary *twitter = [[NSMutableDictionary alloc] init];
    [twitter setObject:tw.name forKey:@"name"];
    [twitter setObject:[NSNumber numberWithBool:tw.hidden] forKey:@"hidden"];
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
    CNInstagram *instagram;
    if (self.profileType == CNProfileTypePersonal) {
        instagram = self.user.pInstagram;
    } else{
        instagram = self.user.bInstagram;
    }
    
    if (instagram.name != nil) {
        [[[self.socialRef child:@"instagram"] child:@"active"] setValue:[NSNumber numberWithBool:sender.on]];
    } else{
        if (sender.on) {
            [self showInstagramLogin];
        }
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

    CNInstagram *insta;
    if (self.profileType == CNProfileTypePersonal) {
        [CNUser currentUser].pInstagram = [[CNInstagram alloc] initWithDictionary:userInfo fromSocial:YES];
        insta = self.user.pInstagram;
    } else {
        [CNUser currentUser].bInstagram = [[CNInstagram alloc] initWithDictionary:userInfo fromSocial:YES];
        insta = self.user.bInstagram;
    }

    
    NSMutableDictionary *instagram = [[NSMutableDictionary alloc] init];
    [instagram setObject:insta.name forKey:@"name"];
    [instagram setObject:[NSNumber numberWithBool:insta.hidden] forKey:@"hidden"];
    [instagram setObject:[NSNumber numberWithBool:true] forKey:@"active"];
    
    [[self.socialRef child:@"instagram"] setValue:instagram];
}

- (void)instagramLoginFailed:(UIViewController *)instagramController withError:(NSString *)error{
    [_navController dismissViewControllerAnimated:YES completion:nil];
    [[CNUtilities shared] showAlert:self withTitle:@"Instagram Login Failed" withMessage:error];
    [self.toggleInstagram setOn:false];
}

- (void)instagramLoginCancelled:(UIViewController *)instagramController{
    [_navController dismissViewControllerAnimated:YES completion:nil];
    [self.toggleInstagram setOn:false];
}

#pragma mark - LinkedIn
- (IBAction)toggleForLinkeIn:(UISwitch*)sender {
    CNLinkedIn *linkedIn;
    if (self.profileType == CNProfileTypePersonal) {
        linkedIn = self.user.pLinkedIn;
    } else {
        linkedIn = self.user.bLinkedIn;
    }
    if (linkedIn.name != nil) {
        [[[self.socialRef child:@"linkedIn"] child:@"active"] setValue:[NSNumber numberWithBool:sender.on]];
    } else{
        if (sender.on) {
            [self showLinkedInLogin];
        }
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
