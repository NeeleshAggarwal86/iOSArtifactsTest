//
//  AppDelegate.m
//  DemoApplication
//
//  Created by Raz Elkayam on 6/4/15.
//  Copyright (c) 2015 Teradata. All rights reserved.
//

#import "AppDelegate.h"
#import <AppoxeeSDK/AppoxeeSDK.h>
#import "APXRichContentViewController.h"

@interface AppDelegate () <AppoxeeDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[Appoxee shared] engageAndAutoIntegrateWithLaunchOptions:launchOptions andDelegate:self];
    
    return YES;
}

#pragma mark - Schemes

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [self handleScheme:url];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    [self handleScheme:url];
    
    return YES;
}

- (void)handleScheme:(NSURL *)scheme
{
    [[NSUserDefaults standardUserDefaults] setObject:[scheme description] forKey:@"urlScheme"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"urlScheme" object:nil];
}

#pragma mark - AppoxeeDelegate

- (void)appoxeeManager:(AppoxeeManager *)manager handledRemoteNotification:(APXPushNotification *)pushNotification andIdentifer:(NSString *)actionIdentifier
{
    // a push notification was recieved.
}

- (void)appoxeeManager:(AppoxeeManager *)manager handledRichContent:(APXRichMessage *)richMessage didLaunchApp:(BOOL)didLaunch
{
    if (didLaunch) {
        
        // If a Rich Message launched the app, we will display its content.
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        APXRichContentViewController *richContent = [storyboard instantiateViewControllerWithIdentifier:@"APXRichContentViewController"];
        [richContent setHtml:richMessage.messageLink];
        
        [self.window.rootViewController presentViewController:richContent animated:NO completion:nil];
    }
}

@end
