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

#pragma mark -
#pragma mark - Basic functionality

- (IBAction)done:(id)sender
{
    [_appDelegate.scannedDocuments replaceObjectAtIndex:*_index withObject:_currImage];
    
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)crop:(id)sender
{
    UIImage *fixedImage = [self scaleAndRotateImage:_currImage];
    
    // image size
    CGFloat imgWidth = fixedImage.size.width;
    CGFloat imgHeight = fixedImage.size.height;
    
    // view size
    CGFloat viewWidth = _imageView.frame.size.width;
    CGFloat viewHeight = _imageView.frame.size.height;
    
    CGFloat ratio = MAX(imgWidth / viewWidth, imgHeight / viewHeight);

    CGFloat marginX = (viewWidth - imgWidth / ratio) / 2;
    CGFloat marginY = (viewHeight - imgHeight / ratio) / 2;
    
    // cropping origin
    CGFloat left = (_croppingView.left - marginX) * ratio;
    CGFloat top = (_croppingView.top - marginY) * ratio;
    
    // cropping size
    CGFloat width = (_croppingView.right - _croppingView.left) * ratio;
    CGFloat height = (_croppingView.bottom - _croppingView.top) * ratio;
    
    if (self.currImage != nil)
    {
        CGRect CropRect = CGRectMake(left, top, width, height); //(260, 60, 2700, 2400);
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([fixedImage CGImage], CropRect);
        
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

/////////////////////////////////////////////////////////
//
// CODE from STACKOVERFLOW
//
//----rotate image if picked from gallery or camera----//
//
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    
    NSLog(@"scaleAndRotateImage");
    static int kMaxResolution = 640; // this is the maximum resolution that you want to set for an image.
    
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        } else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
        case UIImageOrientationUp:
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException
                        format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
                       CGRectMake(0, 0, width, height), imgRef);
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return returnImage;
}

@end
