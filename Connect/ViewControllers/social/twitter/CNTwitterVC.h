//
//  CNTwitterVC.h
//  Connect
//
//  Created by mac on 3/27/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CNTwitterDelegate <NSObject>

@optional
- (void)twitterLoginSuccess:(UIViewController*) twitterController withDictionary:(NSDictionary *)userInfo;
- (void)twitterLoginCancelled:(UIViewController*) twitterController;
- (void)twiterLoginFailed:(UIViewController*) twitterController withError:(NSString*) error;

@end


@interface CNTwitterVC : UIViewController
@property (nonatomic, weak) id <CNTwitterDelegate> delegate;

@end
