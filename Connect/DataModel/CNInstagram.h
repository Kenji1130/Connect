//
//  CNInstagram.h
//  Connect
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNInstagram : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, assign) BOOL active;

@property (nonatomic, assign) BOOL fromSocial;

+ (instancetype)sharedInstance;

- (instancetype)initWithDictionary:(NSDictionary *)value fromSocial:(BOOL)social;
- (void)configureInstagramWithDictionary:(NSDictionary *)value;
@end
