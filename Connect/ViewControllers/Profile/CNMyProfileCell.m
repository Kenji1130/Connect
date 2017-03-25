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

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithIndex:(NSInteger)index withType:(CNProfileType)profileType isEdit:(BOOL)isEdit {
    // Configure Cell
    self.profileType = profileType;
    self.isEdit = isEdit;

    NSArray *items;
    if (self.profileType == CNProfileTypePersonal || self.profileType == CNProfileTypeBoth) {
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
    
    self.socialMediaLogo.image = [UIImage imageNamed:[items[index] objectForKey:@"image"]];
    self.socialMediaName.text = [items[index] objectForKey:@"username"];
    self.toggle.hidden = !self.isEdit;

}
@end
