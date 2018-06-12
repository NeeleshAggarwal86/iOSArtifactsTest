//
//  APXWebViewViewController.m
//  NewSDKTestApplication
//
//  Created by Raz Elkayam on 5/25/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import "APXWebViewViewController.h"

@interface APXWebViewViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation APXWebViewViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad:(BOOL)animated
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"Web View";
    
    [self updateUI];
}

#pragma mark - UI

- (void)updateUI
{    
    [self.webView loadHTMLString:self.html baseURL:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
    
    NSLog(@"Error while loading web view: %@", error);
}

@end
