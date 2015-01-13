//
//  SettingsViewController.m
//  Umbrella
//
//  Created by Jon Rexeisen on 11/25/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (!self) {
        NSAssert(NO, @"Could not create instance of type %s", __PRETTY_FUNCTION__);
        return nil;
    }
    
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    return self;
}

#pragma mark - IBActions

- (IBAction)getTheWeatherButtonTapped:(id)sender
{
    // Temporary ugly code here for illustrative purposes
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
