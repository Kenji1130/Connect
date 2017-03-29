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
@property (strong, nonatomic) CNUser *user;
@property (assign, nonatomic) CNProfileType profileType;
@property (assign, nonatomic) CNSocialType socialType;
@property (strong, nonatomic) NSString *socialKey;
@property (weak, nonatomic) IBOutlet UIImageView *socialMediaLogo;
@property (weak, nonatomic) IBOutlet UILabel *socialMediaName;
@property (weak, nonatomic) IBOutlet UISwitch *toggle;

@property (strong, nonatomic) FIRDatabaseReference *userRef;

- (void)configureCellWithIndex:(NSInteger)index withType:(CNProfileType)profileType isEdit:(BOOL)isEdit;

@end
