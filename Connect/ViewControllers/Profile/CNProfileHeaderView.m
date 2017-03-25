//
//  CNProfileHeaderView.m
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNProfileHeaderView.h"
#import "CNSwitchView.h"

@interface CNProfileHeaderView () <UITextFieldDelegate>

@property (strong, nonatomic) CNSwitchView *profileSwitch;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;

@property (weak, nonatomic) IBOutlet UIImageView *ivBetaTesterImage;
@property (weak, nonatomic) IBOutlet UIButton *btnImagePick;

@property (weak, nonatomic) IBOutlet UIView *viewProfileInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblOccupation;
@property (weak, nonatomic) IBOutlet UIImageView *ivProfileChecked;

@property (weak, nonatomic) IBOutlet UIView *viewEditProfile;
@property (weak, nonatomic) IBOutlet UITextField *txtFName;
@property (weak, nonatomic) IBOutlet UITextField *txtFOccupation;

@property (strong, nonatomic) CNUser *user;
@property (assign, nonatomic) BOOL isEdit;

@end

@implementation CNProfileHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.btnImagePick.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    // Configure switch view
    self.profileSwitch = [[CNSwitchView alloc] initWithType:CNSwitchTypeProfile];
    self.profileSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.profileSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.profileSwitch];
    
    self.profileSwitch.layer.shadowOffset = CGSizeMake(0, 0);
    self.profileSwitch.layer.shadowRadius = 4;
    self.profileSwitch.layer.shadowOpacity = 0.1;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_profileSwitch);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-70-[_profileSwitch]-70-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-22-[_profileSwitch(40)]" options:0 metrics:nil views:views]];
    
    self.txtFName.delegate = self;
    self.txtFName.layer.borderWidth = 1.0;
    self.txtFName.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    
    self.txtFOccupation.delegate = self;
    self.txtFOccupation.layer.borderWidth = 1.0;
    self.txtFOccupation.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    
}

- (void)configureViewWithUser:(CNUser *)user isEdit:(BOOL)isEdit {
    // Configure View with user
    self.user = user;
    self.isEdit = isEdit;
    
    if (self.user.profileImageURL == nil) {
        self.ivProfileImage.backgroundColor = UIColorFromRGB(0xd1d1d1);
        self.ivProfileImage.image = [UIImage imageNamed:@"UIImageViewProfileIconPicture"];
        self.ivProfileImage.contentMode = UIViewContentModeCenter;
    } else {
        self.ivProfileImage.backgroundColor = [UIColor clearColor];
        [self.ivProfileImage setImageWithURL:self.user.profileImageURL placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.ivProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    self.ivBetaTesterImage.hidden = self.user.isMe;
    self.viewProfileInfo.hidden = self.isEdit;
    self.viewEditProfile.hidden = !self.isEdit;
    self.btnImagePick.hidden = !self.isEdit;
    
    if (!self.isEdit) {
        self.lblName.text = self.user.name;
        self.lblOccupation.text = self.user.occupation;
        [self.btnEdit setImage:[UIImage imageNamed:@"UIButtonProfileEdit"] forState:UIControlStateNormal];
        
    } else {
        self.txtFName.text = self.user.name;
        self.txtFOccupation.text = self.user.occupation;
        [self.btnEdit setImage:[UIImage imageNamed:@"UIButtonProfileDoneCheckmark"] forState:UIControlStateNormal];        
    }
    
    if (self.user.profileType == CNProfileTypePersonal) {
        self.backgroundColor = UIColorFromRGB(0xf0f0f0);
        self.btnEdit.tintColor = UIColorFromRGB(0x929eaf);
        self.btnSetting.tintColor = UIColorFromRGB(0x929eaf);
        self.lblName.textColor = kAppTextColor;
        self.lblOccupation.textColor = kAppTextColor;
        self.txtFName.textColor = kAppTextColor;
        self.txtFOccupation.textColor = kAppTextColor;
        
    } else if (self.user.profileType == CNProfileTypeBusiness) {
        self.backgroundColor = UIColorFromRGB(0x9a9a9b);
        self.btnEdit.tintColor = [UIColor whiteColor];
        self.btnSetting.tintColor = [UIColor whiteColor];
        self.lblName.textColor = [UIColor whiteColor];
        self.lblOccupation.textColor = [UIColor whiteColor];
        self.txtFName.textColor = [UIColor whiteColor];
        self.txtFOccupation.textColor = [UIColor whiteColor];
    }
}

#pragma mark - IBActions

- (void)switchValueChanged:(id)sender {
    CNSwitchView *cnSwitch = (CNSwitchView *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didProfileTypeChanged:)]) {
        [self.delegate didProfileTypeChanged:(cnSwitch.on ? CNProfileTypePersonal : CNProfileTypeBusiness)];
    }
}

- (IBAction)onEditBtnClicked:(id)sender {
    if (self.isEdit == NO) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didEditProfileTapped)]) {
            [self.delegate didEditProfileTapped];
        }
    } else {
        [self endEditing:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didEditProfileDone)]) {
            [self.delegate didEditProfileDone];
        }
    }
}

- (IBAction)onImagePickBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didProfileImageTapped)]) {
        [self.delegate didProfileImageTapped];
    }
}

@end
