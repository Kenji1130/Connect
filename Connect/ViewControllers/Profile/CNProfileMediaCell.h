//
//  CNProfileMediaCell.h
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CNProfileMediaCellDelegate <NSObject>

@optional
- (void)didMediaRemovedAtIndex:(NSInteger)index;

@end

@interface CNProfileMediaCell : UITableViewCell

@property (weak, nonatomic) id<CNProfileMediaCellDelegate> delegate;

- (void)configureCellWithIndex:(NSInteger)index withType:(CNProfileType)profileType isEdit:(BOOL)isEdit isCurrent:(BOOL)isCurrent;

@end
