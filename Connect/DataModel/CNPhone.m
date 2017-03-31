//
//  CNPhone.m
//  Connect
//
//  Created by mac on 3/30/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNPhone.h"

@implementation CNPhone

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
        [self configurePhoneWithDictionary:value];
    }
    
    return self;
}

- (void)configurePhoneWithDictionary:(NSDictionary *)value {
    // Configure user with dictionary
    self.name = value[@"name"];
    self.hidden = [value[@"hidden"] boolValue];
    self.active = [value[@"active"] boolValue];
}

@end
