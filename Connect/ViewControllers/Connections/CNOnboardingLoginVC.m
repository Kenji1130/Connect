//
//  CNOnboardingLoginVC.m
//  Connect
//
//  Created by mac on 3/17/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingLoginVC.h"
#import "CNOnboardingSnapchatVC.h"

@interface CNOnboardingLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@end

@implementation CNOnboardingLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)configureLayout {
    // Configures layout
    
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
        [self signWithEmail:_tfEmail.text password:_tfPassword.text];
    }

}

- (void) signWithEmail:(NSString*) email password:(NSString*) password{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FIRAuth auth]
     signInWithEmail:email
     password:password
     completion:^(FIRUser *_Nullable user,
                  NSError *_Nullable error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (error != nil) {
             NSLog(@"Error: %@", error);
         } else{
             NSLog(@"LogIn Success");
             
         }
     }];
}
    
- (IBAction)onSignUp:(id)sender {
    CNOnboardingSnapchatVC *vc = (CNOnboardingSnapchatVC *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingSnapchatVC class])];
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
