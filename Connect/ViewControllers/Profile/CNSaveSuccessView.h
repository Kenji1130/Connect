//
//  CNSaveSuccessView.h
//  Connect
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CNSaveSuccessViewDelegate <NSObject>

- (void)save;

@end

@interface CNSaveSuccessView : UIView

@property (weak, nonatomic) id<CNSaveSuccessViewDelegate> delegate;


@end
