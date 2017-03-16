//
//  CNOnboardingProfileImagePickerVC.m
//  Connect
//
//  Created by mac on 3/15/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingProfileImagePickerVC.h"
#import "CNOnboardingPhoneInputVC.h"

@interface CNOnboardingProfileImagePickerVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *photoSelectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoSelectViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation CNOnboardingProfileImagePickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configLayout{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectProfileImage)];
    singleTap.numberOfTapsRequired = 1;
    [_profileImageView setUserInteractionEnabled:YES];
    [_profileImageView addGestureRecognizer:singleTap];

    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.width/2;
    _profileImageView.clipsToBounds = YES;
    
    _backgroundView.hidden = true;
}

#pragma mark - IBActions

-(void) selectProfileImage{
    NSLog(@"single Tap on profileImageView");
    [self showAnimationView:_photoSelectView];
}
- (IBAction)onPhotoClicked:(id)sender {
    [self showPhotoLibrary];
}

- (IBAction)onCameraClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        [self showCamera];
    } else {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"Error" message:@"Sorry, Your device has no camera." preferredStyle:UIAlertControllerStyleAlert];
        [alertCon addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self.navigationController presentViewController:alertCon animated:YES completion:nil];
        
        return;
    }
}

- (IBAction)onCancelPhotoPicker:(id)sender {
    [self hideAnimationView:_photoSelectView];
}

- (IBAction)onBackBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNextBtnClicked:(id)sender {
//     Show onboarding snapchat vc
    CNOnboardingPhoneInputVC *vc = (CNOnboardingPhoneInputVC *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingPhoneInputVC class])];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)showPhotoLibrary{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)showAnimationView:(UIView *) view{
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = CGRectMake(view.frame.origin.x, self.view.frame.size.height-view.frame.size.height, view.frame.size.width, view.frame.size.height);
        self.backgroundView.hidden = false;
    } completion:^(BOOL finished) { }];
    
}

- (void)hideAnimationView:(UIView *) view{
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = CGRectMake(view.frame.origin.x, self.view.frame.size.height, view.frame.size.width, view.frame.size.height);
        self.backgroundView.hidden = true;
    } completion:^(BOOL finished) { }];
    
}

#pragma mark - ImagePickerViewController Delegate
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"cancel image picker");
    [self hideAnimationView:_photoSelectView];
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [_profileImageView setImage:info[UIImagePickerControllerEditedImage]];
    [self hideAnimationView:_photoSelectView];
    [picker dismissViewControllerAnimated:YES completion:nil];

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
