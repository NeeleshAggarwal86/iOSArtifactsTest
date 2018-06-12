//
//  APXMessageTableViewCell.h
//  AppoxeeCustomInboxApp
//
//  Created by Raz Elkayam on 12/10/14.
//  Copyright (c) 2014 Appoxee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APXMessageTableViewCell : UITableViewCell

@property (nonatomic) BOOL isRead;
@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UILabel *messageSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *messageTime;


@end
