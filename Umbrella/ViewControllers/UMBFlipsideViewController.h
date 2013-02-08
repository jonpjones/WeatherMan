//
//  UMBFlipsideViewController.h
//  Umbrella
//
//  Created by {{YOUR_NAME_HERE}} on 9/12/12.
//  Copyright (c) 2013 {{YOUR_NAME_HERE}}. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMBFlipsideViewController;

@protocol UMBFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(UMBFlipsideViewController *)controller;
@end

@interface UMBFlipsideViewController : UIViewController

@property (weak, nonatomic) id <UMBFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
