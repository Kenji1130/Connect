//
//  CNOnboardingEmailInputVC.m
//  Connect
//
//  Created by mac on 3/17/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingEmailInputVC.h"
#import "CNOnboardingPasswordVC.h"

@interface CNOnboardingEmailInputVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;

@end

@implementation CNOnboardingEmailInputVC

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
    if (![[CNUtilities shared] validateEmail:_tfEmail.text]) {
        
        [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:@"Please enter your email correctly."];
        return;
    }
    
    [CNUser currentUser].email = self.tfEmail.text;
    
    // Show onboarding name vc
    CNOnboardingPasswordVC *vc = (CNOnboardingPasswordVC *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingPasswordVC class])];
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
