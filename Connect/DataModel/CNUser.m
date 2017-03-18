//
//  CNUser.m
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNUser.h"

@implementation CNUser

+ (instancetype)currentUser {
    static dispatch_once_t once;
    static id currentUser;
    dispatch_once(&once, ^{
        currentUser = [[[self class] alloc] init];});
    return currentUser;
}

- (instancetype)initWithDictionary:(NSDictionary *)value {
    self = [super init];
    if (self) {
        [self configureUserWithDictionary:value];
    }
    
    return self;
}

- (void)configureUserWithDictionary:(NSDictionary *)value {
    // Configure user with dictionary
    self.userID = value[@"userID"];
    self.email = value[@"email"];
    self.password = value[@"password"];
    self.username = value[@"username"];
    self.firstName = value[@"firstName"];
    self.lastName = value[@"lastName"];
    self.age = value[@"age"];
    self.occupation = value[@"occupation"];
    self.phoneNumber = value[@"phoneNumber"];
    self.imageURL = value[@"imageURL"];
    self.profileType = [value[@"profileType"] intValue];
    self.gender = [value[@"gender"] intValue];
    self.signType = [value[@"signType"] intValue];
}

#pragma mark -

- (BOOL)isMe {
    NSString *loggedUserID = [[NSUserDefaults standardUserDefaults] objectForKey:kLoggedUserID];
    if (loggedUserID == nil)
        return NO;
    
    return [self.userID isEqualToString:loggedUserID];
}

- (NSString *)name {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

#pragma mark - Profile Image

- (NSURL *)profileImageURL {
    if (self.imageURL != nil) {
        return [NSURL URLWithString:self.imageURL];
    }
    
    return nil;
}

- (void)setProfileImage:(UIImage*)image withBlock:(void (^)(BOOL success))block {
    
}


@end
