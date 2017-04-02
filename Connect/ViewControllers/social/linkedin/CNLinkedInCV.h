//
//  CNLinkedInCV.h
//  Connect
//
//  Created by mac on 3/28/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CNLinkedInDelegate <NSObject>

@optional
- (void)linkedInLoginSuccess:(UIViewController*) linkedInController withDictionary:(NSDictionary *)userInfo;
- (void)linkedInLoginCancelled:(UIViewController*) linkedInController;
- (void)linkedInLoginFailed:(UIViewController*) linkedInController withError:(NSString*) error;

@end

@interface CNLinkedInCV : UIViewController

@property (weak, nonatomic) id<CNLinkedInDelegate> delegate;
@end
