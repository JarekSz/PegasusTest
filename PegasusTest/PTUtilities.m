//
//  PTUtilities.m
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/1/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import "PTUtilities.h"

@implementation PTUtilities

+ (NSString *)currentPath {
    
	NSString *docDir =
	[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
										 NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *fileName = @"ScannedDocs.dat";
	return [docDir stringByAppendingPathComponent:fileName];
}

+ (void)archiveScannedDocs:(NSMutableArray *)array
{
	if ([array count] > 0)
    {
        NSError *error = nil;
        NSDictionary *attrib;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *filePath = [self currentPath];
        //
        // check if file already exist
        //
        BOOL exist = [fileManager fileExistsAtPath:filePath];
        BOOL success = YES;
        if (YES == exist)
        {
            // UNLOCK THE FILE
            attrib = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                 forKey:NSFileImmutable];
            
            success = [fileManager setAttributes:attrib
                                    ofItemAtPath:filePath
                                           error:&error];
        }
        if (YES == success)
        {
            // SAVE THE FILE
            [NSKeyedArchiver archiveRootObject:array
                                        toFile:filePath];
            
            // LOCK IT BACK
            attrib = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                 forKey:NSFileImmutable];
            
            success = [fileManager setAttributes:attrib
                                    ofItemAtPath:filePath
                                           error:&error];
            
#ifdef DEBUG
            if (NO == success) {
                NSLog(@"Error: %@",[error localizedDescription]);
            }
#endif
        }
#ifdef DEBUG
        else {
            NSLog(@"Could not UNLOCK the file.");
        }
#endif
	}
}

+ (NSMutableArray *)unarchiveScannedDocs
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [self currentPath];
    
    //
    // check if file already exist
    //
    BOOL exist = [fileManager fileExistsAtPath:filePath];
    if (NO == exist)
    {
        return nil;
    }
    
	NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
	return array;
}

@end
