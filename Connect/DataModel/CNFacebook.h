//
//  CNFacebook.h
//  Connect
//
//  Created by mac on 3/28/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNFacebook : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, assign) BOOL active;

@property (nonatomic, assign) BOOL fromSocial;

+ (instancetype)sharedInstance;

- (instancetype)initWithDictionary:(NSDictionary *)value fromSocial: (BOOL)social;
- (void)configureFacebookWithDictionary:(NSDictionary *)value;

@end
