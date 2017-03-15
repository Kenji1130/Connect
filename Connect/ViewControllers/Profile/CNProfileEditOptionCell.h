//
//  CNProfileEditOptionCell.h
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CNProfileEditOptionCellDelegate <NSObject>

@optional
- (void)didHideSwitchChanged:(BOOL)hide;

@end

@interface CNProfileEditOptionCell : UITableViewCell

@property (weak, nonatomic) id<CNProfileEditOptionCellDelegate> delegate;

@end
