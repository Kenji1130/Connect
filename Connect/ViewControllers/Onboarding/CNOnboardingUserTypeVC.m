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
