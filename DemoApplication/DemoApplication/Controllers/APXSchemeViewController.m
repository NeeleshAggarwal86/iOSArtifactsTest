//
//  APXSchemeViewController.m
//  NewSDKTestApplication
//
//  Created by Raz Elkayam on 5/25/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import "APXSchemeViewController.h"

@interface APXSchemeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *schemeLabel;

@end

@implementation APXSchemeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"URL Scheme";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.schemeLabel.text = self.urlScheme;
}

@end
