//
//  CNProfileAddMediaCell.h
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CNProfileAddMediaCellDelegate <NSObject>

@optional
- (void)didAddMediaTapped;

@end

@interface CNProfileAddMediaCell : UITableViewCell

@property (weak, nonatomic) id<CNProfileAddMediaCellDelegate> delegate;

@end
