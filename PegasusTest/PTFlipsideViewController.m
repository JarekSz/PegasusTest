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
    if (*_index > 0) {
        (*_index)--;
    }
    
    self.currImage = [_appDelegate.scannedDocuments objectAtIndex:*_index];
    
    [_imageView setImage:_currImage];

}

- (void)handleLeftSwipe:(UITapGestureRecognizer *)recognizer
{
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
    [_appDelegate.scannedDocuments replaceObjectAtIndex:*_index withObject:_currImage];
    
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)crop:(id)sender
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    // image size
    CGFloat imgWidth = _imageView.image.size.width;
    CGFloat imgHeight = _imageView.image.size.height;
    
    CGFloat ratioX = imgWidth / frame.size.width;
    CGFloat ratioY = imgHeight / frame.size.height;
    
    CGFloat ratio = MAX(ratioX, ratioY);

    CGFloat scrWidth = frame.size.width * ratio;
    CGFloat scrHeight = frame.size.height * ratio;
    
    CGFloat marginLeft = (scrWidth - imgWidth) / 2;
    CGFloat marginTop = (scrHeight - imgHeight) / 2;
    
    CGFloat left = _croppingView.left * ratio - marginLeft;
    CGFloat top = marginTop - _croppingView.top * ratio;
    
    // cropping size
    CGFloat croWidth = _croppingView.right - _croppingView.left;
    CGFloat croHeight = _croppingView.bottom - _croppingView.top;
    
    CGFloat width = croWidth * ratio;
    CGFloat height = croHeight * ratio;
    
    if (self.currImage != nil)
    {
        CGRect CropRect = CGRectMake(left, top, width, height);
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([self.currImage CGImage], CropRect);
        
        self.currImage = [UIImage imageWithCGImage:imageRef];
        
        CGImageRelease(imageRef);
        
        self.imageView.image = _currImage;
        
        //////////////////////////////////////////////
        //
        // NOTE: I am not saving the new image yet.
        // You can UNDO by swipping back.
        //
        //////////////////////////////////////////////
    }
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
