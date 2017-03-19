//
//  CNOnboardingUserTypeVC.m
//  Connect
//
//  Created by mac on 3/17/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingUserTypeVC.h"

@interface CNOnboardingUserTypeVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnPersonal;
@property (weak, nonatomic) IBOutlet UIButton *btnBusiness;
@property (weak, nonatomic) IBOutlet UIButton *btnBoth;

@end

@implementation CNOnboardingUserTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self onUserType:_btnPersonal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
    
- (IBAction)onBackBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onUserType:(id)sender {
    if ([sender tag] == 0) {
        [CNUser currentUser].profileType = CNProfileTypePersonal;
        _btnPersonal.layer.borderColor = kAppTintColor.CGColor;
        _btnBusiness.layer.borderColor = [UIColor blackColor].CGColor;
        _btnBoth.layer.borderColor = [UIColor blackColor].CGColor;
    } else if ([sender tag] == 1){
        [CNUser currentUser].profileType = CNProfileTypeBusiness;
        _btnPersonal.layer.borderColor = [UIColor blackColor].CGColor;
        _btnBusiness.layer.borderColor = kAppTintColor.CGColor;
        _btnBoth.layer.borderColor = [UIColor blackColor].CGColor;
    } else {
        [CNUser currentUser].profileType = CNProfileTypeBoth;
        _btnPersonal.layer.borderColor = [UIColor blackColor].CGColor;
        _btnBusiness.layer.borderColor = [UIColor blackColor].CGColor;
        _btnBoth.layer.borderColor = kAppTintColor.CGColor;
    }
    
}
    
- (IBAction)onNextBtnClicked:(id)sender {
  
    [self signUpWithEmail:[CNUser currentUser].email password:[CNUser currentUser].password];
}

- (void) signUpWithEmail:(NSString*) email password:(NSString*) password{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FIRAuth auth]
     createUserWithEmail:email
     password:password
     completion:^(FIRUser *_Nullable user,
                  NSError *_Nullable error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:error.localizedDescription];
             
         } else {
             [CNUser currentUser].userID = user.uid;
             [self uploadProfileImage];
         }
     }];
}
    
- (void) uploadProfileImage{
    NSString *imageName = [NSString stringWithFormat:@"%@%@", [CNUser currentUser].userID, @".jpg"];
    FIRStorageReference *imageRef = [[[AppDelegate sharedInstance].storageRef child:@"profile_image"] child:imageName];
    
    // Create file metadata including the content type
    FIRStorageMetadata *meta = [[FIRStorageMetadata alloc] init];
    meta.contentType = @"image/jpeg";
    
    // Upload the file
    NSData *data = UIImageJPEGRepresentation(_profileImage, 0.1);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [imageRef putData:data metadata:meta completion:^(FIRStorageMetadata *metadata, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error != nil) {
            // Uh-oh, an error occurred!
            NSLog(@"Error: %@", error.localizedDescription);
            [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:error.localizedDescription];
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            NSURL *downloadURL = metadata.downloadURL;
            [CNUser currentUser].imageURL = metadata.downloadURL.absoluteString;
            [self saveProfileInfo:downloadURL];
        }
    }];
}
    
- (void) saveProfileInfo: (NSURL*) profileImageUrl{
    
    NSDictionary *info = @{@"username": [CNUser currentUser].username,
                               @"firstName": [CNUser currentUser].firstName,
                               @"lastName": [CNUser currentUser].lastName,
                               @"gender": [NSNumber numberWithInteger:[CNUser currentUser].gender],
                               @"age": [CNUser currentUser].age,
                               @"profileType": [NSNumber numberWithInteger:[CNUser currentUser].profileType],
                               @"signType": [NSNumber numberWithInteger:[CNUser currentUser].signType],
                               @"imageURL": [CNUser currentUser].imageURL};
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:info];
    if ([CNUser currentUser].signType == CNSignTypeEmail) {
        [userInfo setValue:[CNUser currentUser].email forKey:@"email"];
        [userInfo setValue:[CNUser currentUser].password forKey:@"password"];
    } else {
        [userInfo setValue:[CNUser currentUser].phoneNumber forKey:@"phoneNumber"];
    }
    
    FIRDatabaseReference *userRef = [[[AppDelegate sharedInstance].dbRef child:@"users"] child:[CNUser currentUser].userID];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [userRef setValue:userInfo withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:error.localizedDescription];
        } else {
            // Save login status
            [[NSUserDefaults standardUserDefaults] setObject:[CNUser currentUser].userID forKey:kLoggedUserID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Show main screens
                [[AppDelegate sharedInstance] showMain];
                
            });
        }

    }];
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
