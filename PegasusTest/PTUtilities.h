//
//  PTUtilities.h
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/1/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTUtilities : NSObject

+ (NSString *)currentPath;
+ (void)archiveScannedDocs:(NSMutableArray *)array;
+ (NSMutableArray *)unarchiveScannedDocs;

@end
