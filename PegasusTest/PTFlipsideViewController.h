//
//  PTFlipsideViewController.h
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/1/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTFlipsideViewController;

@protocol PTFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(PTFlipsideViewController *)controller;
@end

@interface PTFlipsideViewController : UIViewController

@property (weak, nonatomic) id <PTFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
