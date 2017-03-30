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

- (void)configureCellWithIndex:(NSInteger)index withUser:(CNUser*)user{
    // Configure Cell
    self.socialType = index;
    self.socialKey = kSocialKey[self.socialType];
    
    NSDictionary *dict = user.social[self.socialKey];
    BOOL hidden = [dict[@"hidden"] boolValue];
    if (dict != nil && !hidden) {
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
