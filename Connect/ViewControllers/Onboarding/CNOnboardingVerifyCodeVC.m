//
//  CNOnboardingVerifyCodeVC.m
//  Connect
//
//  Created by Daniel on 30/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingVerifyCodeVC.h"

@interface CNOnboardingVerifyCodeVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtFCode1;
@property (weak, nonatomic) IBOutlet UITextField *txtFCode2;
@property (weak, nonatomic) IBOutlet UITextField *txtFCode3;
@property (weak, nonatomic) IBOutlet UITextField *txtFCode4;

@property (weak, nonatomic) IBOutlet UIView *verifyView;

@end

@implementation CNOnboardingVerifyCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.verifyView.hidden = YES;
    
    NSArray *array = @[self.txtFCode1, self.txtFCode2, self.txtFCode3, self.txtFCode4];
    for (UITextField *textField in array) {
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - IBActions

- (IBAction)onBackBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNextBtnClicked:(id)sender {
    // Check if code is verified or not
    if (self.verifyView.hidden) {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"Error" message:@"Your code is wrong." preferredStyle:UIAlertControllerStyleAlert];
        [alertCon addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self.navigationController presentViewController:alertCon animated:YES completion:nil];
        
        return;
    }
    
    // Show main screens
    [[AppDelegate sharedInstance] showMain];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![textField.text isEqualToString:@""]) {
        if (textField == self.txtFCode4) {
            [textField resignFirstResponder];
        } else {
            NSArray *array = @[self.txtFCode1, self.txtFCode2, self.txtFCode3, self.txtFCode4];
            UITextField *nextCode = [array objectAtIndex:[array indexOfObject:textField] + 1];
            [nextCode becomeFirstResponder];
        }
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0)
        return YES;
    
    if (textField.text.length == 1) {
        textField.text = string;
        [self textFieldShouldReturn:textField];
        
        [self verifyCode];
        
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSArray *array = @[self.txtFCode1, self.txtFCode2, self.txtFCode3, self.txtFCode4];
    NSInteger index = [array indexOfObject:textField];
    if (index != 3 && textField.text.length == 1) {
        UITextField *nextCode = [array objectAtIndex:index + 1];
        [nextCode becomeFirstResponder];
    }
    
    [self verifyCode];
}

- (void)verifyCode {
    // Verify code
    NSString *code = [NSString stringWithFormat:@"%@%@%@%@", self.txtFCode1.text, self.txtFCode2.text, self.txtFCode3.text, self.txtFCode4.text];
    if ([code isEqualToString:@"1111"]) {
        self.verifyView.hidden = NO;
    } else {
        self.verifyView.hidden = YES;
    }
}

- (NSString*)formatPhoneNumber:(NSString *)phoneString{
    NSString *phoneNumber = [[phoneString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    if (phoneNumber.length > 6) {
        return [NSString stringWithFormat:@"%@-%@-%@", [phoneNumber substringToIndex:3], [phoneNumber substringWithRange:NSMakeRange(3, 3)], [phoneNumber substringFromIndex:6]];
    } else if (phoneNumber.length > 3) {
        return [NSString stringWithFormat:@"%@-%@", [phoneNumber substringToIndex:3], [phoneNumber substringFromIndex:3]];
    } else
        return phoneNumber;
    
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
