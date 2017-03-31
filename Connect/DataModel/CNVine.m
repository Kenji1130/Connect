//
//  CNVine.m
//  Connect
//
//  Created by mac on 3/30/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNVine.h"

@implementation CNVine

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
        [self configureVineWithDictionary:value];
    }
    
    return self;
}

- (void)configureVineWithDictionary:(NSDictionary *)value {
    // Configure user with dictionary
    self.name = value[@"name"];
    self.hidden = [value[@"hidden"] boolValue];
    self.active = [value[@"active"] boolValue];
}
@end
