//
//  CNOnboardingSnapchatVC.m
//  Connect
//
//  Created by Daniel on 30/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingSnapchatVC.h"
#import "CNOnboardingNameVC.h"

@interface CNOnboardingSnapchatVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constOfUsernameTop;
@property (weak, nonatomic) IBOutlet UITextField *txtFUsername;

@end

@implementation CNOnboardingSnapchatVC

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
    if ([self.txtFUsername.text isEqualToString:@""]) {

        [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:@"Please enter your snapchat username."];
        return;
    }
    
    [CNUser currentUser].username = self.txtFUsername.text;
    
    // Show onboarding name vc
    CNOnboardingNameVC *vc = (CNOnboardingNameVC *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingNameVC class])];
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
