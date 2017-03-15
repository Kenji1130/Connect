//
//  CNOnboardingGenderSelectCV.m
//  Connect
//
//  Created by mac on 3/15/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingGenderSelectCV.h"
#import "CNOnboardingAgeInputVC.h"

@interface CNOnboardingGenderSelectCV ()
@property (weak, nonatomic) IBOutlet UIButton *btnMale;
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;
@property (weak, nonatomic) IBOutlet UIButton *btnOther;

@end

@implementation CNOnboardingGenderSelectCV

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureLayout];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureLayout{
    [self onGenderBtnClicked:_btnMale];
}


#pragma mark - IBActions

- (IBAction)onBackBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNextBtnClicked:(id)sender {
    // Show onboarding snapchat vc
    CNOnboardingAgeInputVC *vc = (CNOnboardingAgeInputVC *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingAgeInputVC class])];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onGenderBtnClicked:(id)sender {
    if ([sender tag] == 0) {
        [CNUser currentUser].userGender = CNUserMale;
        [[self.btnMale layer] setBorderColor:kAppTintColor.CGColor];
        [[self.btnFemale layer] setBorderColor: [UIColor blackColor].CGColor];
        [[self.btnOther layer] setBorderColor: [UIColor blackColor].CGColor];
    } else if ([sender tag] == 1){
        [CNUser currentUser].userGender = CNUserFemalle;
        [[self.btnFemale layer] setBorderColor:kAppTintColor.CGColor];
        [[self.btnMale layer] setBorderColor: [UIColor blackColor].CGColor];
        [[self.btnOther layer] setBorderColor: [UIColor blackColor].CGColor];
    } else {
        [CNUser currentUser].userGender = CNUserOther;
        [[self.btnOther layer] setBorderColor:kAppTintColor.CGColor];
        [[self.btnMale layer] setBorderColor: [UIColor blackColor].CGColor];
        [[self.btnFemale layer] setBorderColor: [UIColor blackColor].CGColor];
    }
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
