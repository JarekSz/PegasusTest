//
//  PTAppDelegate.h
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/1/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTDocument.h"


@interface PTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) PTDocument *myDocument;
@property (strong, nonatomic) NSMutableArray *scannedDocuments;

@end
