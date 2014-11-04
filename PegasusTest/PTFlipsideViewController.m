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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    if ([_appDelegate.scannedDocuments count] > 0)
    {
        // last document
        _index = [_appDelegate.scannedDocuments count] - 1;
        
//        self.currDocument = [_appDelegate.scannedDocuments objectAtIndex:_index];

//        UIImage *image = _currDocument.image;
//        UIImage *image = [UIImage imageNamed:@"cigars.png"];
        self.currImage = [_appDelegate.scannedDocuments objectAtIndex:_index];
        
        self.docView = [[UIImageView alloc] initWithImage:_currImage];
        
        CGRect frame = CGRectMake(0, 44, 320, 524);
        [_docView setFrame:frame];
        
        _docView.image = _currImage;
        
        [self.view addSubview:_docView];
        
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
    if (_index > 0) {
        _index--;
    }
    
//    self.currDocument = nil;
//    self.docView = nil;
    
    self.currImage = [_appDelegate.scannedDocuments objectAtIndex:_index];
    
//    UIImage *image = _currDocument.image;
//    UIImage *image = [UIImage imageNamed:@"hookah.png"];
    
    self.docView = [[UIImageView alloc] initWithImage:_currImage];
    
    CGRect frame = CGRectMake(0, 44, 320, 524);
    [_docView setFrame:frame];
    
    [_docView setImage:_currImage];
    
    [self.view addSubview:_docView];
    

//    if (_mode > 0) {
//        _mode--;
//        
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.5;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromLeft;
//        transition.delegate = self;
//        [self.view.layer addAnimation:transition forKey:nil];
//        
//        [_scrollView setContentOffset:_initialOffset];
//    }
//    
//    [self showMessage];
}

- (void)handleLeftSwipe:(UITapGestureRecognizer *)recognizer
{
    NSInteger last = [_appDelegate.scannedDocuments count] - 1;
    if (_index < last) {
        _index++;
    }
    
//    self.currDocument = nil;
    self.docView = nil;
    
    self.currImage = [_appDelegate.scannedDocuments objectAtIndex:_index];
    
//    UIImage *image = _currDocument.image;
//    UIImage *image = [UIImage imageNamed:@"ecigarettes.png"];
    
    self.docView = [[UIImageView alloc] initWithImage:_currImage];
    
    CGRect frame = CGRectMake(0, 44, 320, 524);
    [_docView setFrame:frame];
    
    [_docView setImage:_currImage];
    
    [self.view addSubview:_docView];
    

    
//    if (_index == LAST)
//    {
//        AppSpireSuccessViewController *success = [[AppSpireSuccessViewController alloc] initWithNibName:@"AppSpireSuccessViewController" bundle:nil];
//        
//        success.task = _task;
//        
//        [self.navigationController pushViewController:success animated:YES];
//        
//        [self.tabBarController.tabBar setHidden:YES];
//        
//        _pageControl.hidden = YES;
//        
//        self.pageControl = nil;
//        
//        _mode = CIGARS;
//    }
//    else
//    {
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.5;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromRight;
//        transition.delegate = self;
//        [self.view.layer addAnimation:transition forKey:nil];
//        
//        [_docView setContentOffset:_initialOffset];
//    }
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)crop:(id)sender
{
    
//    double ratio;
//    double delta;
//    CGPoint offset;

//    float oldWidth = abs(_appDelegate.myDocument.docSize.width);
//    float oldHeight = abs(_appDelegate.myDocument.docSize.height);
//  
//    
//    NSLog(@"OLD width:%f, height:%f", oldWidth, oldHeight);
//    
    
//    float newWidth = abs(_cropView.right - _cropView.left);
//    float newHeight = abs(_cropView.top - _cropView.bottom);
    
//
//    NSLog(@"NEW width:%f, height:%f", newWidth, newHeight);
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
//    UIImage *image = _currDocument.image;
    
    CGSize size = [_currImage size];
    
    
    UIImage *newImage = [self squareImageWithImage:_currImage scaledToSize:size];
    
//    _currDocument.imageData = UIImageJPEGRepresentation(newImage, 0.05f);
    [_docView setImage:newImage];
    
    [PTUtilities archiveScannedDocs:_appDelegate.scannedDocuments];
    
    return;
    
    
//    // Create rectangle that represents a cropped image
//    // from the middle of the existing image
//    CGRect clippedRect = CGRectMake(_cropView.left, _cropView.top, newWidth, newHeight);
//    
//    // Create bitmap image from original image data,
//    // using rectangle to specify desired crop area
//    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
//    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
//    
//    CGSize newSize = [newImage size];
//    
//    
//    //calculate scale factor and offset
//    if (newImage.size.width > newImage.size.height) {
//        ratio = newSize.width / newImage.size.width;
//        delta = (ratio*newImage.size.width - ratio*newImage.size.height);
//        offset = CGPointMake(delta/2, 0);
//    } else {
//        ratio = newSize.width / newImage.size.height;
//        delta = (ratio*newImage.size.height - ratio*newImage.size.width);
//        offset = CGPointMake(0, delta/2);
//    }
    
    
//    //make the final clipping rect based on the calculated values
//    CGRect clippedRect = CGRectMake(-offset.x, -offset.y,
//                                    (ratio * image.size.width) + delta,
//                                    (ratio * image.size.height) + delta);
    
    
    // Create bitmap image from original image data,
    
    // using rectangle to specify desired crop area
    
//    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
//    
//    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    
    
//    CGSize newSize = [newImage size];
//    
//    
    
//    float scaleX = size.width / newSize.width;
//    
//    float scaleY = size.height / newSize.height;
//    
//    
//    
//    newImage = [self resizeImage:image newSize:CGSizeMake(newSize.width*scaleX, newSize.height*scaleY)];
//    
//    
//    
//    CGImageRelease(imageRef);
//    
//    
//    
//    // Upload image
//    
//    _appDelegate.myDocument.imageData = UIImageJPEGRepresentation(newImage, 0.05f);
//    
//    
//    
//    //    [_docView setFrame:CGRectMake(-_cropView.left, -_cropView.top, oldWidth, oldHeight)];
//    
//    
//    
//    _docView.image = newImage;
    
}

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
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

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint touchLocation = [touch locationInView:_docView];
//    
//    if (CGPointEqualToPoint(_pt1, CGPointZero)) {
//        _pt1 = touchLocation;
//    }
//    else {
//        _pt2 = touchLocation;
//    }
//}
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesMoved:touches withEvent:event];
//    
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesEnded:touches withEvent:event];
//    
//}

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
