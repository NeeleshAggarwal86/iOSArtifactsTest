//
//  ViewController.h
//  AppoxeeTestApplicatoin
//
//  Created by Raz Elkayam on 12/28/14.
//  Copyright (c) 2014 Appoxee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AppoxeeActionType) {
    AppoxeeActionTypeToggle,
    AppoxeeActionTypeTags,
    AppoxeeActionTypeCustomFields,
    AppoxeeActionTypeFeedback,
    AppoxeeActionTypeInbox,
    AppoxeeActionTypeAlias,
    AppoxeeActionTypeLog
};

#define NUM_OF_ACTIONS 7

@interface ViewController : UIViewController


@end

