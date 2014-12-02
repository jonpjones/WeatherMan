//
//  AppDelegate.m
//  Umbrella
//
//  Created by Jon Rexeisen on 11/25/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "AppDelegate.h"
#import "WeatherAPIClient.h"
#import "NSURLRequest+Umbrella.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

#error Look at me first
    // All the layout metrics are contained in the file called metrics.md located as a descendant of the Supporting Files group
    // Reference screen shots are contained in the reference images folder located as a descendant of the Umbrella group
    
    // UIColors for the use for reference in the rest of the application
    UIColor *warmColor = [UIColor colorWithRed:1.0f green:152.0f / 255.0f blue:0.0f alpha:1.0f];
    UIColor *coolColor = [UIColor colorWithRed:3.0f / 255.0f green:169.0f / 255.0f blue:244.0f / 255.0f alpha:1.0f];
    
    // The client will barf if you don't call this first
    [[WeatherAPIClient sharedClient] setAPIKey:@"YOUR API KEY"];
    
    // Here is how you’d actually call this
    [[WeatherAPIClient sharedClient] getForecastAndConditionsForZipCode:@"90210" withCompletionBlock:^(BOOL success, NSDictionary *result, NSError *error) {
        // Completion block, yo.
    }];
    
    // Here’s where to look for the information, because let’s be honest, you know how to read JSON
    // All values are as of November 25, 2014
    
    // Current Conditions
    // City         : current_observation.display_location.full
    // Temp         : current_observation.(temp_f || temp_c)
    // Condition    : current_observation.weather
    
    // Hourly information
    // Timestamp    : hourly_forecast.FCTTIME.(civil = string representation, epoch = date from 1970)
    // Icon         : hourly_forecast.icon
    // Temp         : hourly_forecast.temp.(english || metric)
    
    // How to use the icon name to get the URL. Solid icons are used for the daily highs and lows
    NSURLRequest *solidIcon = [NSURLRequest nrd_weatherRequestForIcon:@"clear" highlighted:YES];
    NSURLRequest *outlineIcon = [NSURLRequest nrd_weatherRequestForIcon:@"clear" highlighted:NO];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
