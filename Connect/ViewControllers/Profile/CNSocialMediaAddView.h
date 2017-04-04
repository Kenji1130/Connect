//
//  CNSocialMediaAddView.h
//  Connect
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CNSocialMediaAddViewDelegate <NSObject>

- (void)saveWith:(NSString*)name socialType:(NSString*)socialType;
- (void)cancel:(NSString*)socialType;

@end


@interface CNSocialMediaAddView : UIView
@property (weak, nonatomic) id<CNSocialMediaAddViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (strong, nonatomic) NSString *socialType;

- (void)initViewWithSocialType:(NSString*)socialType;
@end
