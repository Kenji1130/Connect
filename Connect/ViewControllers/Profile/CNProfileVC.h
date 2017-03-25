//
//  CNProfileVC.h
//  Connect
//
//  Created by mac on 3/24/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNProfileVC : UIViewController

@property (nonatomic, strong) CNUser *user;
@property (nonatomic, assign) CNProfileType profileType;
@end
