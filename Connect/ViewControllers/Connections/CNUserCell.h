//
//  CNUserCell.h
//  Connect
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *socialMediaLogo;
@property (weak, nonatomic) IBOutlet UILabel *socialMediaName;
@property (assign, nonatomic) CNProfileType profileType;
@property (assign, nonatomic) CNSocialType socialType;
@property (strong, nonatomic) NSString *socialKey;

- (void)configureCellWithIndex:(NSInteger)index withUser:(CNUser*)user;
    
@end
