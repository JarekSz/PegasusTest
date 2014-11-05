//
//  PTAppDelegate.h
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/1/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTMainViewController;

@interface PTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *scannedDocuments;
@property (nonatomic, weak) PTMainViewController* initialViewController;

@end
