
//
//  PTMainViewController.m
//  PegasusTest
//
//  Created by Jaroslaw Szymczyk on 11/1/14.
//  Copyright (c) 2014 Jaroslaw Szymczyk. All rights reserved.
//

#import "PTMainViewController.h"
#import "PTDocument.h"
#import "PTUtilities.h"

@interface PTMainViewController ()

//@property (nonatomic, strong) PTDocument *currDocument;
@property (strong, nonatomic) IBOutlet UITextField *docTitle;

@end

@implementation PTMainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (_appDelegate.scannedDocuments == nil) {
        _appDelegate.scannedDocuments = [[NSMutableArray alloc] init];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [PTUtilities archiveScannedDocs:_appDelegate.scannedDocuments];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        if (_appDelegate.myDocument == nil) {
            _appDelegate.myDocument = [_appDelegate.scannedDocuments lastObject];
        }
        
//        _flipsideView.myDocument = _appDelegate.myDocument;
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
    _appDelegate.myDocument.title = _docTitle.text;
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss controller
    [picker dismissViewControllerAnimated:YES completion:nil];
    
//    //Crop the image to a square
//    CGSize imageSize = image.size;
//    CGFloat width = imageSize.width;
//    CGFloat height = imageSize.height;
//    if (width != height) {
//        CGFloat newDimension = MIN(width, height);
//        CGFloat widthOffset = (width - newDimension) / 2;
//        CGFloat heightOffset = (height - newDimension) / 2;
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.);
//        [image drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
//                 blendMode:kCGBlendModeCopy
//                     alpha:1.];
//        image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        image = [self resizeImage:image newSize:CGSizeMake(width / 3, height / 3)];
//    }
    
    
    // Upload image
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    
    _appDelegate.myDocument.imageData = imageData;
    _appDelegate.myDocument.docSize = CGSizeMake(image.size.width, image.size.height);
    
    [_appDelegate.scannedDocuments addObject:_appDelegate.myDocument];
}

@end
