//
//  CNOnboardingLoginVC.m
//  Connect
//
//  Created by mac on 3/17/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingLoginVC.h"
#import "CNOnboardingEmailInputVC.h"

@interface CNOnboardingLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@end

@implementation CNOnboardingLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
#pragma mark - Helpers
    
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
    
#pragma mark - IBActions
    
- (IBAction)onBackBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
    
- (IBAction)onLogIn:(id)sender {
    if (![[CNUtilities shared] validateEmail:self.tfEmail.text]) {
        [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:@"Please enter your email correctly."];
        return;
    } else if([self.tfPassword.text isEqualToString:@""]){
        [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:@"Please enter your password."];
        return;
    } else {
        [self loginWithEmail:_tfEmail.text password:[[CNUtilities shared] md5:_tfPassword.text]];
    }

}

- (void) loginWithEmail:(NSString*) email password:(NSString*) password{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FIRAuth auth]
     signInWithEmail:email
     password:password
     completion:^(FIRUser *_Nullable user,
                  NSError *_Nullable error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (error != nil) {
             NSLog(@"Error: %@", error.localizedDescription);
             [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:error.localizedDescription];
         } else{
             NSLog(@"LogIn Success");
             [self fetchUserInfo:user.uid];
         }
     }];
}

- (void) fetchUserInfo:(NSString*) userId{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[[[AppDelegate sharedInstance].dbRef child:@"users"] child:userId] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        NSLog(@"value: %@", snapshot);
        
        if (![snapshot.value isEqual:[NSNull null]]) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:snapshot.value];
            
            [[CNUser currentUser] configureUserWithDictionary:userInfo];
        }
        
        // Save login status
        [[CNUtilities shared] saveLoggedUserID:[CNUser currentUser].userID];
        [[AppDelegate sharedInstance] updateToken];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Show main screens
            [[AppDelegate sharedInstance] showMain];
        });
        
        // ...
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}
    
- (IBAction)onSignUp:(id)sender {
    CNOnboardingEmailInputVC *vc = (CNOnboardingEmailInputVC *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingEmailInputVC class])];
    [self.navigationController pushViewController:vc animated:YES];
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
