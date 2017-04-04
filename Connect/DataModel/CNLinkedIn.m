//
//  CNLinkedIn.m
//  Connect
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNLinkedIn.h"

@implementation CNLinkedIn

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[[self class] alloc] init];});
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)value fromSocial:(BOOL)social {
    self = [super init];
    if (self) {
        self.fromSocial = social;
        [self configureLinkedInWithDictionary:value];
    }
    
    return self;
}

- (void)configureLinkedInWithDictionary:(NSDictionary *)value {
    // Configure user with dictionary
    if(self.fromSocial){
        self.name = value[@"name"];
        self.hidden = false;
        self.active = true;
    } else{
        self.name = value[@"name"];
        self.hidden = [value[@"hidden"] boolValue];
        self.active = [value[@"active"] boolValue];
    }

}

@end
