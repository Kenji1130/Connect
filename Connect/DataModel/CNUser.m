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
    self.token = value[@"token"];
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
    self.profileHidden = [value[@"profileHidden"] boolValue];
    self.notiCount = value[@"notiCount"];
    
    // Social
    NSDictionary *social = value[@"social"];
    self.social = social;
        
    // Personal Social
    NSDictionary *socialPersonal = social[@"personal"];
    self.socialPersonal = socialPersonal;
    
    NSDictionary *pFacebook = socialPersonal[@"facebook"];
    self.pFacebook = [[CNFacebook alloc] initWithDictionary:pFacebook fromSocial:NO];
    
    NSDictionary *pTwitter = socialPersonal[@"twitter"];
    self.pTwitter = [[CNTwitter alloc] initWithDictionary:pTwitter fromSocial:NO];
    
    NSDictionary *pInstagram = socialPersonal[@"instagram"];
    self.pInstagram = [[CNInstagram alloc] initWithDictionary:pInstagram fromSocial:NO];
    
    NSDictionary *pLinkedIn = socialPersonal[@"linkedIn"];
    self.pLinkedIn = [[CNLinkedIn alloc] initWithDictionary:pLinkedIn fromSocial:NO];
    
    NSDictionary *pSnapchat = socialPersonal[@"snapchat"];
    self.pSnapchat = [[CNSnapchat alloc] initWithDictionary:pSnapchat];
    
    NSDictionary *pVine = socialPersonal[@"vine"];
    self.pVine = [[CNVine alloc] initWithDictionary:pVine];
    
    NSDictionary *pPhone = socialPersonal[@"phone"];
    self.pPhone = [[CNPhone alloc] initWithDictionary:pPhone];
    
    NSDictionary *pSkype = socialPersonal[@"skype"];
    self.pSkype = [[CNSkype alloc] initWithDictionary:pSkype];
    
    // Business Social
    NSDictionary *socialBusiness = social[@"business"];
    self.socialBusiness = socialBusiness;
    
    NSDictionary *bFacebook = socialBusiness[@"facebook"];
    self.bFacebook = [[CNFacebook alloc] initWithDictionary:bFacebook fromSocial:NO];
    
    NSDictionary *bTwitter = socialBusiness[@"twitter"];
    self.bTwitter = [[CNTwitter alloc] initWithDictionary:bTwitter fromSocial:NO];
    
    NSDictionary *bInstagram = socialBusiness[@"instagram"];
    self.bInstagram = [[CNInstagram alloc] initWithDictionary:bInstagram fromSocial:NO];
    
    NSDictionary *bLinkedIn = socialBusiness[@"linkedIn"];
    self.bLinkedIn = [[CNLinkedIn alloc] initWithDictionary:bLinkedIn fromSocial:NO];
    
    NSDictionary *bSnapchat = socialBusiness[@"snapchat"];
    self.bSnapchat = [[CNSnapchat alloc] initWithDictionary:bSnapchat];
    
    NSDictionary *bVine = socialBusiness[@"vine"];
    self.bVine = [[CNVine alloc] initWithDictionary:bVine];
    
    NSDictionary *bPhone = socialBusiness[@"phone"];
    self.bPhone = [[CNPhone alloc] initWithDictionary:bPhone];
    
    NSDictionary *bSkype = socialBusiness[@"skype"];
    self.bSkype = [[CNSkype alloc] initWithDictionary:bSkype];
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
