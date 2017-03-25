//
//  CNMyProfileCell.h
//  Connect
//
//  Created by mac on 3/24/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNMyProfileCell : UITableViewCell
@property (assign, nonatomic) BOOL isEdit;
@property (assign, nonatomic) CNProfileType profileType;
@property (weak, nonatomic) IBOutlet UIImageView *socialMediaLogo;
@property (weak, nonatomic) IBOutlet UILabel *socialMediaName;
@property (weak, nonatomic) IBOutlet UISwitch *toggle;

- (void)configureCellWithIndex:(NSInteger)index withType:(CNProfileType)profileType isEdit:(BOOL)isEdit;
@end
