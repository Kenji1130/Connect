//
//  CNUtilities.m
//  Connect
//
//  Created by Daniel on 30/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNUtilities.h"
#import <CommonCrypto/CommonDigest.h>
#import "JSON.h"


@implementation CNUtilities
+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}
    
- (void)showAlert:(UIViewController*) vc withTitle:(NSString *)title withMessage:(NSString *)message {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    [alert addAction:okButton];
    [vc presentViewController:alert animated:YES completion:nil];

}

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
    
- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
    
- (BOOL)validatePhone:(NSString *)phoneNumber {
    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:phoneNumber];
}

- (void) httpJsonRequest:(NSString *) urlStr withJSON:(NSMutableDictionary *)params {
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *body = [[SBJsonWriter new] stringWithObject:params];
    NSData *requestData = [body dataUsingEncoding:NSASCIIStringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:kAutherization forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: requestData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"respose: %@", response);
        NSLog(@"data: %@", data);
        
        if (error != nil) {
            NSLog(@"Error:%@", error);
            [self.delegate onFailed];
        } else {
            [self.delegate onSuccess];
        }

    }] resume];
    
}

- (NSString*) stringFromTimeInterval: (NSTimeInterval) interval{
    
    NSString *timeString;
    
    NSInteger time = round(interval);
    NSInteger second, minute, hour, day;
    second = time % 60;
    minute = (time / 60) % 60;
    hour = (time / 60 / 60) % 24;
    day = (time / 60 / 60 / 24) % 30;
    
    if (day > 0) {
        timeString = [NSString stringWithFormat:@"%ld day%@ ago", (long)day, day == 1 ? @"" : @"s"];
    } else {
        if (hour > 0) {
            timeString = [NSString stringWithFormat:@"%ld hour%@ ago", (long)hour, hour == 1 ? @"" : @"s"];
        } else {
            if (minute > 0) {
                timeString = [NSString stringWithFormat:@"%ld min%@ ago", (long)minute, minute == 1 ? @"" : @"s"];
            } else{
                timeString = [NSString stringWithFormat:@"%ld second%@ ago", (long)second, second == 1 ? @"" : @"s"];
            }
        }
    }
    
    return timeString;
}

- (BOOL)valideCharacter:(NSString*) string{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
    
    if ([string rangeOfCharacterFromSet:set].location != NSNotFound) {
        return YES;
    } else{
        return NO;
    }
}

- (void) saveLoggedUserID:(NSString*) userId{
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kLoggedUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) getLoggedUserID{
    NSString *loggedUserID = [[NSUserDefaults standardUserDefaults] objectForKey:kLoggedUserID];
    return loggedUserID;
}

- (void) saveToken:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) getToken{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kToken];
    return token;
}

@end
