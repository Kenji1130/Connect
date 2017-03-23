//
//  CNNotificationCell.h
//  Connect
//
//  Created by mac on 3/22/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNNotification.h"

@interface CNNotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbNoti;
@property (weak, nonatomic) IBOutlet UIButton *btnConnect;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;

@property (nonatomic, strong) CNNotification *notification;
@property (strong, nonatomic) FIRDatabaseReference *notiRef;
@property (strong, nonatomic) FIRDatabaseReference *notiRemoveRef;


- (void)configureCellWithNotification:(CNNotification *) notification;

@end
