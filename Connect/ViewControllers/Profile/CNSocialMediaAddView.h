//
//  CNSocialMediaAddView.h
//  Connect
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CNSocialMediaAddViewDelegate <NSObject>

- (void)toggleForFacebook: (UISwitch*)sender;
- (void)toggleForTwitter: (UISwitch*)sender;
- (void)toggleForInstagram: (UISwitch*)sender;
- (void)toggleForLinkedIn: (UISwitch*)sender;
- (void)toggleForSnapchat: (UISwitch*)sender;
- (void)toggleForVine: (UISwitch*)sender;
- (void)toggleForPhone: (UISwitch*)sender;
- (void)toggleForSkype: (UISwitch*)sender;
- (void)saveWithSocialMedia;

@end


@interface CNSocialMediaAddView : UIView
@property (weak, nonatomic) id<CNSocialMediaAddViewDelegate> delegate;

@end
