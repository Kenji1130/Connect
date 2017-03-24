//
//  CNQRCodeViewController.m
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNQRCodeViewController.h"
#import "CNSwitchView.h"
#import "SGQRCodeTool.h"

@interface CNQRCodeViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewCodeContainer;
@property (weak, nonatomic) IBOutlet UIImageView *ivCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constOfCodeContainerTop;

@property (weak, nonatomic) IBOutlet UIView *viewSwitchContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) CNSwitchView *profileSwitch;
@property (assign, nonatomic) CNProfileType profileType;

@end

@implementation CNQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureLayout];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

- (void)configureLayout {
    // Configure layout
    self.viewCodeContainer.layer.masksToBounds = NO;
    self.viewCodeContainer.layer.cornerRadius = 6;
    self.viewCodeContainer.layer.shadowOffset = CGSizeMake(0, 0);
    self.viewCodeContainer.layer.shadowRadius = 4;
    self.viewCodeContainer.layer.shadowOpacity = 0.1;
    
    // Configure switch view
    self.profileSwitch = [[CNSwitchView alloc] initWithType:CNSwitchTypeProfile];
    self.profileSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.profileSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.viewSwitchContainer addSubview:self.profileSwitch];
    
    self.profileSwitch.layer.shadowOffset = CGSizeMake(0, 0);
    self.profileSwitch.layer.shadowRadius = 4;
    self.profileSwitch.layer.shadowOpacity = 0.1;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_profileSwitch);
    [self.viewSwitchContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_profileSwitch]|" options:0 metrics:nil views:views]];
    [self.viewSwitchContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_profileSwitch]|" options:0 metrics:nil views:views]];
    
    self.profileType = CNProfileTypePersonal;
    self.lblName.text = [CNUser currentUser].name;
    self.ivCode.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:[NSString stringWithFormat:@"%@ - %lu", [CNUser currentUser].userID, (unsigned long)self.profileType]
                                                         imageViewWidth:(SCREEN_WIDTH - 70)];
    
}

- (void)switchValueChanged:(id)sender {
    // Update QRCode according to profile type
    CNSwitchView *cnSwitch = (CNSwitchView *)sender;
    self.profileType = cnSwitch.on ? CNProfileTypePersonal : CNProfileTypeBusiness;
    self.ivCode.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:[NSString stringWithFormat:@"%@ - %lu", [CNUser currentUser].userID, (unsigned long)self.profileType]
                                                        imageViewWidth:(SCREEN_WIDTH - 70)];
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
