//
//  PTFlipsideViewController.h
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/1/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTAppDelegate.h"
#import "PTCroppingView.h"


@class PTFlipsideViewController;

@protocol PTFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(PTFlipsideViewController *)controller;
@end

@interface PTFlipsideViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, weak) PTAppDelegate *appDelegate;
@property (weak, nonatomic) id <PTFlipsideViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
//dynamic
@property (strong, nonatomic) IBOutlet PTCroppingView *croppingView;
@property NSInteger *index;
@property (nonatomic, strong) UIImage *currImage;

- (IBAction)done:(id)sender;

@end
