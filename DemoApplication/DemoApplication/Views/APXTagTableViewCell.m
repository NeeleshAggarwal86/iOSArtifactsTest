//
//  APXTagTableViewCell.m
//  NewSDKTestApplication
//
//  Created by Raz Elkayam on 4/7/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import "APXTagTableViewCell.h"

@implementation APXTagTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)switcherWasPressed:(UISwitch *)sender
{
    [self.delegate tagTableViewCell:self switcherWasPressed:sender];
}

@end
