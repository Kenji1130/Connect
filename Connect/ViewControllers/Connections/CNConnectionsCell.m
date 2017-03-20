//
//  CNConnectionsCell.m
//  Connect
//
//  Created by Daniel on 30/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNConnectionsCell.h"

@interface CNConnectionsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ivProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblMarkPersonal;
@property (weak, nonatomic) IBOutlet UILabel *lblMarkBusiness;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constOfBusinessLeft;

@end

@implementation CNConnectionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    self.lblMarkPersonal.layer.borderWidth = 1;
    self.lblMarkPersonal.layer.borderColor = kAppTintColor.CGColor;
    self.lblMarkBusiness.layer.borderWidth = 1;
    self.lblMarkBusiness.layer.borderColor = kAppTintColor.CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithConnection:(NSDictionary *)connection {
    // Configure cell
    if (connection[@"imageURL"] == nil) {
        self.ivProfileImage.backgroundColor = UIColorFromRGB(0xd1d1d1);
        self.ivProfileImage.image = [UIImage imageNamed:@"UIImageViewProfileIconPicture"];
        self.ivProfileImage.contentMode = UIViewContentModeCenter;
    } else {
        self.ivProfileImage.backgroundColor = [UIColor clearColor];
        [self.ivProfileImage setImageWithURL:[NSURL URLWithString:connection[@"imageURL"]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.ivProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    self.lblName.text = [NSString stringWithFormat:@"%@ %@", connection[@"firstName"], connection[@"lastName"]];
    
    NSInteger profile_type = [connection[@"profileType"] integerValue];
    if (profile_type == 0) { // Personal
        self.lblMarkPersonal.hidden = NO;
        self.lblMarkBusiness.hidden = YES;
    } else if (profile_type == 1) { // Business
        self.lblMarkPersonal.hidden = YES;
        self.lblMarkBusiness.hidden = NO;
        self.constOfBusinessLeft.constant = 10;
    } else { // Both
        self.lblMarkPersonal.hidden = NO;
        self.lblMarkBusiness.hidden = NO;
        self.constOfBusinessLeft.constant = 83;
    }
    
}

@end
