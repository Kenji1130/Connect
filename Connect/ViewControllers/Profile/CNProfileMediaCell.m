//
//  CNProfileMediaCell.m
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNProfileMediaCell.h"

@interface CNProfileMediaCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ivSocialMediaLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;

@property (weak, nonatomic) IBOutlet UIView *viewCurrentOptions;
@property (weak, nonatomic) IBOutlet UIButton *btnDrag;
@property (weak, nonatomic) IBOutlet UISwitch *mediaSwitch;

@property (weak, nonatomic) IBOutlet UIView *viewOtherOptions;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIButton *btnViewProfile;

@property (weak, nonatomic) IBOutlet UIView *viewEditOptions;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@property (assign, nonatomic) CNProfileType profileType;
@property (assign, nonatomic) BOOL isEdit;
@property (assign, nonatomic) BOOL isCurrent;

@end

@implementation CNProfileMediaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    self.btnViewProfile.layer.borderWidth = 1.0;
    self.btnViewProfile.layer.borderColor = kAppTintColor.CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithIndex:(NSInteger)index withType:(CNProfileType)profileType isEdit:(BOOL)isEdit isCurrent:(BOOL)isCurrent {
    // Configure Cell
    self.profileType = profileType;
    self.isEdit = isEdit;
    self.isCurrent = isCurrent;
    
    self.viewCurrentOptions.hidden = !(isCurrent && !isEdit);
    self.viewOtherOptions.hidden = isCurrent;
    self.viewEditOptions.hidden = !(isCurrent && isEdit);
    self.btnEdit.hidden = YES;
    
    NSArray *items;
    if (self.profileType == CNProfileTypePersonal) {
        items = @[@{@"image" : @"UIImageViewProfileFacebook", @"username" : @"Roxie Caldwell"},
                  @{@"image" : @"UIImageViewProfileSnapchat", @"username" : @"roxiecaldwell"},
                  @{@"image" : @"UIImageViewProfileTwitter", @"username" : @"roxiecaldwell"},
                  @{@"image" : @"UIImageViewProfilePhone", @"username" : @"626-397-9511"}];
        
    } else if (self.profileType == CNProfileTypeBusiness) {
        items = @[@{@"image" : @"UIImageViewProfileFacebook", @"username" : @"Roxie Caldwell"},
                  @{@"image" : @"UIImageViewProfileLinkedIn", @"username" : @"Roxie Caldwell"},
                  @{@"image" : @"UIImageViewProfileEmail", @"username" : @"roxie@asana.com"},
                  @{@"image" : @"UIImageViewProfileSkype", @"username" : @"roxiecaldwell"}];
    }
    
    self.ivSocialMediaLogo.image = [UIImage imageNamed:[items[index - (self.isEdit ? 1 : 0)] objectForKey:@"image"]];
    self.lblUsername.text = [items[index - (self.isEdit ? 1 : 0)] objectForKey:@"username"];
    
    if (!self.viewOtherOptions.hidden && self.profileType == CNProfileTypePersonal && index == 3) {
        self.viewOtherOptions.hidden = YES;
    }
    
}

@end
