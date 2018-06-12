//
//  APXMessagesMasterTableViewController.m
//  AppoxeeCustomInboxApp
//
//  Created by Raz Elkayam on 12/10/14.
//  Copyright (c) 2014 Appoxee. All rights reserved.
//

#import "APXMessagesMasterTableViewController.h"
#import "APXMessagDetailViewController.h"
#import <AppoxeeSDK/AppoxeeSDK.h>
#import "APXMessageTableViewCell.h"

@interface APXMessagesMasterTableViewController () <UISplitViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *messages; // of Type APXRichMessage
@property (nonatomic, readonly) BOOL isIpad;

@property (nonatomic, strong) UIButton *upButton;
@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, strong) UIRefreshControl *refreshControler;

// Only used with iOS7
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIBarButtonItem *masterBarButtonItem;
@property (nonatomic, strong) UIPopoverController *masterPopOverController;

@end

@implementation APXMessagesMasterTableViewController

#pragma mark - View Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControler = [[UIRefreshControl alloc] init];
    [self.refreshControler addTarget:self action:@selector(reloadMessages) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControler];
    
    [self setup];
}

#pragma mark - Initialization

- (void)setup
{
    self.splitViewController.delegate = self;
    
    [self setWantedContentSize];
    [self setupDisplay];
    [self reloadMessages];
}

- (void)setWantedContentSize
{
    if (self.isIpad) {
        
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)setupDisplay
/*
  1. Setup the display dynamically, depending on the OS we are running on.
  2. Setup our navigation bar
  3. save a pointer to the Detail View Controller.
*/
{
    if (self.isIpad) {
        
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
        
    } else {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissInbox)];
    }
    
    if ([self.splitViewController respondsToSelector:@selector(setPreferredDisplayMode:)] && self.isIpad) {
        
        self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
        
    }
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.title = NSLocalizedString(@"Inbox", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStyleDone target:self action:@selector(editBarButtonPressed:)];
    
    self.messageDetailViewController = (APXMessagDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.messageDetailViewController.navigationItem.leftBarButtonItems = [self barButtonsArray];
    self.messageDetailViewController.navigationItem.leftItemsSupplementBackButton = YES;
}

#pragma mark - UI

- (void)reloadMessages
/*
  Method will Reload Messages, while displaying our Refresh Contoller.
  We will only add messages that are considered as 'new', in order to provide an animation effect for 'new' messages.
*/
{
    [self.refreshControler beginRefreshing];
    
    [[Appoxee shared] refreshInboxWithCompletionHandler:^(NSError *appoxeeError, id data) {
        
        [self.refreshControler endRefreshing];
        
        if (!appoxeeError) {
            
            self.messages = data;
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            if (!self.messageDetailViewController.message && [self.messages count] && self.isIpad) {
                
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self.messageDetailViewController setMessage:[self.messages firstObject]];
                [self updateButtonsByIndexPath:0];
                
            } else if ([self.messages count] == 0) {
                
                [self updateButtonsByIndexPath:-1];
            }
        }
    }];
}

