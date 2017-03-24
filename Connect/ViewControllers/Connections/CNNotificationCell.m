//
//  CNNotificationCell.m
//  Connect
//
//  Created by mac on 3/22/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNNotificationCell.h"

@implementation CNNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.btnReject.layer.borderWidth = 1;
    self.btnReject.layer.borderColor = kAppTintColor.CGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.btnConnect addTarget:self action:@selector(onConnectClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnReject addTarget:self action:@selector(onRejectClicked:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithNotification:(CNNotification *)notification {
    // Configure cell
    self.notification = notification;
    
    if (notification.imageURL == nil) {
        self.profileImageView.backgroundColor = UIColorFromRGB(0xd1d1d1);
        self.profileImageView.image = [UIImage imageNamed:@"UIImageViewProfileIconPicture"];
        self.profileImageView.contentMode = UIViewContentModeCenter;
    } else {
        self.profileImageView.backgroundColor = [UIColor clearColor];
        [self.profileImageView setImageWithURL:[NSURL URLWithString:notification.imageURL] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    self.lbName.text = self.notification.fromName;
    
    if (notification.fromID != nil) {
        if (notification.notiType == CNNotificationTypeRequest) {
            self.lbNoti.text = @"requested to connect with you.";
        } else if (notification.notiType == CNNotificationTypeConfirm){
            self.lbNoti.text = @"connected with you.";
        } else if (notification.notiType == CNNotificationTypeReject){
            self.lbNoti.text = @"rejected your request.";
        }
        
        self.lbOtherName.hidden = YES;
    } else {
        
        self.lbOtherName.hidden = NO;
        self.lbOtherName.text = self.notification.toName;
        self.lbNoti.text = @"connected with";
    }
    
    
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithInteger: timeStamp];

    NSTimeInterval difference = [[NSDate dateWithTimeIntervalSince1970:[timeStampObj intValue]] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[notification.timeStamp intValue]]];
    
    self.lbTime.text = [[CNUtilities shared] stringFromTimeInterval:difference];
    
    if (notification.notiType != CNNotificationTypeRequest) {
        self.btnConnect.hidden = true;
        self.btnReject.hidden = true;
    } else {
        self.btnConnect.hidden = false;
        self.btnReject.hidden = false;
    }
}

- (IBAction)onConnectClicked:(id)sender{
    
    NSString *title = @"Connection Accepted";
    NSString *body = [NSString stringWithFormat:@"%@ accepeted your connection request", self.notification.toName];
    [self sendNotification:title body:body type:CNNotificationTypeConfirm];
    [self saveNotification:CNNotificationTypeConfirm];
    [self saveConnection];
}

- (IBAction)onRejectClicked:(id)sender{
    
    NSString *title = @"Connection Rejected";
    NSString *body = [NSString stringWithFormat:@"%@ rejected your request", self.notification.toName];
    [self sendNotification:title body:body type:CNNotificationTypeReject];
    [self removeNotification];
    
}

- (void) sendNotification:(NSString*)title body:(NSString*) body type:(CNNotificationType) type{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.notification.token forKey:@"to"];
    NSDictionary *notification = [NSDictionary dictionaryWithObjectsAndKeys:
                                  title, @"title",
                                  body, @"body",
                                  nil];
    [params setObject:notification forKey:@"notification"];
    NSDictionary *data = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [params setObject:data forKey:@"data"];
    [[CNUtilities shared] httpJsonRequest:kFCMUrl withJSON:params];
}

- (void) saveNotification: (CNNotificationType) type{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:self.notification.toName forKey:@"fromName"];
    [param setObject:self.notification.fromName forKey:@"toName"];
    [param setObject:[CNUser currentUser].imageURL forKey:@"imageURL"];
    [param setObject:[NSNumber numberWithInteger:type] forKey:@"notiType"];
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithInteger: timeStamp];
    [param setObject:timeStampObj forKey:@"timeStamp"];
    [param setObject:[CNUser currentUser].token forKey:@"token"];
    
    self.notiRef = [[[[AppDelegate sharedInstance].dbRef child:@"notifications"] child:self.notification.fromID] child:[CNUser currentUser].userID];
    [self.notiRef setValue:param];

    [self updateNotification:type];
    
}


- (void) updateNotification: (CNNotificationType) type{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithInteger: timeStamp];
    [param setObject:timeStampObj forKey:@"timeStamp"];
    
    [param setObject:[NSNumber numberWithInteger:type] forKey:@"notiType"];

    self.notiUpdateRef = [[[[AppDelegate sharedInstance].dbRef child:@"notifications"] child:[CNUser currentUser].userID] child:self.notification.fromID];
    [self.notiUpdateRef updateChildValues:param];
}

- (void) removeNotification{
    self.notiUpdateRef = [[[[AppDelegate sharedInstance].dbRef child:@"notifications"] child:[CNUser currentUser].userID] child:self.notification.fromID];
    [self.notiUpdateRef removeValue];
}

- (void) saveConnection{
    self.connectRef = [[AppDelegate sharedInstance].dbRef child:@"connections"];
    [[[self.connectRef child:self.notification.fromID] child:self.notification.toID] setValue:[NSNumber numberWithInt:1]];
    [[[self.connectRef child:self.notification.toID] child:self.notification.fromID] setValue:[NSNumber numberWithInt:1]];
}

@end
