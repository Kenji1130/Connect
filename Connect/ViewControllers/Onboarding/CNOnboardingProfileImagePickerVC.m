//
//  CNOnboardingProfileImagePickerVC.m
//  Connect
//
//  Created by mac on 3/15/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNOnboardingProfileImagePickerVC.h"
#import "CNOnboardingUserTypeVC.h"
@interface CNOnboardingProfileImagePickerVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

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
    
}

#pragma mark - IBActions

-(void) selectProfileImage{
    NSLog(@"single Tap on profileImageView");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"From Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self showPhotoLibrary];
    }];
    [alert addAction:photoLibrary];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"From Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self showCamera];
    }];
    [alert addAction:camera];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    alert.popoverPresentationController.sourceView = self.profileImageView;
    alert.popoverPresentationController.sourceRect = self.profileImageView.bounds;
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)onBackBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNextBtnClicked:(id)sender {
    
    CNOnboardingUserTypeVC *vc = (CNOnboardingUserTypeVC *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingUserTypeVC class])];
    vc.profileImage = [_profileImageView image];

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showCamera{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        
    } else {

        [[CNUtilities shared] showAlert:self withTitle:@"Error" withMessage:@"Sorry, Your device has no camera."];
        return;
    }

}

- (void)showPhotoLibrary{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - ImagePickerViewController Delegate
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"cancel image picker");
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [_profileImageView setImage:info[UIImagePickerControllerEditedImage]];
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
