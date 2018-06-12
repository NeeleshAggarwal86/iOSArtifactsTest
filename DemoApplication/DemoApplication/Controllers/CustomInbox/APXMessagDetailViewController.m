//
//  APXMessagDetailViewController.m
//  AppoxeeCustomInboxApp
//
//  Created by Raz Elkayam on 12/10/14.
//  Copyright (c) 2014 Appoxee. All rights reserved.
//

#import "APXMessagDetailViewController.h"
#import "APXMessagesMasterTableViewController.h"

@interface APXMessagDetailViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, readonly) BOOL isIpad;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) BOOL flag;

@end

@implementation APXMessagDetailViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isIpad) {
        
        self.navigationController.navigationItem.leftBarButtonItems = self.barButtons;
        self.navigationItem.leftItemsSupplementBackButton = YES;
        
    } else {
        
        NSArray *barButtons = self.barButtons;
        self.navigationController.navigationItem.leftBarButtonItem = [barButtons firstObject];
        self.navigationItem.leftItemsSupplementBackButton = YES;
        
        self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:barButtons[1], barButtons[2], nil];
    }
    
    [self updateUI];
}

#pragma mark - Initialization

- (void)setup
{
    self.title = @"";
    self.automaticallyAdjustsScrollViewInsets = NO; // to cause the WebView to be under the navigation bar.
    self.webView.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webViewWasTaped:)];
    tapGesture.delegate = self;
    [self.webView addGestureRecognizer:tapGesture];
}

#pragma mark - UI

- (void)updateUI
{
    // We will extract the Link / URL from the Appoxee Message and display it in a UIWebview.
    
    NSString *string = self.message.messageLink;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:string]];
    [self.webView loadRequest:request];
    
    // we will auto hide the navigation bar on an iPhone
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.isIpad && !self.navigationController.isNavigationBarHidden) {
            
                [self webViewWasTaped:nil];
        }
    });
}

#pragma mark - Actions

- (void)dismissInbox
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)displayDoneButton:(BOOL)show
{
    if (show) {
        
        // we will need to set this dynamically, according to the current OS.
        if (self.isIpad) {
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissInbox)];
        }
        
    } else {
        
        // we will need to set this dynamically, according to the current OS.
        if (self.isIpad) {
            
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

#pragma mark - Setters

- (void)setMessage:(APXRichMessage *)message
{
    _message = message;
    
    [self updateUI];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
    [self.view setUserInteractionEnabled:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view setUserInteractionEnabled:YES];
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{    
    NSLog(@"WebView Error: %@", error);
}

#pragma mark - UITapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)webViewWasTaped:(UITapGestureRecognizer *)sender
{
    self.flag = !self.flag;
    
    [self.navigationController setNavigationBarHidden:self.flag animated:YES];
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

@end
