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
    CNProfileTypeBusiness
};

// Log In
#define kLoggedUserID   @"LoggedUserID"

/// App Colors
#define kAppTintColor           UIColorFromRGB(0xff5252)
#define kAppBackgroundColor     UIColorFromRGB(0xf4f4f4)
#define kAppTextColor           UIColorFromRGB(0x2d3941)

#endif /* Constants_h */
