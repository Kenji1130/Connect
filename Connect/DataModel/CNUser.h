//
//  CNUser.h
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNUser : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *occupation;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, assign) CNProfileType profileType;

@property (nonatomic, readonly) BOOL isMe;
@property (nonatomic, readonly) NSString *name;

+ (instancetype)currentUser;

- (instancetype)initWithDictionary:(NSDictionary *)value;
- (void)configureUserWithDictionary:(NSDictionary *)value;

- (NSURL *)profileImageURL;
- (void)setProfileImage:(UIImage*)image withBlock:(void (^)(BOOL success))block;

@end
