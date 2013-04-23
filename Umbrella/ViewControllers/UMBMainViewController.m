//
//  UMBMainViewController.m
//  Umbrella
//
//  Created by {{YOUR_NAME_HERE}} on 9/12/12.
//  Copyright (c) 2013 {{YOUR_NAME_HERE}}. All rights reserved.
//

#import "UMBMainViewController.h"

@interface UMBMainViewController ()

/*!
 @method showSettings:
 @abstract On tap, shows the settings (flipside) screen
 @param sender The button that was tapped
 */
- (IBAction)showSettings:(id)sender;

@end

@implementation UMBMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (IBAction)showSettings:(id)sender
{
    UMBFlipsideViewController *controller = [[UMBFlipsideViewController alloc] initWithNibName:@"UMBFlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:(sender) ? YES : NO completion:nil];
}

- (void)flipsideViewControllerDidFinish:(UMBFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
