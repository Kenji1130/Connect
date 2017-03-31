//
//  CNTwitter.h
//  Connect
//
//  Created by mac on 3/28/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNTwitter : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, assign) BOOL active;


+ (instancetype)sharedInstance;

- (instancetype)initWithDictionary:(NSDictionary *)value;
- (instancetype)initWithDictionary:(NSDictionary *)value fromTwitter:(BOOL) twitter;
- (void)configureTwitterWithDictionary:(NSDictionary *)value;
- (void)configureTwitterWithDictionary:(NSDictionary *)value fromTwitter:(BOOL) twitter;
@end
