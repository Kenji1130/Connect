//
//  CNSwitchView.h
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * @typedef CNSwitchType
 * @brief A list of switch types.
 */
typedef NS_ENUM(NSUInteger, CNSwitchType) {
    /// Connections.
    CNSwitchTypeConnections,
    /// Profile.
    CNSwitchTypeProfile,
    /// Notification
    CNSwitchTypeNotification
};

@interface CNSwitchView : UIControl <UIGestureRecognizerDelegate>

- (id)initWithType:(CNSwitchType)switchType;

/* Switch Type */
@property (nonatomic, assign) CNSwitchType switchType;

/* A Boolean value that determines the off/on state of the switch. */
@property (nonatomic, getter = isOn) BOOL on;

/* The color used to tint the appearance of the thumb. */
@property (nonatomic, strong) UIColor *thumbTintColor;

/* Thumb drop shadow on/off */
@property (nonatomic, assign) BOOL shadow;

@end
