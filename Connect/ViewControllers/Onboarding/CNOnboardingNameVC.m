//
//  CNOnboardingNameVC.m
//  Connect
//
//  Created by Daniel on 28/02/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingNameVC.h"
#import "CNOnboardingGenderSelectCV.h"

@interface CNOnboardingNameVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constOfLabelTop;

@property (weak, nonatomic) IBOutlet UITextField *txtFFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtFLastName;

@end

@implementation CNOnboardingNameVC

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
    if ([self.txtFFirstName.text isEqualToString:@""] || [self.txtFLastName.text isEqualToString:@""]) {

        [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:@"Please enter your name."];
        return;
    }
    
    [CNUser currentUser].firstName = self.txtFFirstName.text;
    [CNUser currentUser].lastName = self.txtFLastName.text;
    
    // Show onboarding snapchat vc
    CNOnboardingGenderSelectCV *vc = (CNOnboardingGenderSelectCV *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingGenderSelectCV class])];
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
