//
//  APXLogViewController.m
//  NewSDKTestApplication
//
//  Created by Raz Elkayam on 5/25/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import "APXLogViewController.h"
#import <AppoxeeSDK/AppoxeeSDK.h>
#import "APXLogTableViewCell.h"

@interface APXLogViewController () <UITableViewDataSource>

@property (nonatomic, strong) APXClientDevice *device;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation APXLogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[Appoxee shared] deviceInformationwithCompletionHandler:^(NSError *appoxeeError, id data) {
        
        if (!appoxeeError && [data isKindOfClass:[APXClientDevice class]]) {
            
            self.device = (APXClientDevice *)data;
            [self.tableView reloadData];
            
        } else {
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APXLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.logTitle.text = [self titleForIndexPath:indexPath];
    
    cell.logSubtitle.text = [self subtitleForIndexPath:indexPath];
    
    return cell;
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            title = @"SDK Version";
        }
            break;
        case 1:
        {
            title = @"Local";
        }
            break;
        case 2:
        {
            title = @"Time Zone";
        }
            break;
        case 3:
        {
            title = @"Push Token";
        }
            break;
        case 4:
        {
            title = @"UDID";
        }
            break;
        case 5:
        {
            title = @"OS Name";
        }
            break;
        case 6:
        {
            title = @"OS Version";
        }
            break;
        case 7:
        {
            title = @"Hardwear Type";
        }
            break;
        case 8:
        {
            title = @"Application ID";
        }
            break;
        case 9:
        {
            title = @"Inbox Enabled";
        }
            break;
        case 10:
        {
            title = @"Badge Enabled";
        }
            break;
        case 11:
        {
            title = @"Sound Enabled";
        }
            break;
        case 12:
        {
            title = @"Push Enabled";
        }
            break;
    }
    
    return title;
}

- (NSString *)subtitleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            title = [NSString stringWithFormat:@"%@", self.device.sdkVersion];
        }
            break;
        case 1:
        {
            title = [NSString stringWithFormat:@"%@", self.device.locale];
        }
            break;
        case 2:
        {
            title = [NSString stringWithFormat:@"%@", self.device.timeZone];
        }
            break;
        case 3:
        {
            title = [NSString stringWithFormat:@"%@", self.device.pushToken];
        }
            break;
        case 4:
        {
            title = [NSString stringWithFormat:@"%@", self.device.udid];
        }
            break;
        case 5:
        {
            title = [NSString stringWithFormat:@"%@", self.device.osName];
        }
            break;
        case 6:
        {
            title = [NSString stringWithFormat:@"%@", self.device.osVersion];
        }
            break;
        case 7:
        {
            title = [NSString stringWithFormat:@"%@", self.device.hardwearType];
        }
            break;
        case 8:
        {
            title = [NSString stringWithFormat:@"%@", self.device.applicationID];
        }
            break;
        case 9:
        {
            title = [NSString stringWithFormat:@"%@", self.device.isInboxEnabled ? @"YES" : @"NO"];
        }
            break;
        case 12:
        {
            title = [NSString stringWithFormat:@"%@", self.device.isPushEnabled ? @"YES" : @"NO"];
        }
            break;
    }
    
    return title;
}
@end
