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
#import "CNLinkedInCV.h"
#import "CNSaveSuccessView.h"
#import "CNSocialMediaAddView.h"

@import PopupKit;

@interface CNSocialMediaAddVC () <CNFacebookDelegate, CNTwitterDelegate,CNInstagramDelegate, CNLinkedInDelegate, CNSaveSuccessViewDelegate, CNSocialMediaAddViewDelegate>

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
@property (strong, nonatomic) CNSocialMediaAddView *mediaView;

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
    
    self.mediaView = (CNSocialMediaAddView*)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CNSocialMediaAddView class]) owner:nil options:nil] firstObject];
    self.mediaView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)showPopUp: (UIView *) view{
//    // Show in popup
//    PopupViewLayout layout = PopupViewLayoutMake(PopupViewHorizontalLayoutCenter,
//                                                 PopupViewVerticalLayoutCenter);
//    
//    PopupView* popup = [PopupView popupViewWithContentView:view
//                                                  showType:PopupViewShowTypeSlideInFromBottom
//                                               dismissType:PopupViewDismissTypeSlideOutToBottom
//                                                  maskType:PopupViewMaskTypeDarkBlur
//                            shouldDismissOnBackgroundTouch:NO shouldDismissOnContentTouch:NO];
//    
//    [popup showWithLayout:layout];
//}

- (void)showPopUp:(UIView*)view withVerticalLayout:(PopupViewVerticalLayout)verticalLayout{
    // Show in popup
    PopupViewLayout layout = PopupViewLayoutMake(PopupViewHorizontalLayoutCenter,
                                                 verticalLayout);
    
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
//            [self showLinkedInLogin];
        }
    }
}

- (void)showLinkedInLogin{
    CNLinkedInCV *vc = (CNLinkedInCV*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNLinkedInCV class])];
    vc.delegate = self;
    _navController = [[UINavigationController alloc] initWithRootViewController:vc];
    _navController.navigationBar.hidden = true;
    [self presentViewController:_navController animated:YES completion:nil];
}

#pragma mark: - CNLinkedInDelegate
- (void)linkedInLoginSuccess:(UIViewController *)linkedInController withDictionary:(NSDictionary *)userInfo{
    
}

- (void)linkedInLoginFailed:(UIViewController *)linkedInController withError:(NSString *)error{
    [_navController dismissViewControllerAnimated:YES completion:nil];
    [[CNUtilities shared] showAlert:self withTitle:@"LinkedIn Login Failed" withMessage:error];
    [self.toggleLinkedIn setOn:false];
}

- (void)linkedInLoginCancelled:(UIViewController *)linkedInController{
    [_navController dismissViewControllerAnimated:YES completion:nil];
    [self.toggleLinkedIn setOn:false];
}

#pragma mark: - Snapchat
- (IBAction)toggleForSnapchat:(UISwitch *)sender {
    CNSnapchat *snapchat;
    if (self.profileType == CNProfileTypePersonal) {
        snapchat = self.user.pSnapchat;
    } else {
        snapchat = self.user.bSnapchat;
    }
    
    if (sender.on) {
        [self.mediaView initViewWithSocialType:@"snapchat"];
        [self showPopUp:self.mediaView withVerticalLayout:PopupViewVerticalLayoutAboveCenter];
    } else {
        if (snapchat.name != nil) {
            [[[self.socialRef child:@"snapchat"] child:@"active"] setValue:[NSNumber numberWithBool:sender.on]];
        }
    }

}

#pragma mark: - Vine
- (IBAction)toggleForVine:(UISwitch*)sender {
    CNVine *vine;
    if (self.profileType == CNProfileTypePersonal) {
        vine = self.user.pVine;
    } else {
        vine = self.user.bVine;
    }

    if (sender.on) {
        [self.mediaView initViewWithSocialType:@"vine"];
        [self showPopUp:self.mediaView withVerticalLayout:PopupViewVerticalLayoutAboveCenter];
    } else {
        if (vine.name != nil) {
            [[[self.socialRef child:@"vine"] child:@"active"] setValue:[NSNumber numberWithBool:sender.on]];
        }
    }

    
}

