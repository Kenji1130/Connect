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

@property (strong, nonatomic) NSMutableArray *emails;
@end

@implementation CNOnboardingEmailInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadEmails];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadEmails{
    self.emails = [[NSMutableArray alloc] init];
    FIRDatabaseReference *emailRef = [[AppDelegate sharedInstance].dbRef child:@"emails"];
    [emailRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        while (child = [children nextObject]) {
            [self.emails addObject:child.value];
        }
    }];
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
    
//    [self goNext];
    
    if ([self.emails containsObject:self.tfEmail.text]) {
        [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:@"Sorry, This email is already exist."];
    } else {
        [self goNext];
    }
}


- (void)goNext{
    
    [CNUser currentUser].email = self.tfEmail.text;
    // Show onboarding name vc
    CNOnboardingPasswordVC *vc = (CNOnboardingPasswordVC *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingPasswordVC class])];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
