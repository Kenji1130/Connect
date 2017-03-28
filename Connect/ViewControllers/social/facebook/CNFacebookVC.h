//
//  CNFacebookVC.h
//  Connect
//
//  Created by mac on 3/27/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CNFacebookDelegate <NSObject>

@optional
- (void)facebookLoginSuccess:(UIViewController*) facebookController withDictionary:(NSDictionary *)userInfo;
- (void)facebookLoginCancelled:(UIViewController*) facebookController;
- (void)facebookLoginFailed:(UIViewController*) facebookController withError:(NSString*) error;

@end

@interface CNFacebookVC : UIViewController
@property (nonatomic, weak) id <CNFacebookDelegate> delegate;

@end

