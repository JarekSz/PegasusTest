//
//  PTAppDelegate.m
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/1/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import "PTAppDelegate.h"
#import "PTUtilities.h"
#import "PTMainViewController.h"


@implementation PTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.initialViewController = (PTMainViewController *)self.window.rootViewController;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _scannedDocuments = [PTUtilities unarchiveScannedDocs];
        
        if (_scannedDocuments) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([_scannedDocuments count] > 0) {
                    UIImage *image = [_scannedDocuments lastObject];
                    NSInteger index = [_scannedDocuments count] - 1;
                    [_initialViewController updateImage:image atIndex:index];
                }
            });
        }
    });
    
    return YES;
}

@end
