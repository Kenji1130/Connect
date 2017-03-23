//
//  CNNotification.h
//  Connect
//
//  Created by mac on 3/22/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNNotification : NSObject

@property (nonatomic, strong) NSString *notiID;
@property (nonatomic, assign) CNNotificationType notiType;
@property (nonatomic, strong) NSString *fromName;
@property (nonatomic, strong) NSString *fromID;
@property (nonatomic, strong) NSString *toName;
@property (nonatomic, strong) NSString *toID;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSNumber *timeStamp;
@property (nonatomic, strong) NSString* token;

- (instancetype)initWithDictionary:(NSDictionary *)value;
- (void)configureUserWithDictionary:(NSDictionary *)value;
- (NSURL *)profileImageURL;
- (NSComparisonResult)compare:(CNNotification *)otherObject;
@end
