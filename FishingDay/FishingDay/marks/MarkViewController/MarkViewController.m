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

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *deletePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailsTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation MarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    if (self.mark) {
        if (self.mark.photo) {
            [self.photoButton setTitle:@"Изменить фото" forState:UIControlStateNormal];
            self.deletePhotoButton.hidden = NO;
            self.photoImageView.hidden = NO;
            self.photoImageView.image = self.mark.photo;
        }
        self.titleTextField.text = self.mark.title;
        self.detailsTextField.text = self.mark.details;
    } else {
        self.mark = [Mark new];
        //self.mark.location = 
    }
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mark.location, MKCoordinateSpanMake(0.1, 0.1));
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = self.mark.location;
    [self.mapView addAnnotation:annotation];
    self.mapView.region = region;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)onSaveButton:(UIButton *)sender {
    if (self.titleTextField.text.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    self.mark.title = self.titleTextField.text;
    self.mark.details = self.detailsTextField.text;
    self.mark.photo = self.photoImageView.image;
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
        UIAlertController *noCameraAlert = [UIAlertController alertControllerWithTitle:@"Внимание!" message:@"Не удаётся найти камеру" preferredStyle:UIAlertControllerStyleAlert];
        [noCameraAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:noCameraAlert animated:YES completion:nil];
    }
}

- (void)openGallery {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.allowsEditing = NO;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        [self.photoButton setTitle:@"Изменить фото" forState:UIControlStateNormal];
        self.photoImageView.hidden = NO;
        self.deletePhotoButton.hidden = NO;
        self.photoImageView.image = image;
    }
}

- (IBAction)onDeletePhotoButton:(UIButton *)sender {
    self.photoImageView.image = nil;
    self.photoImageView.hidden = YES;
    self.deletePhotoButton.hidden = YES;
    [self.photoButton setTitle:@"Добавить фото" forState:UIControlStateNormal];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    self.scrollViewBottomConstraint.constant = keyboardFrame.size.height;
    UIViewAnimationOptions animationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration delay:0.0 options:animationCurve animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.scrollViewBottomConstraint.constant = 15;
    UIViewAnimationOptions animationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration delay:0.0 options:animationCurve animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
