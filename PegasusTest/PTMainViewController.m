
//
//  PTMainViewController.m
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/1/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import "PTMainViewController.h"
#import "PTUtilities.h"

@interface PTMainViewController ()

@property (strong, nonatomic) IBOutlet UIButton *existingButton;

@end

@implementation PTMainViewController


- (BOOL) prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    _currIndex = -1;
    
    if ([_appDelegate.scannedDocuments count] > 0) {
        _currIndex = [_appDelegate.scannedDocuments count] - 1;
    }
    
    _existingButton.layer.cornerRadius = 8.0;
    _existingButton.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.currImage = [_appDelegate.scannedDocuments objectAtIndex:_currIndex];
    
    if (_currImage) {
        _imageView.image = _currImage;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateImage:(UIImage *)image atIndex:(NSInteger)index
{
    self.currIndex = index;
    self.currImage = image;
    
    if (_currImage) {
        _imageView.image = _currImage;
    }
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(PTFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        self.flipsideView = [segue destinationViewController];
        
        _flipsideView.delegate = self;
        _flipsideView.index = &_currIndex;
    }
}

- (IBAction)cameraButtonTapped:(id)sender
{
    // Check for camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES)
    {
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        
        // Show image picker
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)useExistingTapped:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES)
    {
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        // Show image picker
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == YES)
    {
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        // Show image picker
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)nameChanged:(id)sender
{
    //    _appDelegate.myDocument.title = _docTitle.text;
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss controller
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.currImage = image;

    if (_currImage) {
        _imageView.image = _currImage;
    }

    [_appDelegate.scannedDocuments addObject:image];
    
    _currIndex = [_appDelegate.scannedDocuments count] - 1;
}

#pragma mark -
#pragma mark BASIC FUNCTIONALITY

- (IBAction)convertToGray:(id)sender
{
    UIImage *bwImage = [self convertToGreyscale:_currImage];
    
    _imageView.image = bwImage;
    
    [_appDelegate.scannedDocuments addObject:bwImage];
    
    _currIndex = [_appDelegate.scannedDocuments count] - 1;
    
    [_appDelegate.scannedDocuments replaceObjectAtIndex:_currIndex withObject:bwImage];
}

- (IBAction)delete:(id)sender
{
    [_appDelegate.scannedDocuments removeObjectAtIndex:_currIndex];
    
    if (_currIndex > 0) {
        _currIndex--;
    }
    
    _imageView.image = [_appDelegate.scannedDocuments objectAtIndex:_currIndex];
}

- (IBAction)Email:(id)sender
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Pegasus Test"];
    
    NSArray *recipients = [NSArray arrayWithObjects:@"jszymczyk@comcast.net", nil];
    
    [picker setToRecipients:recipients];
    
    NSData *imageData = UIImageJPEGRepresentation(_currImage, 0.05f);
    
    [picker addAttachmentData:imageData mimeType:@"image/png" fileName:@"doc.png"];
    
    [self presentViewController:picker animated:YES completion:nil];
    
    picker = nil;
}

-(void)mailComposeController:(MFMailComposeViewController *)mailer
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError *)error
{
    [self becomeFirstResponder];
    [mailer dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -
#pragma mark convert to greyscale

- (UIImage *)convertToGreyscale:(UIImage *)i {
    
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    int colors = kGreen | kBlue | kRed;
    int m_width = i.size.width;
    int m_height = i.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
    
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
    
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        result[i*4]=0;
        int val=m_imageData[i];
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=val;
    }
    
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    free(m_imageData);
    
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
    
    return resultUIImage;
}

@end
