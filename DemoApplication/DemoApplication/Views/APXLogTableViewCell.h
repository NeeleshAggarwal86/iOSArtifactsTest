//
//  APXLogTableViewCell.h
//  AppoxeeBlog
//
//  Created by Raz Elkayam on 6/14/15.
//  Copyright (c) 2015 Teradata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APXLogTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *logTitle;
@property (weak, nonatomic) IBOutlet UILabel *logSubtitle;

@end
