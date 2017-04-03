//
//  Constants.h
//  Connect
//
//  Created by Daniel on 10/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

/*!
 * @typedef CNProfileType
 * @brief A list of profile types.
 */
typedef NS_ENUM(NSUInteger, CNProfileType) {
    /// Personal Profile.
    CNProfileTypePersonal = 0,
    /// Business Profile.
    CNProfileTypeBusiness,
    /// Both
    CNProfileTypeBoth
};

typedef NS_ENUM(NSUInteger, CNUserGender){
    // Male
    CNUserMale = 0,
    // Female
    CNUserFemalle,
    // Other
    CNUserOther
};

typedef NS_ENUM(NSUInteger, CNSignType) {
    /// Email Sign
    CNSignTypeEmail = 0,
    /// Phone Sign
    CNSignTypePhone 
};

typedef NS_ENUM(NSUInteger, CNNotificationType) {
    // Request
    CNNotificationTypeRequest = 0,
    // Confirm
    CNNotificationTypeConfirm,
    // Reject
    CNNotificationTypeReject
};

typedef NS_ENUM(NSUInteger, CNSocialType) {
    // Facebook
    CNSocialTypeFacebook = 0,
    // Twitter
    CNSocialTypeTwitter,
    // Instagram
    CNSocialTypeInstagram,
    // LinkedIn
    CNSocialTypeLinkedIn
};

#define TRANSITION_DURATION 0.5

#define kSocialImage  [NSArray arrayWithObjects: @"UIImageViewProfileFacebook",@"UIImageViewProfileTwitter", @"UIImageViewProfileInstagram", @"UIImageViewProfileLinkedIn",@"UIImageViewProfileSnapchat", @"UIImageViewProfileVine",@"UIImageViewProfilePhone",@"UIImageViewProfileSkype",nil]
#define kSocialKey [NSArray arrayWithObjects: @"facebook",@"twitter", @"instagram", @"linkedIn",@"snapchat", @"vine", @"phone", @"skype", nil]


// Log In
#define kLoggedUserID   @"LoggedUserID"
#define kToken          @"token"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define UIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/// App Colors
#define kAppTintColor           UIColorFromRGB(0xff5252)
#define kAppBackgroundColor     UIColorFromRGB(0xf4f4f4)
#define kAppTextColor           UIColorFromRGB(0x2d3941)


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define kTwitterSecretKey   @"7J9E7XKKJrQMbQZLFRyQ9NmrxUy0SuA543ppAuCTF3kVa2ZaWg"
#define kTwitterCustomerKey @"sdS7fwETVs99cS9QvWpaxKQyI"

#define kInstagramClientID  @"1dd5bf86971e48a19471481e2ff5c72a"

#define kLinkedInClientID   @"86h1p8kv63h3r8"
#define kLinkedInClientSecret @"O8kHS33AjF1paVG5"
#define kLinkedInRedirectURL  @"https://www.linkedin.com/"

/// Firebase Info
#define kFCMUrl             @"https://fcm.googleapis.com/fcm/send"
#define kAutherization      @"key=AAAA-GzmNAU:APA91bGzRayHYs-MJm5TqmbZZWZ04lVuP8lPBsiOyRJ3icbJy_iCeuCN-0BCuPZLUVFHlIBA-itRIiNbBJr8n4stOVctppdWEbJapfmfZqFeJhU-xfZVwxbg4Q1WKPk6iTrgI0hwyDih"

#endif /* Constants_h */
