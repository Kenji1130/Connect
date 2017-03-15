//
//  CNProfileEditOptionCell.m
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNProfileEditOptionCell.h"

@interface CNProfileEditOptionCell ()

@property (weak, nonatomic) IBOutlet UISwitch *hideSwitch;

@end

@implementation CNProfileEditOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onHideSwitchChanged:(id)sender {
}

@end
