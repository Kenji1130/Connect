//
//  CNUserVC.h
//  Connect
//
//  Created by mac on 3/21/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNUserVC : UIViewController

@property (strong, nonatomic) CNUser *user;
@property (assign, nonatomic) CNProfileType profileType;

@end
