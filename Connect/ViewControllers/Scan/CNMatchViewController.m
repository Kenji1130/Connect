//
//  CNMatchViewController.m
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNMatchViewController.h"
#import "SGQRCodeTool.h"
#import "CNUserVC.h"

@interface CNMatchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myProfileImage;
@property (weak, nonatomic) IBOutlet UIImageView *friendProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (strong, nonatomic) FIRDatabaseReference *notiRef;
@property (strong, nonatomic) FIRDatabaseReference *connectRef;

@end

@implementation CNMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configLayout];
    
    [self saveNotification:CNNotificationTypeConfirm];
    [self saveConnection];
}

- (void)configLayout{
    self.lbName.text = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
    
    if ([CNUser currentUser].profileImageURL == nil) {
        self.myProfileImage.backgroundColor = UIColorFromRGB(0xd1d1d1);
        self.myProfileImage.image = [UIImage imageNamed:@"UIImageViewProfileIconPicture"];
        self.myProfileImage.contentMode = UIViewContentModeCenter;
    } else {
        self.myProfileImage.backgroundColor = [UIColor clearColor];
        [self.myProfileImage setImageWithURL:[CNUser currentUser].profileImageURL placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.myProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    if (self.user.profileImageURL == nil) {
        self.friendProfileImage.backgroundColor = UIColorFromRGB(0xd1d1d1);
        self.friendProfileImage.image = [UIImage imageNamed:@"UIImageViewProfileIconPicture"];
        self.friendProfileImage.contentMode = UIViewContentModeCenter;
    } else {
        self.friendProfileImage.backgroundColor = [UIColor clearColor];
        [self.friendProfileImage setImageWithURL:self.user.profileImageURL placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.friendProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRescan:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onViewProfile:(id)sender {
    CNUserVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNUserVC class])];
    vc.user = self.user;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) saveNotification: (CNNotificationType) type{
    self.notiRef = [[AppDelegate sharedInstance].dbRef child:@"notifications"];
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithInteger: timeStamp];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%@ %@",[CNUser currentUser].firstName, [CNUser currentUser].lastName] forKey:@"fromName"];
    [param setObject:[CNUser currentUser].userID forKey:@"fromID"];
    [param setObject:[NSString stringWithFormat:@"%@ %@",self.user.firstName, self.user.lastName] forKey:@"toName"];
    [param setObject:self.user.userID forKey:@"toID"];
    [param setObject:[CNUser currentUser].imageURL forKey:@"imageURL"];
    [param setObject:[NSNumber numberWithInteger:type] forKey:@"notiType"];
    [param setObject:timeStampObj forKey:@"timeStamp"];
    [param setObject:[CNUser currentUser].token forKey:@"token"];
    
    [[[self.notiRef child:self.user.userID] childByAutoId] setValue:param];
    
    NSMutableDictionary *param1 = [[NSMutableDictionary alloc] init];
    [param1 setObject:[NSString stringWithFormat:@"%@ %@",self.user.firstName, self.user.lastName] forKey:@"fromName"];
    [param1 setObject:self.user.userID forKey:@"fromID"];
    [param1 setObject:[NSString stringWithFormat:@"%@ %@",[CNUser currentUser].firstName, [CNUser currentUser].lastName] forKey:@"toName"];
    [param1 setObject:[CNUser currentUser].userID forKey:@"toID"];
    [param1 setObject:self.user.imageURL forKey:@"imageURL"];
    [param1 setObject:[NSNumber numberWithInteger:type] forKey:@"notiType"];
    [param1 setObject:timeStampObj forKey:@"timeStamp"];
    [param1 setObject:self.user.token forKey:@"token"];
    
    [[[self.notiRef child:[CNUser currentUser].userID] childByAutoId] setValue:param1];
    
}


- (void) saveConnection{
    self.connectRef = [[AppDelegate sharedInstance].dbRef child:@"connections"];
    [[[self.connectRef child:self.user.userID] child:[CNUser currentUser].userID] setValue:[NSNumber numberWithInt:1]];
    [[[self.connectRef child:[CNUser currentUser].userID] child:self.user.userID] setValue:[NSNumber numberWithInt:1]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
