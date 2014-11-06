//
//  PTCroppingView.m
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/2/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import "PTCroppingView.h"

#define APPROX 20

@interface PTCroppingView ()

@end


@implementation PTCroppingView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);

    if (!_initialized) {
        [self initialize];
    }

    CGPoint leftTop = CGPointMake(_left, _top);
    CGPoint rightTop = CGPointMake(_right, _top);
    CGPoint rightBottom = CGPointMake(_right, _bottom);
    CGPoint leftBottom = CGPointMake(_left, _bottom);

    //////////////////////////////////////////////////////////////////
    //
    // draw max and min dashed lines
    //
    float dashPhase = 0.0;
    CGFloat dashLengths[] = { 10 };
    
    CGContextSetLineWidth(context, 3.0);
    CGContextSetLineDash(context,
                         dashPhase,
                         dashLengths,
                         sizeof( dashLengths ) / sizeof( float ) );
    
    CGContextMoveToPoint(context, leftTop.x, leftTop.y);
    CGContextAddLineToPoint(context, rightTop.x, rightTop.y);
    CGContextAddLineToPoint(context, rightBottom.x, rightBottom.y);
    CGContextAddLineToPoint(context, leftBottom.x, leftBottom.y);
    CGContextAddLineToPoint(context, leftTop.x, leftTop.y);

    CGContextStrokePath(context);
}

- (void)initialize
{
    CGRect frame = [[UIScreen mainScreen] bounds];

    _top = frame.origin.y+25;
    _bottom = frame.origin.y+frame.size.height-150;
    _left = frame.origin.x+25;
    _right = frame.origin.x+frame.size.width-25;
    
    self.initialized = true;
}

#pragma mark - Gestures

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _startPt = [touch locationInView:self];
    
    if (abs(_startPt.x - _left) < APPROX) {
        _side = LEFT_SIDE;
    }
    else if (abs(_startPt.x - _right) < APPROX) {
        _side = RIGHT_SIDE;
    }
    else if (abs(_startPt.y - _top) < APPROX) {
        _side = TOP_SIDE;
    }
    else if (abs(_startPt.y - _bottom) < APPROX) {
        _side = BOTTOM_SIDE;
    }
    else {
        _side = CENTER;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _endPt = [touch locationInView:self];
    
    float horizontal = _endPt.x - _startPt.x;
    float vertical = _endPt.y - _startPt.y;
    
    switch (_side) {
        case LEFT_SIDE:
            _left += horizontal;
            break;
        case RIGHT_SIDE:
            _right += horizontal;
            break;
        case TOP_SIDE:
            _top += vertical;
            break;
        case BOTTOM_SIDE:
            _bottom += vertical;
            break;
            
        default:
            _left += horizontal;
            _right += horizontal;
            _top += vertical;
            _bottom += vertical;
            break;
    }
    
    _side = CENTER;
    
    [self setNeedsDisplay];
}

@end
