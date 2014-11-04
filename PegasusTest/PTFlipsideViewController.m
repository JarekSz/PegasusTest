//
//  PTFlipsideViewController.m
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/1/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import "PTFlipsideViewController.h"
#import "PTAppDelegate.h"
#import "PTUtilities.h"


@interface PTFlipsideViewController ()

@property CGPoint pt1;
@property CGPoint pt2;

@end

@implementation PTFlipsideViewController


- (BOOL) prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    if ([_appDelegate.scannedDocuments count] > 0)
    {
        self.currImage = [_appDelegate.scannedDocuments objectAtIndex:*_index];
        
        [_imageView setImage:_currImage];
        
        //
        // swipping left
        //
        UISwipeGestureRecognizer *swippingLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
        swippingLeftGesture.numberOfTouchesRequired = 1;
        swippingLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        
        [self.view addGestureRecognizer:swippingLeftGesture];
        
        swippingLeftGesture.delegate = self;
        
        //
        // swipping right
        //
        UISwipeGestureRecognizer *swippingRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
        swippingRightGesture.numberOfTouchesRequired = 1;
        swippingRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self.view addGestureRecognizer:swippingRightGesture];
        
        swippingRightGesture.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Swipping

- (void)handleRightSwipe:(UITapGestureRecognizer *)recognizer
{
    if (_cropping) {
        return;
    }
    
    if (*_index > 0) {
        (*_index)--;
    }
    
    self.currImage = [_appDelegate.scannedDocuments objectAtIndex:*_index];
    
    [_imageView setImage:_currImage];

}

- (void)handleLeftSwipe:(UITapGestureRecognizer *)recognizer
{
    if (_cropping) {
        return;
    }
    
    NSInteger last = [_appDelegate.scannedDocuments count] - 1;
    if (*_index < last) {
        (*_index)++;
    }
    
    self.currImage = [_appDelegate.scannedDocuments objectAtIndex:*_index];
    
    [_imageView setImage:_currImage];
    
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    self.cropping = NO;
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (_cropView)
    {
        UIImage *newImage = [self cropImage:_currImage];
        
        [_imageView setImage:newImage];
        
        NSInteger index = [_appDelegate.scannedDocuments indexOfObject:_currImage];
        
        [_appDelegate.scannedDocuments replaceObjectAtIndex:index withObject:newImage];
        
        [PTUtilities archiveScannedDocs:_appDelegate.scannedDocuments];
    }
    
    self.cropView = nil;

    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)crop:(id)sender
{
    self.cropping = YES;
    
    if (_cropView == nil)
    {
        CGRect rect = _imageView.frame;
        
        self.cropView = [[PTCroppingView alloc] initWithFrame:rect];
        
        [_cropView setBackgroundColor:[UIColor clearColor]];
        
        [self.view addSubview:_cropView];
    }
}

- (UIImage *)cropImage:(UIImage *)image {
    double ratio;
    double delta;
    CGPoint offset;
    
    CGFloat width = _cropView.right - _cropView.left;
    CGFloat height = _cropView.bottom - _cropView.top;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(width, height);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = height / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark -
#pragma mark - Scale Image

//////////////////////////////////////////////////////////////////////////////////////////////
//
// Images could be of different sizes and shapes. In order to show them nicely we need to
// Resize each Image.
//
- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize
{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
