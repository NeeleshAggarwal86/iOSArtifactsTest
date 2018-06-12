//
//  APXMessagDetailViewController.h
//  AppoxeeCustomInboxApp
//
//  Created by Raz Elkayam on 12/10/14.
//  Copyright (c) 2014 Appoxee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AppoxeeSDK/AppoxeeSDK.h>

@interface APXMessagDetailViewController : UIViewController

// This is the Message that it's content will be displayed in a UIWebView.
@property (nonatomic, strong) APXRichMessage *message;

// An array of buttons to display.
@property (nonatomic, strong) NSArray *barButtons;

- (void)dismissInbox;
- (void)displayDoneButton:(BOOL)show;

@end