- (void)updateButtonsByIndexPath:(NSInteger)messageIndex
/*
  Method will contorol our barButtonsArray items display,
  And will select the cell which is displayed by the Detail View Controller,
  While keeping the Table View updated.
*/
{
    if (messageIndex == 0) {
        
        self.upButton.selected = YES;
        self.upButton.userInteractionEnabled = NO;
        
        if (([self.messages count] - 1) > messageIndex) {
            
            self.downButton.selected = NO;
            self.downButton.userInteractionEnabled = YES;
        }
        
    } else if (messageIndex > 0 && messageIndex < ([self.messages count] - 1)) {
        
        self.upButton.selected = NO;
        self.upButton.userInteractionEnabled = YES;
        self.downButton.selected = NO;
        self.downButton.userInteractionEnabled = YES;
        
    } else if (messageIndex == ([self.messages count] - 1) && messageIndex != -1){
        
        self.upButton.selected = NO;
        self.upButton.userInteractionEnabled = YES;
        self.downButton.selected = YES;
        self.downButton.userInteractionEnabled = NO;
        
    } else {
        
        self.upButton.selected = YES;
        self.upButton.userInteractionEnabled = NO;
        self.downButton.selected = YES;
        self.downButton.userInteractionEnabled = NO;
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:messageIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:messageIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        [self updateButtonsByIndexPath:indexPath.row];
        APXRichMessage *selectedMessage = self.messages[indexPath.row];
        
        APXMessagDetailViewController *messageDetailController;
        id obj = [segue destinationViewController];
        
        if ([obj respondsToSelector:@selector(topViewController)]) {
            
            messageDetailController = (APXMessagDetailViewController *)[[segue destinationViewController] topViewController];
            
        } else {
            
            messageDetailController = (APXMessagDetailViewController *)[segue destinationViewController];
        }
                
        [messageDetailController setMessage:selectedMessage];
        [messageDetailController setBarButtons:[self barButtonsArray]];
    }
}

