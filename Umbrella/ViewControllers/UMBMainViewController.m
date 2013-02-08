//
//  UMBMainViewController.m
//  Umbrella
//
//  Created by {{YOUR_NAME_HERE}} on 9/12/12.
//  Copyright (c) 2013 {{YOUR_NAME_HERE}}. All rights reserved.
//

#import "UMBMainViewController.h"

@interface UMBMainViewController ()

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

- (void)flipsideViewControllerDidFinish:(UMBFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
