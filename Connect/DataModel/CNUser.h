//
//  CNUser.h
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNFacebook.h"
#import "CNTwitter.h"
#import "CNInstagram.h"
#import "CNLinkedIn.h"
#import "CNSnapchat.h"
#import "CNVine.h"
#import "CNPhone.h"
#import "CNSkype.h"

@interface CNUser : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSString *occupation;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, assign) CNProfileType profileType;
@property (nonatomic, assign) CNUserGender gender;
@property (nonatomic, assign) CNSignType signType;
@property (nonatomic, strong) NSMutableArray *connectionId;
@property (nonatomic, assign) BOOL profileHidden;
@property (nonatomic, strong) NSNumber *notiCount;

@property (nonatomic, strong) NSDictionary *social;

@property (nonatomic, strong) NSDictionary *socialPersonal;
@property (nonatomic, strong) CNFacebook *pFacebook;
@property (nonatomic, strong) CNTwitter *pTwitter;
@property (nonatomic, strong) CNInstagram *pInstagram;
@property (nonatomic, strong) CNLinkedIn *pLinkedIn;
@property (nonatomic, strong) CNSnapchat *pSnapchat;
@property (nonatomic, strong) CNVine    *pVine;
@property (nonatomic, strong) CNPhone  *pPhone;
@property (nonatomic, strong) CNSkype  *pSkype;

@property (nonatomic, strong) NSDictionary *socialBusiness;
@property (nonatomic, strong) CNFacebook *bFacebook;
@property (nonatomic, strong) CNTwitter *bTwitter;
@property (nonatomic, strong) CNInstagram *bInstagram;
@property (nonatomic, strong) CNLinkedIn *bLinkedIn;
@property (nonatomic, strong) CNSnapchat *bSnapchat;
@property (nonatomic, strong) CNVine    *bVine;
@property (nonatomic, strong) CNPhone  *bPhone;
@property (nonatomic, strong) CNSkype  *bSkype;

@property (nonatomic, readonly) BOOL isMe;
@property (nonatomic, readonly) NSString *name;
    
+ (instancetype)currentUser;

- (instancetype)initWithDictionary:(NSDictionary *)value;
- (void)configureUserWithDictionary:(NSDictionary *)value;

- (NSURL *)profileImageURL;
- (void)setProfileImage:(UIImage*)image withBlock:(void (^)(BOOL success))block;

@end
