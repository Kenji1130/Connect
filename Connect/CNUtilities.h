//
//  CNUtilities.h
//  Connect
//
//  Created by Daniel on 30/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNUtilities : NSObject
+ (instancetype)shared;
    
- (void)showAlert:(UIViewController*)vc withTitle:(NSString *)title withMessage:(NSString *)message;
- (NSString *) md5:(NSString *) input;
- (BOOL)validateEmail:(NSString *)emailStr;
- (BOOL)validatePhone:(NSString *)phoneNumber;
- (void)saveLoggedUserID:(NSString*) userId;
- (NSString*)getLoggedUserID;
- (void)saveToken:(NSString*) token;
- (NSString*)getToken;
- (void) httpJsonRequest:(NSString *) urlStr withJSON:(NSMutableDictionary *)params;
@end
