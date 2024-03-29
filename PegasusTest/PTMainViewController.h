//
//  PTMainViewController.h
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/1/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "PTFlipsideViewController.h"
#import "PTAppDelegate.h"


@interface PTMainViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,PTFlipsideViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) PTAppDelegate *appDelegate;
@property (nonatomic, strong) PTFlipsideViewController *flipsideView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *currImage;
@property NSInteger currIndex;


- (void)updateImage:(UIImage *)image atIndex:(NSInteger)index;

@end
