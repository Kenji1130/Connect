//
//  CNSaveSuccessView.m
//  Connect
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNSaveSuccessView.h"
@import PopupKit;

@implementation CNSaveSuccessView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)onDismiss:(id)sender {
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
        
        [self.delegate save];
    }
}


@end
