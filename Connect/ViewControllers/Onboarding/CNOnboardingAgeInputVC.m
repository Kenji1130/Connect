//
//  CNOnboardingAgeInputVC.m
//  Connect
//
//  Created by mac on 3/15/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingAgeInputVC.h"
#import "CNOnboardingProfileImagePickerVC.h"

@interface CNOnboardingAgeInputVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfBirth;

@end

@implementation CNOnboardingAgeInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    [self.tfBirth setInputView:datePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.tfBirth setInputAccessoryView:toolBar];
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
    
    if ([self.tfBirth.text isEqualToString:@""]) {

        [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:@"Please enter your birthday."];
        return;
    }
    
    [CNUser currentUser].birth = self.tfBirth.text;
    
    // Show onboarding snapchat vc
    CNOnboardingProfileImagePickerVC *vc = (CNOnboardingProfileImagePickerVC *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingProfileImagePickerVC class])];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)ShowSelectedDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    self.tfBirth.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.tfBirth resignFirstResponder];
}

@end
