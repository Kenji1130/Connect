//
//  CNMyProfileCell.m
//  Connect
//
//  Created by mac on 3/24/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNMyProfileCell.h"

@implementation CNMyProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.user = [CNUser currentUser];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithIndex:(NSInteger)index withType:(CNProfileType)profileType isEdit:(BOOL)isEdit {
    // Configure Cell
    self.profileType = profileType;
    self.isEdit = isEdit;
    self.socialType = index;
    self.socialKey = kSocialKey[self.socialType];
    
    NSDictionary *dict = self.user.social[self.socialKey];
    BOOL active = [dict[@"active"] boolValue];
    if (dict != nil && active) {
        self.socialMediaLogo.hidden = false;
        self.socialMediaName.hidden = false;
        self.toggle.hidden = !isEdit;
    } else {
        self.socialMediaLogo.hidden = true;
        self.socialMediaName.hidden = true;
        self.toggle.hidden = true;
    }
    
    [self.socialMediaLogo setImage:[UIImage imageNamed:kSocialImage[self.socialType]]];
    self.socialMediaName.text = dict[@"name"];
    BOOL hidden = [dict[@"hidden"] boolValue];
    [self.toggle setOn:hidden];
}

- (IBAction)onToggle:(UISwitch*)sender {
    self.userRef = [[[[[AppDelegate sharedInstance].dbRef child:@"users"] child:self.user.userID] child:@"social"] child:self.socialKey];
    NSDictionary *dict = @{@"hidden": [NSNumber numberWithBool:sender.on]};
    [self.userRef updateChildValues:dict];
}

@end
