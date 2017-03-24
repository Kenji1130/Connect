//
//  CNNotification.m
//  Connect
//
//  Created by mac on 3/22/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNNotification.h"

@implementation CNNotification

- (instancetype)initWithDictionary:(NSDictionary *)value {
    self = [super init];
    if (self) {
        [self configureUserWithDictionary:value];
    }
    
    return self;
}

- (void)configureUserWithDictionary:(NSDictionary *)value {
    // Configure user with dictionary
    self.notiType = [value[@"notiType"] intValue];
    self.fromName = value[@"fromName"];
    self.fromID = value[@"fromID"];
    self.toName = value[@"toName"];
    self.toID = value[@"toID"];
    self.imageURL = value[@"imageURL"];
    self.timeStamp = value[@"timeStamp"];
    self.token = value[@"token"];
}

#pragma mark - Profile Image

- (NSURL *)profileImageURL {
    if (self.imageURL != nil) {
        return [NSURL URLWithString:self.imageURL];
    }
    
    return nil;
}

- (NSComparisonResult)compare:(CNNotification *)otherObject {
    return [otherObject.timeStamp compare:self.timeStamp];
}
@end
