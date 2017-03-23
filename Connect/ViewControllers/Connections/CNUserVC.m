//
//  CNUserVC.m
//  Connect
//
//  Created by mac on 3/21/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNUserVC.h"
#import "CNSwitchView.h"
#import "CNNotification.h"

@interface CNUserVC () <CNUtilitiesDelegate>
@property (weak, nonatomic) IBOutlet UIView *switchView;
@property (weak, nonatomic) IBOutlet UIImageView *ivProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbOccupation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConnectHeightAnchor;

@property (strong, nonatomic) CNSwitchView *profileSwitch;
@property (strong, nonatomic) FIRDatabaseReference *notiRef;
@property (strong, nonatomic) FIRDatabaseReference *connectRef;


@end

@implementation CNUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configLayout];
    [self isConnected];
}

- (void) configLayout{
    [self configSwitchView];
    
    if (_user.profileImageURL == nil) {
        self.ivProfileImage.backgroundColor = UIColorFromRGB(0xd1d1d1);
        self.ivProfileImage.image = [UIImage imageNamed:@"UIImageViewProfileIconPicture"];
        self.ivProfileImage.contentMode = UIViewContentModeCenter;
    } else {
        self.ivProfileImage.backgroundColor = [UIColor clearColor];
        [self.ivProfileImage setImageWithURL:_user.profileImageURL placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.ivProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    _lbName.text = [NSString stringWithFormat:@"%@ %@", _user.firstName, _user.lastName];
    _lbOccupation.text = _user.occupation;
    
//    if ([self isConnected]) {
//        self.btnConnectHeightAnchor.constant = 0;
//    } else {
//        self.btnConnectHeightAnchor.constant = 40;
//    }
}

- (void) configSwitchView{
    self.switchView.clipsToBounds = YES;
    self.profileSwitch = [[CNSwitchView alloc] initWithType:CNSwitchTypeProfile];
    self.profileSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.profileSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.switchView addSubview:self.profileSwitch];
    
    self.profileSwitch.layer.shadowOffset = CGSizeMake(0, 0);
    self.profileSwitch.layer.shadowRadius = 4;
    self.profileSwitch.layer.shadowOpacity = 0.1;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_profileSwitch);
    [self.switchView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-70-[_profileSwitch]-70-|" options:0 metrics:nil views:views]];
    [self.switchView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[_profileSwitch(40)]" options:0 metrics:nil views:views]];
}

- (void)switchValueChanged:(id)sender {
    CNSwitchView *cnSwitch = (CNSwitchView *)sender;
    if (cnSwitch.isOn) {
        NSLog(@"Switch On");
        self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
        self.lbName.textColor = kAppTextColor;
        self.lbOccupation.textColor = kAppTextColor;
    } else {
        NSLog(@"Switch Off");
        self.view.backgroundColor = UIColorFromRGB(0x9a9a9b);
        self.lbName.textColor = [UIColor whiteColor];
        self.lbOccupation.textColor = [UIColor whiteColor];
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


#pragma mark - Connection check
- (BOOL) isConnected{
    __block BOOL connected = false;
    
    self.connectRef = [[[[AppDelegate sharedInstance].dbRef child:@"connections"] child:[CNUser currentUser].userID] child:_user.userID];
    
    [self.connectRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (![snapshot.value isEqual:[NSNull null]]) {
            connected = true;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.btnConnectHeightAnchor.constant = 0;
            });
        } else{
            connected = false;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.btnConnectHeightAnchor.constant = 46;
            });
        }
    }];
    
    return connected;
    
}

- (IBAction)sendConnectionRequest:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:_user.token forKey:@"to"];
    NSDictionary *notification = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"Connection Request", @"title",
                                  [NSString stringWithFormat:@"%@ %@ requested to connet with you", _user.firstName, _user.lastName], @"body",
                                  nil];
    [params setObject:notification forKey:@"notification"];
    NSDictionary *data = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:CNNotificationTypeRequest] forKey:@"type"];
    [params setObject:data forKey:@"data"];
    [[CNUtilities shared] httpJsonRequest:kFCMUrl withJSON:params];
    [CNUtilities shared].delegate = self;
    [self saveNotification];
}

- (void) saveNotification{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%@ %@",[CNUser currentUser].firstName, [CNUser currentUser].lastName] forKey:@"fromName"];
    [param setObject:[CNUser currentUser].userID forKey:@"fromID"];
    [param setObject:[NSString stringWithFormat:@"%@ %@", _user.firstName, _user.lastName] forKey:@"toName"];
    [param setObject:_user.userID forKey:@"toID"];
    [param setObject:[CNUser currentUser].imageURL forKey:@"imageURL"];
    [param setObject:[NSNumber numberWithInteger:CNNotificationTypeRequest] forKey:@"notiType"];
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithInteger: timeStamp];
    [param setObject:timeStampObj forKey:@"timeStamp"];
    [param setObject:[CNUser currentUser].token forKey:@"token"];
    
    self.notiRef = [[[[AppDelegate sharedInstance].dbRef child:@"notifications"] child:_user.userID] childByAutoId];
    [self.notiRef setValue:param];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CNUtilitiesDelegate
- (void) onSuccess{
    NSLog(@"Success");
    
}

- (void) onFailed{
    NSLog(@"Failed");
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
