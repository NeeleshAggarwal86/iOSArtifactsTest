//
//  APXTagTableViewCell.h
//  NewSDKTestApplication
//
//  Created by Raz Elkayam on 4/7/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APXTagTableViewCell;

@protocol APXTagTableViewCellDelegate <NSObject>

- (void)tagTableViewCell:(APXTagTableViewCell *)cell switcherWasPressed:(UISwitch *)switcher;

@end

@interface APXTagTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tagNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *tagStateSwitch;
@property (weak, nonatomic) id <APXTagTableViewCellDelegate> delegate;

@end
