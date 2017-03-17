//
//  CNMatchViewController.m
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNMatchViewController.h"
#import "SGQRCodeTool.h"

@interface CNMatchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ivCode;
@property (weak, nonatomic) IBOutlet UILabel *bacodeInfo;

@end

@implementation CNMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)configLayout{
    self.ivCode.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:[NSString stringWithFormat:@"%@", self.scanedBarcode] imageViewWidth:(SCREEN_WIDTH - 70)];
    self.bacodeInfo.text = _scanedBarcode;
}
   
#pragma mark - IBActions
    
- (IBAction)onBackBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
