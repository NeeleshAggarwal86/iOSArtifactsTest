//
//  APXMessagesMasterTableViewController.h
//  AppoxeeCustomInboxApp
//
//  Created by Raz Elkayam on 12/10/14.
//  Copyright (c) 2014 Appoxee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APXMessagDetailViewController;

@interface APXMessagesMasterTableViewController : UITableViewController

// We keep a pointer to our Detail View Controller.
@property (nonatomic, strong) APXMessagDetailViewController *messageDetailViewController;

@end
