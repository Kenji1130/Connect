//
//  CNOnboardingPasswordVC.m
//  Connect
//
//  Created by mac on 3/17/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingPasswordVC.h"
#import "CNOnboardingSnapchatVC.h"

@interface CNOnboardingPasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfPasswordConfirm;

@end

@implementation CNOnboardingPasswordVC

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
    
- (IBAction)onNextBtnClicked:(id)sender {
    if ([_tfPassword.text isEqualToString:@""]) {
        [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:@"Please enter your password"];
        return;
    }
    if ([_tfPasswordConfirm.text isEqualToString:@""]) {
        [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:@"Please confirm password"];
        return;
    }
    if (![_tfPassword.text isEqualToString:_tfPasswordConfirm.text]) {
        [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:@"Password does not matched."];
        return;
    }
    
    [CNUser currentUser].password = [[CNUtilities shared] md5:_tfPassword.text];
    CNOnboardingSnapchatVC *vc = (CNOnboardingSnapchatVC*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingSnapchatVC class])];
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
