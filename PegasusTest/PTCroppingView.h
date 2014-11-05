//
//  PTCroppingView.h
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/2/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CENTER,
    LEFT_SIDE,
    RIGHT_SIDE,
    TOP_SIDE,
    BOTTOM_SIDE
} MOVE_SIDE;

@interface PTCroppingView : UIView

@property bool initialized;
@property MOVE_SIDE side;
@property CGPoint startPt;
@property CGPoint endPt;
@property CGFloat top;
@property CGFloat bottom;
@property CGFloat left;
@property CGFloat right;

@property (nonatomic, strong) UIImage *image;

@end
