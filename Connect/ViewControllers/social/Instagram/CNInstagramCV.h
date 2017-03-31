//
//  CNInstagramCV.h
//  Connect
//
//  Created by mac on 3/17/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CNInstagramDelegate <NSObject>

@optional
- (void)instagramLoginSuccess:(UIViewController*) instagramController withDictionary:(NSDictionary *)userInfo;
- (void)instagramLoginCancelled:(UIViewController*) instagramController;
- (void)instagramLoginFailed:(UIViewController*) instagramController withError:(NSString*) error;

@end

@interface CNInstagramCV : UIViewController

@property (nonatomic, weak) id<CNInstagramDelegate> delegate;
@end
