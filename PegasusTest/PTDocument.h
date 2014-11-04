//
//  PTDocument.h
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/1/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTDocument : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *note;
@property CGSize docSize;


@end
