//
//  MarkViewController.m
//  FishingDay
//
//  Created by Liubou Sakalouskaya on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "MarkViewController.h"
#import <MapKit/MapKit.h>

NSString * const markChangedNotification = @"markChangedNotification";

@interface MarkViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailsTextField;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation MarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.mark) {
        self.addPhotoButton.hidden = YES;
        self.photoImageView.image = self.mark.photo;
        self.titleTextField.text = self.mark.title;
        self.detailsTextField.text = self.mark.details;
        //set location from mark
    } else {
        self.photoImageView.hidden = YES;
        self.mark = [Mark new];
        //set current location
        self.imagePickerController = [UIImagePickerController new];
    }
    [self.saveButton addTarget:self action:@selector(onSaveButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onSaveButton {
    if (!self.titleTextField.text) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.mark.title = self.titleTextField.text;
    self.mark.details = self.detailsTextField.text;
    if (!self.mark.photo) {
        self.mark.photo = [UIImage imageNamed:@"noPhoto"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:markChangedNotification object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddPhotoButton:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose Image" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openGallery];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        alert.popoverPresentationController.sourceView = sender;
        alert.popoverPresentationController.sourceRect = sender.bounds;
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerController.allowsEditing = NO;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        UIAlertController *noCameraAlert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"You don't have camera" preferredStyle:UIAlertControllerStyleAlert];
        [noCameraAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:noCameraAlert animated:YES completion:nil];
    }
}

- (void)openGallery {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.allowsEditing = NO;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

@end
