//
//  CNOnboardingPhoneInputVC.m
//  Connect
//
//  Created by Daniel on 30/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingPhoneInputVC.h"
#import "CNOnboardingVerifyCodeVC.h"

@interface CNOnboardingPhoneInputVC ()

@property (weak, nonatomic) IBOutlet UITextField *txtFPhoneNumber;

@end

@implementation CNOnboardingPhoneInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureLayout];
    
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

- (void)configureLayout {
    // Configure Layout
    self.txtFPhoneNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your phone number"
                                                                                 attributes:@{NSFontAttributeName : [UIFont fontWithName:@"ProximaNovaA-Light" size:20.0]}];
    
}

- (BOOL)validatePhone:(NSString *)phoneNumber {
    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:phoneNumber];
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
    if ([self.txtFPhoneNumber.text isEqualToString:@""]) {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"Error" message:@"Your phone number is empty." preferredStyle:UIAlertControllerStyleAlert];
        [alertCon addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self.navigationController presentViewController:alertCon animated:YES completion:nil];
        
        return;
    }
    
    NSString *phoneNumber = [NSString stringWithFormat:@"+1%@", self.txtFPhoneNumber.text];
    
    if (![self validatePhone:phoneNumber]) {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"Error" message:@"Your phone number is not valid." preferredStyle:UIAlertControllerStyleAlert];
        [alertCon addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self.navigationController presentViewController:alertCon animated:YES completion:nil];
        
        return;
    }
    
    Digits *digits = [Digits sharedInstance];
    DGTAuthenticationConfiguration *configuration = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsDefaultOptionMask];
    configuration.phoneNumber = self.txtFPhoneNumber.text;
    
    [digits authenticateWithViewController:nil configuration:configuration completion:^(DGTSession *session, NSError *error){
        if (session) {
            // Add user to db
            [CNUser currentUser].phoneNumber = phoneNumber;
            [CNUser currentUser].profileType = CNProfileTypePersonal;
            
            NSDictionary *userInfo = @{@"username": [CNUser currentUser].username,
                                       @"firstName": [CNUser currentUser].firstName,
                                       @"lastName": [CNUser currentUser].lastName,
                                       @"phoneNumber": phoneNumber,
                                       @"profileType": [NSNumber numberWithInteger:[CNUser currentUser].profileType]};
            
            FIRDatabaseReference *userRef = [[[AppDelegate sharedInstance].dbRef child:@"users"] childByAutoId];
            [userRef setValue:userInfo withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                
                NSLog(@"user id = %@", ref.key);
                [CNUser currentUser].userID = ref.key;
                
                // Save login status
                [[NSUserDefaults standardUserDefaults] setObject:ref.key forKey:kLoggedUserID];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Show main screens
                    [[AppDelegate sharedInstance] showMain];
                    
                    // Show onboarding snapchat vc
                    // CNOnboardingVerifyCodeVC *vc = (CNOnboardingVerifyCodeVC *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingVerifyCodeVC class])];
                    // [self.navigationController pushViewController:vc animated:YES];
                });
            }];

        } else {
            NSLog(@"Authentication error: %@", error.localizedDescription);
        }
    }];
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
