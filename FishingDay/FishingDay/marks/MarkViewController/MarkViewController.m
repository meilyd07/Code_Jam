//
//  MarkViewController.m
//  FishingDay
//
//  Created by Liubou Sakalouskaya on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "MarkViewController.h"
#import <MapKit/MapKit.h>
#import <AVKit/AVKit.h>
#import <Photos/Photos.h>

NSString * const markChangedNotification = @"markChangedNotification";
NSString * const markAnnotationReuseId = @"markAnnotationReuseId";

@interface MarkViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *deletePhotoButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailsTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKPointAnnotation *annotation;

@end

@implementation MarkViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    self.annotation = [MKPointAnnotation new];
    [self.mapView registerClass:[MKAnnotationView class] forAnnotationViewWithReuseIdentifier:markAnnotationReuseId];
    [self.mapView addAnnotation:self.annotation];
    [self setupMarkInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - IBActions

- (IBAction)onSaveButton:(UIButton *)sender {
    if (self.titleTextField.text.length == 0) {
        UIAlertController *noTitleAlert = [UIAlertController alertControllerWithTitle:@"Внимание!" message:@"Введите название метки" preferredStyle:UIAlertControllerStyleAlert];
        [noTitleAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:noTitleAlert animated:YES completion:nil];
        return;
    }
    self.mark.title = self.titleTextField.text;
    self.mark.details = self.detailsTextField.text;
    self.mark.photo = self.photoImageView.image;
    [[NSNotificationCenter defaultCenter] postNotificationName:markChangedNotification object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddPhotoButton:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Добавить фото" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Камера" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Галерея" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openGallery];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil]];
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        alert.popoverPresentationController.sourceView = sender;
        alert.popoverPresentationController.sourceRect = sender.bounds;
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onDeletePhotoButton:(UIButton *)sender {
    self.photoImageView.image = nil;
    self.photoImageView.hidden = YES;
    self.deletePhotoButton.hidden = YES;
    [self.photoButton setTitle:@"Добавить фото" forState:UIControlStateNormal];
}

#pragma mark - Private

- (void)setupMarkInfo {
    if (!self.mark) {
        self.mark = [Mark new];
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        CLAuthorizationStatus permissionStatus = [CLLocationManager authorizationStatus];
        if (permissionStatus == kCLAuthorizationStatusNotDetermined){
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
        return;
    }
    self.annotation.coordinate = self.mark.location;
    self.mapView.region = MKCoordinateRegionMake(self.mark.location, MKCoordinateSpanMake(0.1, 0.1));
    self.titleTextField.text = self.mark.title;
    self.detailsTextField.text = self.mark.details;
    if (self.mark.photo) {
        [self.photoButton setTitle:@"Изменить фото" forState:UIControlStateNormal];
        self.deletePhotoButton.hidden = NO;
        self.photoImageView.hidden = NO;
        self.photoImageView.image = self.mark.photo;
    }
}

- (void)openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusDenied)  {
            UIAlertController *noCameraAlert = [UIAlertController alertControllerWithTitle:@"Внимание!" message:@"Предоставьте доступ к камере в настройках телефона" preferredStyle:UIAlertControllerStyleAlert];
            [noCameraAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:noCameraAlert animated:YES completion:nil];
        } else {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.allowsEditing = NO;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }
    } else {
        UIAlertController *noCameraAlert = [UIAlertController alertControllerWithTitle:@"Внимание!" message:@"Камера недоступна" preferredStyle:UIAlertControllerStyleAlert];
        [noCameraAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:noCameraAlert animated:YES completion:nil];
    }
}

- (void)openGallery {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied)  {
        UIAlertController *noPhotosAlert = [UIAlertController alertControllerWithTitle:@"Внимание!" message:@"Предоставьте доступ к фото в настройках телефона" preferredStyle:UIAlertControllerStyleAlert];
        [noPhotosAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:noPhotosAlert animated:YES completion:nil];
    } else {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerController.allowsEditing = NO;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    self.mark.location = location.coordinate;
    self.annotation.coordinate = self.mark.location;
    self.mapView.region = MKCoordinateRegionMake(self.mark.location, MKCoordinateSpanMake(0.1, 0.1));
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied) {
        UIAlertController *locationDenied = [UIAlertController alertControllerWithTitle:@"Внимание!" message:@"Невозможно создать метку: включите доступ к местоположению в настройках телефона" preferredStyle:UIAlertControllerStyleAlert];
        [locationDenied addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        } ]];
        [self presentViewController:locationDenied animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

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

#pragma mark - Keyboard Notifications

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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - MKMapViewDelegate

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:markAnnotationReuseId];
    view.annotation = annotation;
    view.image = [UIImage imageNamed:@"pin"];
    return view;
}

@end
