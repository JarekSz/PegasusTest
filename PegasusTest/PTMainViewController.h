//
//  PTMainViewController.h
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/1/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import "PTFlipsideViewController.h"
#import "PTAppDelegate.h"


@interface PTMainViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,PTFlipsideViewControllerDelegate>

@property (nonatomic, weak) PTAppDelegate *appDelegate;
@property (nonatomic, strong) PTFlipsideViewController *flipsideView;
//@property (nonatomic, strong) NSMutableArray *scannedDocuments;

@end