#pragma mark - Orientation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
/*
  This method will keep our display in the same way on iOS8 for iPad,
  And will manage the display of our barButtonsArray on iOS7
*/
{
    if ([self.splitViewController respondsToSelector:@selector(setPreferredDisplayMode:)]) {
        
        [self performSelector:@selector(maintainStateForMasterAndDetailOnOrientationChange) withObject:nil afterDelay:duration];
    
    } else {
        
        if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
            
            self.messageDetailViewController.navigationItem.leftBarButtonItems = [self barButtonsArray];
            
        } else {
            
            NSMutableArray *items = [self.messageDetailViewController.navigationItem.leftBarButtonItems mutableCopy];
            [items removeObject:[items firstObject]];
            self.messageDetailViewController.navigationItem.leftBarButtonItems = items;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.messages count];
    
    count ? [self.navigationItem.leftBarButtonItem setEnabled:YES] : [self.navigationItem.leftBarButtonItem setEnabled:NO];
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APXMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    APXRichMessage *message = (APXRichMessage *)self.messages[indexPath.row];
    
    [cell setIsRead:message.isRead];
    cell.messageTitle.text = [message.title stringByAppendingString:@"\n"];
    cell.messageSubtitle.text = [message.content stringByAppendingString:@"\n"];
    cell.messageTime.text = [message.postDate description];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
/*
  Here we need to act in different ways, depending if the Table View is in 'Edit Mode'
  If we are Editing, we will manage the display,
  Other wise, we will perform Navigation & display logic, depending on the device we are running on.
*/
{
    if (!tableView.isEditing) {
        
        APXRichMessage *selectedMessage = self.messages[indexPath.row];
        
         if (self.isIpad) {
             
             [self.messageDetailViewController setMessage:selectedMessage];
             
         } else {
             
             [self performSegueWithIdentifier:@"showDetail" sender:indexPath];
         }
        
        [self updateButtonsByIndexPath:indexPath.row];
        
        [self toggleMaster];
        
    } else {
        
        if ([[tableView indexPathsForSelectedRows] count]) {
            
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
/*
  Here we are only managing the display if the Table View is in 'Edit Mode'.
*/
{
    if (self.tableView.isEditing) {
        
        if (![[tableView indexPathsForSelectedRows] count]) {
            
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        APXRichMessage *message = self.messages[indexPath.row];
        
        [self.messages removeObject:message];
        [[Appoxee shared] deleteRichMessage:message withHandler:nil];
                    
        [self.tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode NS_AVAILABLE_IOS(8_0)
{
    [self handleDoneButtonByDisplayMode:displayMode];
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController NS_AVAILABLE_IOS(8_0)
/*
  If we are on an iPad, let the SplitViewController manage the display,
  Else, we will return YES to avoid displaying the Detail View Controller on startup
*/
{
    if (self.isIpad) {
        
        return NO;
        
    } else {
        
        return YES;
    }
}

- (void)handleDoneButtonByDisplayMode:(UISplitViewControllerDisplayMode)displayMode
{
    if (displayMode == UISplitViewControllerDisplayModePrimaryOverlay) {
        
        if (self.isIpad) {
            
            [self.messageDetailViewController displayDoneButton:NO];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissInbox)];
        }
        
    } else {
        
        if (self.isIpad) {
            
            [self.messageDetailViewController displayDoneButton:YES];
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc NS_DEPRECATED_IOS(2_0, 8_0, "Use splitViewController:willChangeToDisplayMode: and displayModeButtonItem instead")
/*
  This is a Delegate method of UISplitViewController, which we will use to fetch the bar button, from which the Master will be displayed.
  Notice the methods are deprecated on iOS8
*/
{
    self.masterPopOverController = pc;
    self.masterBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem NS_DEPRECATED_IOS(2_0, 8_0, "Use splitViewController:willChangeToDisplayMode: and displayModeButtonItem instead")
/*
  This is a Delegate method of UISplitViewController, which we will use to fetch the bar button, from which the Master will be displayed.
  Notice the methods are deprecated on iOS8
 */
{
    self.masterPopOverController = nil;
    self.masterBarButtonItem = nil;
}

#pragma mark - Actions

- (void)dismissInbox
/*
  Return to the displaying View Controller.
*/
{
    if (self.isIpad) {
        
        [self toggleMaster];
        [self.messageDetailViewController dismissInbox];
        
    } else {
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}

- (void)editBarButtonPressed:(UIBarButtonItem *)sender
{
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    [self updateButtonsState:sender];
}

- (void)updateButtonsState:(UIBarButtonItem *)sender
/*
  Manage the title of our 'Edit / Cancel' buttom, according to the Table View state.
*/
{
    if (self.tableView.isEditing) {
        
        [sender setTitle:NSLocalizedString(@"Cancel", nil)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Delete", nil) style:UIBarButtonItemStyleDone target:self action:@selector(deleteSelectedItems:)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor redColor]];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
    } else {
        
        [sender setTitle:NSLocalizedString(@"Edit", nil)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissInbox)];
    }
}

- (void)deleteSelectedItems:(UIBarButtonItem *)sender
/*
  Use Appoxee's API to delete Messages.
*/
{
    NSArray *selectedIndexes = [self.tableView indexPathsForSelectedRows];
    
    NSMutableArray *tmpMessages = [[NSMutableArray alloc] init];
    
    for (NSIndexPath *indexPath in selectedIndexes) {
        
        APXRichMessage *message = self.messages[indexPath.row];
        [tmpMessages addObject:message];
    }
    
    for (APXRichMessage *message in tmpMessages) {
        
        [[Appoxee shared] deleteRichMessage:message withHandler:nil];
    }
    
    [self.messages removeObjectsInArray:tmpMessages];

    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:selectedIndexes withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self.tableView setEditing:NO animated:YES];
    [self updateButtonsState:self.navigationItem.leftBarButtonItem];
}

- (void)toggleMaster
/*
  Used on iOS8 to display the Master by 'clicking a button', but is actuallt done by animating preferredDisplayMode @property of UISplitViewController
*/
{
    if ([self.splitViewController respondsToSelector:@selector(setPreferredDisplayMode:)]) {
        
        if (self.isIpad) {
            
            if (self.splitViewController.displayMode == UISplitViewControllerDisplayModePrimaryOverlay) {
                
                [UIView animateWithDuration:0.33f animations:^{
                    
                    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
                }];
                
            } else if (self.splitViewController.displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
                
                [UIView animateWithDuration:0.33f animations:^{
                    
                    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
                }];
            }
        }
    }
}

- (void)maintainStateForMasterAndDetailOnOrientationChange
{
    if (self.isIpad) {
        
        if (self.splitViewController.displayMode == UISplitViewControllerDisplayModePrimaryOverlay) {
            
            [UIView animateWithDuration:0.33f animations:^{
                
                self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
                
            } completion:^(BOOL finished) {
                
                [self handleDoneButtonByDisplayMode:self.splitViewController.displayMode];
            }];
        }
    }
}

- (void)downButtonPressed:(UIButton *)sender
/*
 Manage pressing the 'up / down' button on the Detail View Controller Navigation bar.
 We will need to perform according to the platform we are on.
*/
{
    if (!sender.selected) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSIndexPath *downIndex = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
        
        APXRichMessage *message = self.messages[downIndex.row];
        
        if (self.isIpad) {
            
            [self.messageDetailViewController setMessage:message];
            
        } else {
            
            UINavigationController *nav = (UINavigationController *)[[self.splitViewController.viewControllers lastObject] topViewController];
            APXMessagDetailViewController *detail = (APXMessagDetailViewController *)[nav.viewControllers lastObject];
            [detail setBarButtons:[self barButtonsArray]];
            [detail setMessage:message];
        }
        
        [self updateButtonsByIndexPath:downIndex.row];
    }
}

- (void)upButtonPressed:(UIButton *)sender
/*
 Manage pressing the 'up / down' button on the Detail View Controller Navigation bar.
 We will need to perform according to the platform we are on.
*/
{
    if (!sender.selected) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSIndexPath *upIndex = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
        
        APXRichMessage *message = self.messages[upIndex.row];
        
        if (self.isIpad) {
            
            [self.messageDetailViewController setMessage:message];
            
        } else {
            
            UINavigationController *nav = (UINavigationController *)[[self.splitViewController.viewControllers lastObject] topViewController];
            APXMessagDetailViewController *detail = (APXMessagDetailViewController *)[nav.viewControllers lastObject];
            [detail setBarButtons:[self barButtonsArray]];
            [detail setMessage:message];
        }
        
        [self updateButtonsByIndexPath:upIndex.row];
    }
}

- (void)backButtonPressed:(id)sender
/*
  The following code will only run on iOS7
  Will cause the Master View Controller to be displayed
*/
{
    [self.masterPopOverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)self.backButton.superview permittedArrowDirections:UIPopoverArrowDirectionUnknown animated:YES];
}

#pragma mark - Getters

- (BOOL)isIpad
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}

- (NSArray *)barButtonsArray
/*
 If it's iOS8 we will use the SplitViewController 'hide / show' master
 If it's iOS7 we will use a custom UIButton.
*/
{
    if ([self.splitViewController respondsToSelector:@selector(setPreferredDisplayMode:)]) {
        
        return @[self.splitViewController.displayModeButtonItem, [[UIBarButtonItem alloc] initWithCustomView:self.upButton], [[UIBarButtonItem alloc] initWithCustomView:self.downButton]];
        
    } else {
    
        return @[[[UIBarButtonItem alloc] initWithCustomView:self.backButton], [[UIBarButtonItem alloc] initWithCustomView:self.upButton], [[UIBarButtonItem alloc] initWithCustomView:self.downButton]];
    }
}

#pragma mark - Lazy Instantiation

- (UIButton *)upButton
{
    if (!_upButton) {
        
        _upButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_upButton setFrame:CGRectMake(0, 0, 32, 22)];
        [_upButton setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
        [_upButton setImage:[UIImage imageNamed:@"upDisabled"] forState:UIControlStateSelected];
        [_upButton addTarget:self action:@selector(upButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _upButton;
}

- (UIButton *)downButton
{
    if (!_downButton) {
        
        _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downButton setFrame:CGRectMake(0, 0, 32, 22)];
        [_downButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        [_downButton setImage:[UIImage imageNamed:@"downDisabled"] forState:UIControlStateSelected];
        [_downButton addTarget:self action:@selector(downButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _downButton;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backButton setFrame:CGRectMake(0, 0, 72, 22)];
        [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backButton setTitle:self.title forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backButton;
}

- (NSMutableArray *)messages
{
    if (!_messages) _messages = [[NSMutableArray alloc] init];
    return _messages;
}

@end
