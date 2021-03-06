//
//  CNUserCell.m
//  Connect
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNUserCell.h"

@implementation CNUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithIndex:(NSInteger)index withUser:(CNUser*)user profileType:(CNProfileType) profileType{
    // Configure Cell
    self.socialType = index;
    self.socialKey = kSocialKey[self.socialType];
    self.profileType = profileType;
    
    NSDictionary *dict;
    if (self.profileType == CNProfileTypePersonal) {
        dict = user.socialPersonal[self.socialKey];
    } else {
        dict = user.socialBusiness[self.socialKey];
    }
    BOOL hidden = [dict[@"hidden"] boolValue];
    BOOL active = [dict[@"active"] boolValue];
    if (dict != nil && !hidden && active) {
        self.socialMediaLogo.hidden = false;
        self.socialMediaName.hidden = false;
    } else {
        self.socialMediaLogo.hidden = true;
        self.socialMediaName.hidden = true;
    }
    
    [self.socialMediaLogo setImage:[UIImage imageNamed:kSocialImage[self.socialType]]];
    self.socialMediaName.text = dict[@"name"];
//    BOOL hidden = [dict[@"hidden"] boolValue];
}

@end
