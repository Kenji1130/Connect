//
//  CNUtilities.m
//  Connect
//
//  Created by Daniel on 30/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNUtilities.h"

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

@end
