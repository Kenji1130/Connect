//
//  CNScanViewController.m
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNScanViewController.h"
#import "CNMatchViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZFConst.h"
#import "ZFMaskView.h"

@interface CNScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) NSMutableArray * metadataObjectTypes;
@property (nonatomic, strong) ZFMaskView * maskView;
@property (strong, nonatomic) FIRDatabaseReference *userRef;
@property (strong, nonatomic) FIRDatabaseReference *connectRef;

@property (strong, nonatomic) CNUser *user;
@end

@implementation CNScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self capture];
    [self addUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.session.isRunning) {
        [self.session startRunning];
    }
}
    
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.maskView removeAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)metadataObjectTypes{
    if (!_metadataObjectTypes) {
        _metadataObjectTypes = [NSMutableArray arrayWithObjects:AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode, nil];
        
        // >= iOS 8
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            [_metadataObjectTypes addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode]];
        }
    }
    
    return _metadataObjectTypes;
}

#pragma mark - Helpers

- (void)addUI {

    self.maskView = [[ZFMaskView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kBottomBarHeight)];
    [self.view addSubview:self.maskView];
}

- (void)capture {
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc] init];
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    [self.session addInput:input];
    [self.session addOutput:output];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kBottomBarHeight);
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    output.metadataObjectTypes = self.metadataObjectTypes;
    
    [self.session startRunning];
}

- (void)showMatchScreen: (CNUser*) user {
    CNMatchViewController *vc = (CNMatchViewController *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNMatchViewController class])];
    vc.user = user;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)getFriendInfo: (NSString*) scanedBarcode{
    NSArray *listItems = [scanedBarcode componentsSeparatedByString:@" - "];
    NSString *userID = [listItems objectAtIndex:0];
    NSLog(@"userID: %@", userID);
    
    if ([[CNUtilities shared] valideCharacter:userID]) {
        [self showAlert:self withTitle:@"Error" withMessage:@"Sorry, this user is not registered"];
    } else {
        self.userRef = [[[AppDelegate sharedInstance].dbRef child:@"users"] child:userID];
        [self.userRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            if (![snapshot.value isEqual:[NSNull null]]) {
                NSLog(@"%@", snapshot.value);
                NSDictionary *dict = snapshot.value;
                self.user = [[CNUser alloc] initWithDictionary:dict];
                [self connectToFriend];
            } else {
                [self showAlert:self withTitle:@"Error" withMessage:@"Sorry, this user is not registered"];

            }
        }];
    }

}

- (void) connectToFriend{
    self.connectRef = [[[[AppDelegate sharedInstance].dbRef child:@"connections"] child:[CNUser currentUser].userID] child:self.user.userID];
    [self.connectRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if ([snapshot.value isEqual:[NSNull null]]) {
            [self showMatchScreen:self.user];
        } else {
            [self showAlert:self withTitle:@"Error" withMessage:@"You are already connected."];
        }
        
//        [self showMatchScreen:self.user];
    }];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
        NSLog(@"%@", metadataObject.stringValue);
        
        [self getFriendInfo:metadataObject.stringValue];
    }
}

- (void)showAlert:(UIViewController*) vc withTitle:(NSString *)title withMessage:(NSString *)message {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                                   [self.session startRunning];
                               }];
    [alert addAction:okButton];
    [vc presentViewController:alert animated:YES completion:nil];
    
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
