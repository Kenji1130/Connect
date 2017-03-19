//
//  CNOnboardingSignTypeVC.m
//  Connect
//
//  Created by mac on 3/17/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingSignTypeVC.h"
#import "CNOnboardingLoginVC.h"
#import "CNOnboardingPhoneInputVC.h"

@interface CNOnboardingSignTypeVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnSignWithEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnSignWithPhone;

@end

@implementation CNOnboardingSignTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configLayout];
}

- (void) configLayout{
    _btnSignWithEmail.layer.borderColor = kAppTintColor.CGColor;
    _btnSignWithPhone.layer.borderColor = kAppTintColor.CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
    
- (IBAction)onBackBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
    
- (IBAction)onSignWithEmail:(id)sender {
    CNOnboardingLoginVC *vc = (CNOnboardingLoginVC *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingLoginVC class])];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onSignWithPhone:(id)sender {
    CNOnboardingPhoneInputVC *vc = (CNOnboardingPhoneInputVC *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingPhoneInputVC class])];
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
