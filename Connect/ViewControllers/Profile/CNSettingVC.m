//
//  CNSettingVC.m
//  Connect
//
//  Created by mac on 3/24/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNSettingVC.h"

@interface CNSettingVC ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation CNSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configLayout];
}

- (void)configLayout{
    
    if ([CNUser currentUser].profileImageURL == nil) {
        self.profileImage.backgroundColor = UIColorFromRGB(0xd1d1d1);
        self.profileImage.image = [UIImage imageNamed:@"UIImageViewProfileIconPicture"];
        self.profileImage.contentMode = UIViewContentModeCenter;
    } else {
        self.profileImage.backgroundColor = [UIColor clearColor];
        [self.profileImage setImageWithURL:[CNUser currentUser].profileImageURL placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.profileImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    self.lbName.text = [NSString stringWithFormat:@"%@ %@", [CNUser currentUser].firstName, [CNUser currentUser].lastName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onLogOut:(id)sender {
    [[AppDelegate sharedInstance] logOut];
}


@end
