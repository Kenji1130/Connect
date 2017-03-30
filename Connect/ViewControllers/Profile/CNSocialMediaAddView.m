//
//  CNSocialMediaAddView.m
//  Connect
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNSocialMediaAddView.h"
@import PopupKit;
#import <QuartzCore/QuartzCore.h>
#import "CNFacebookVC.h"

@implementation CNSocialMediaAddView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)onDismiss:(id)sender {
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
}

- (IBAction)facebookSwitchChanged:(UISwitch*)sender {
    [self.delegate toggleForFacebook:sender];
}

- (IBAction)twitterSwitchChanged:(UISwitch*)sender {
    [self.delegate toggleForTwitter:sender];
}

- (IBAction)instagramSwitchChanged:(UISwitch*)sender {
    [self.delegate toggleForInstagram:sender];
}

- (IBAction)linkedInSwitchChanged:(UISwitch*)sender {
    [self.delegate toggleForLinkedIn:sender];
}

- (IBAction)onSave:(id)sender {
    [self.delegate saveWithSocialMedia];
    [self onDismiss:sender];
}


@end
