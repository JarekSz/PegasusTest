//
//  PTDocument.m
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/1/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import "PTDocument.h"

#define kName   @"date"
#define kImage  @"image"
#define kTitle  @"title"
#define kNote   @"note"
//#define kSize   @"size"

@interface PTDocument ()


@end

@implementation PTDocument

- (void)encodeWithCoder: (NSCoder *)encoder
{
    [encoder encodeObject:_date     forKey:kName];
    [encoder encodeObject:_image    forKey:kImage];
    [encoder encodeObject:_title    forKey:kTitle];
    [encoder encodeObject:_note     forKey:kNote];
//    [encoder encodeCGSize:_docSize  forKey:kSize];
}

- (id)initWithCoder: (NSCoder *)decoder
{
    if ( (self = [super init]) )
    {
        _date =     [decoder decodeObjectForKey:kName];
        _image =    [decoder decodeObjectForKey:kImage];
        _title =    [decoder decodeObjectForKey:kTitle];
        _note =     [decoder decodeObjectForKey:kNote];
//        _docSize =  [decoder decodeCGSizeForKey:kSize];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    PTDocument *doc = [[PTDocument alloc] init];
    
    doc.date =      _date;
    doc.image =     _image;
    doc.title =     _title;
    doc.note =      _note;
//    doc.docSize =   _docSize;
    
    return doc;
}

- (id)init
{
    if ( (self = [super init]) )
    {
        self.date =     [NSDate date];
        self.image =    nil;
        self.title =    @"";
        self.note =     @"";
//        self.docSize =  CGSizeZero;
    }
    
    return self;
}

@end
