//
//  CNUserVC.m
//  Connect
//
//  Created by mac on 3/21/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNUserVC.h"
#import "CNSwitchView.h"

@interface CNUserVC ()
@property (weak, nonatomic) IBOutlet UIView *switchView;
@property (weak, nonatomic) IBOutlet UIImageView *ivProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbOccupation;

@property (strong, nonatomic) CNSwitchView *profileSwitch;

@end

@implementation CNUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configLayout];
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

- (IBAction)sendConnectionRequest:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    {
//        "to" : "APA91bHun4MxP5egoKMwt2KZFBaFUH-1RYqx...",
//        "notification" : {
//            "body" : "great match!",
//            "title" : "Portugal vs. Denmark",
//            "icon" : "myicon"
//        },
//        "data" : {
//            "Nick" : "Mario",
//            "Room" : "PortugalVSDenmark"
//        }
//    }
   
    [params setObject:_user.token forKey:@"to"];
    NSDictionary *notification = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"Connection Request", @"title",
                                  [NSString stringWithFormat:@"%@ %@ required connetion with you", _user.firstName, _user.lastName], @"body",
                                  nil];
    [params setObject:notification forKey:@"notification"];
    NSDictionary *data = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:1] forKey:@"type"];
    [params setObject:data forKey:@"data"];
    [[CNUtilities shared] httpJsonRequest:kFCMUrl withJSON:params];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
