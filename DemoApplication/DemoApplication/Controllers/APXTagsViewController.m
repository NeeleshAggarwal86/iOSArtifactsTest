//
//  APXTagsViewController.m
//  NewSDKTestApplication
//
//  Created by Raz Elkayam on 4/5/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import "APXTagsViewController.h"
#import "APXTagTableViewCell.h"
#import <AppoxeeSDK/AppoxeeSDK.h>

@interface APXTagsViewController () <UITableViewDataSource, UITableViewDelegate, APXTagTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *applicationTags;
@property (nonatomic, strong) NSArray *deviceTags;

@end

@implementation APXTagsViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Tags";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

#pragma mark - UI

- (void)updateUI
{
    [[Appoxee shared] fetchApplicationTags:^(NSError *appoxeeError, id data) {
        
        if (!appoxeeError && [data isKindOfClass:[NSArray class]]) {
            
            self.applicationTags = (NSArray *)data;
            
            [[Appoxee shared] fetchDeviceTags:^(NSError *appoxeeError, id data) {
                
                if (!appoxeeError && [data isKindOfClass:[NSArray class]]) {
                    
                    self.deviceTags = (NSArray *)data;
                    
                } else {
                    
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
                
                [self.tableView reloadData];
                
            }];
            
        } else {
            
            [self.tableView reloadData];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.applicationTags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APXTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setDelegate:self];
    cell.tagNameLabel.text = (NSString *)self.applicationTags[indexPath.row];
    [cell.tagStateSwitch setOn:[self isStateOnByIndex:indexPath.row]];
    
    return cell;
}

- (BOOL)isStateOnByIndex:(NSInteger)index
{
    BOOL state = NO;
    
    NSString *applicationTag = self.applicationTags[index];
    
    for (NSString *deviceTag in self.deviceTags) {
        
        if ([deviceTag isEqualToString:applicationTag]) {
            
            state = YES;
            break;
        }
    }
    
    return state;
}

#pragma mark - APXTagTableViewCellDelegate

- (void)tagTableViewCell:(APXTagTableViewCell *)cell switcherWasPressed:(UISwitch *)switcher
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSArray *tags = @[self.applicationTags[indexPath.row]];
    
    if (switcher.isOn) {
        
        [[Appoxee shared] addTagsToDevice:tags withCompletionHandler:^(NSError *appoxeeError, id data) {
            
            if (appoxeeError) {
                
                [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            
            [self updateUI];
        }];
        
    } else {
     
        [[Appoxee shared] removeTagsFromDevice:tags withCompletionHandler:^(NSError *appoxeeError, id data) {
            
            if (appoxeeError) {
                
                [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            
            [self updateUI];
        }];
    }
}

@end