- (IBAction)toggleForPhone:(UISwitch *)sender {
    CNPhone *phone;
    if (self.profileType == CNProfileTypePersonal) {
        phone = self.user.pPhone;
    } else {
        phone = self.user.bPhone;
    }
    
    if (sender.on) {
        [self.mediaView initViewWithSocialType:@"phone"];
        [self showPopUp:self.mediaView withVerticalLayout:PopupViewVerticalLayoutAboveCenter];
    } else {
        if (phone.name != nil) {
            [[[self.socialRef child:@"phone"] child:@"active"] setValue:[NSNumber numberWithBool:sender.on]];
        }
    }
}

- (IBAction)toggleForSkype:(UISwitch *)sender {
    CNSkype *skype;
    if (self.profileType == CNProfileTypePersonal) {
        skype = self.user.pSkype;
    } else {
        skype = self.user.bSkype;
    }
    if (sender.on) {
        [self.mediaView initViewWithSocialType:@"skype"];
        [self showPopUp:self.mediaView withVerticalLayout:PopupViewVerticalLayoutAboveCenter];
    } else {
        if (skype.name != nil) {
            [[[self.socialRef child:@"skype"] child:@"active"] setValue:[NSNumber numberWithBool:sender.on]];
        }
    }
}

- (IBAction)onSave:(id)sender {
    [self showPopUp:self.saveSuccessView withVerticalLayout:PopupViewVerticalLayoutCenter];
}

#pragma mark - CNSaveSuccessViewDelegate
- (void)save{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- CNSocialMediaViewDelegate
- (void)saveWith:(NSString *)name socialType:(NSString *)socialType{
    
    NSDictionary *dict = @{@"name": name,
                           @"hidden": @false,
                           @"active": @true};
    
    if ([socialType isEqualToString:@"snapchat"]) {

        if (self.profileType == CNProfileTypePersonal) {
            self.user.pSnapchat = [[CNSnapchat alloc] initWithDictionary:dict];
        } else {
            self.user.bSnapchat = [[CNSnapchat alloc] initWithDictionary:dict];
        }
        [[self.socialRef child:@"snapchat"] setValue:dict];
        
    } else if([socialType isEqualToString:@"vine"]){
        if (self.profileType == CNProfileTypePersonal) {
            self.user.pVine = [[CNVine alloc] initWithDictionary:dict];
        } else {
            self.user.bVine = [[CNVine alloc] initWithDictionary:dict];
        }
        [[self.socialRef child:@"vine"] setValue:dict];
        
    } else if([socialType isEqualToString:@"phone"]){
        if (self.profileType == CNProfileTypePersonal) {
            self.user.pPhone = [[CNPhone alloc] initWithDictionary:dict];
        } else {
            self.user.bPhone = [[CNPhone alloc] initWithDictionary:dict];
        }
        [[self.socialRef child:@"phone"] setValue:dict];
        
    } else if([socialType isEqualToString:@"skype"]){
        if (self.profileType == CNProfileTypePersonal) {
            self.user.pSkype = [[CNSkype alloc] initWithDictionary:dict];
        } else {
            self.user.bSkype = [[CNSkype alloc] initWithDictionary:dict];
        }
        [[self.socialRef child:@"skype"] setValue:dict];
        
    }
}

- (void)cancel:(NSString*)socialType{
    if ([socialType isEqualToString:@"snapchat"]) {
        [self.toggleSnapchat setOn:false];
    } else if([socialType isEqualToString:@"vine"]){
        [self.toggleVine setOn:false];
    } else if([socialType isEqualToString:@"phone"]){
        [self.togglePhone setOn:false];
    } else if([socialType isEqualToString:@"skype"]){
        [self.toggleSkype setOn:false];
    }
}
@end
