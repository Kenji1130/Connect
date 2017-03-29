//
//  CNFacebook.m
//  Connect
//
//  Created by mac on 3/28/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNFacebook.h"

@implementation CNFacebook

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[[self class] alloc] init];});
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)value {
    self = [super init];
    if (self) {
        [self configureFacebookWithDictionary:value];
    }
    
    return self;
}

- (void)configureFacebookWithDictionary:(NSDictionary *)value {
    // Configure user with dictionary
    self.name = value[@"name"];
    self.hidden = value[@"hidden"];
}


@end
