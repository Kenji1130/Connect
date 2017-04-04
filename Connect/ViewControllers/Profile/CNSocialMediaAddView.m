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

- (IBAction)onCancel:(id)sender {
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
        
        [self.delegate cancel:self.socialType];
    }
}

- (IBAction)onSave:(id)sender {
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
        
        [self.delegate saveWith:self.tfName.text socialType:self.socialType];
    }
}

- (void)initViewWithSocialType:(NSString *)socialType{
    self.tfName.text = @"";
    self.socialType = socialType;
    if ([self.socialType isEqualToString:@"snapchat"]) {
        self.lbTitle.text = @"Please enter your snapchat name.";
    } else if ([self.socialType isEqualToString:@"vine"]){
        self.lbTitle.text = @"Please enter your vine name.";

    } else if ([self.socialType isEqualToString:@"phone"]){
        self.lbTitle.text = @"Please enter your phone number.";

    } else if ([self.socialType isEqualToString:@"skype"]){
        self.lbTitle.text = @"Please enter your skype id.";

    }
    
}

@end
