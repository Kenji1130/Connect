//
//  CNProfileHeaderView.h
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CNProfileHeaderViewDelegate <NSObject>

- (void)didProfileTypeChanged:(CNProfileType)profileType;
- (void)didEditProfileTapped;
- (void)didEditProfileDone;
- (void)didProfileImageTapped;

@end

@interface CNProfileHeaderView : UIView

@property (weak, nonatomic) id<CNProfileHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *ivProfileImage;

- (void)configureViewWithUser:(CNUser *)user isEdit:(BOOL)isEdit;

@end
