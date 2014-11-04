//
//  PTFlipsideViewController.h
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/1/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTDocument.h"
#import "PTAppDelegate.h"
#import "PTCroppingView.h"


@class PTFlipsideViewController;

@protocol PTFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(PTFlipsideViewController *)controller;
@end

@interface PTFlipsideViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, weak) PTAppDelegate *appDelegate;
@property (weak, nonatomic) id <PTFlipsideViewControllerDelegate> delegate;
//@property (strong, nonatomic) PTDocument *myDocument;
@property (strong, nonatomic) UIImageView *docView;
//dynamic
@property (strong, nonatomic) PTCroppingView *cropView;

@property int index;
//@property (nonatomic, strong) PTDocument *currDocument;
@property (nonatomic, strong) UIImage *currImage;

- (IBAction)done:(id)sender;

@end
