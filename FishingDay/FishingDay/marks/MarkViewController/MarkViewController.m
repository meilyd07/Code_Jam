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
#import "UIView+AnimatedLines.h"
#import "FishModel.h"

NSString * const markChangedNotification = @"markChangedNotification";
NSString * const markAnnotationReuseId = @"markAnnotationReuseId";

@interface MarkViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *pickerTextField;
@property (weak, nonatomic) IBOutlet UIButton *addFishButton;
@property (weak, nonatomic) IBOutlet UIButton *removeFishButton;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *deletePhotoButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKPointAnnotation *annotation;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSMutableArray *selectedFishTypes;
@property (strong, nonatomic) NSMutableDictionary *fishTypes;
@property (copy, nonatomic) NSArray *keysForTypes;
@property (weak, nonatomic) UIPickerView *fishPicker;
@property (assign, nonatomic) BOOL isAddingFishType;

@end

@implementation MarkViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAddingFishType = YES;
    self.selectedFishTypes = [NSMutableArray array];
    [self fetchFishTypes];
    [self setupPickerView];
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    self.annotation = [MKPointAnnotation new];
    [self.mapView registerClass:[MKAnnotationView class] forAnnotationViewWithReuseIdentifier:markAnnotationReuseId];
    [self.mapView addAnnotation:self.annotation];
    [self setupMarkInfo];
    if (self.isCurrentLocation) {
        [self.mapView setCenterCoordinate:[self.currentLocation coordinate] animated:NO];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - IBActions

- (IBAction)onAddFishButton:(UIButton *)sender {
    self.isAddingFishType = YES;
    [self.fishPicker reloadAllComponents];
    [self.pickerTextField becomeFirstResponder];
}

- (IBAction)onRemoveFishButton:(UIButton *)sender {
    self.isAddingFishType = NO;
    [self.fishPicker reloadAllComponents];
    [self.pickerTextField becomeFirstResponder];
}

- (IBAction)onSaveButton:(UIButton *)sender {
    if (self.titleTextField.text.length == 0) {
        UIAlertController *noTitleAlert = [UIAlertController alertControllerWithTitle:@"Внимание!" message:@"Введите название метки" preferredStyle:UIAlertControllerStyleAlert];
        [noTitleAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:noTitleAlert animated:YES completion:nil];
        return;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    UIGraphicsBeginImageContext(view.frame.size);
    [[UIImage imageNamed:@"saveIcon"] drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    view.backgroundColor = [UIColor colorWithPatternImage:image];
    [self.view addSubview:view];
    [view animateLinesWithColor:[UIColor colorWithRed:4/256.0 green:104/256.0 blue:161/256.0 alpha:1].CGColor andLineWidth:8 startPoint:CGPointMake(100, -200) rollToStroke:0.25
             curveControlPoints:@[[LinesCurvePoints curvePoints:CGPointMake(-50, -2) point2:CGPointMake(60, 5)],[LinesCurvePoints curvePoints:CGPointMake(-60, 10) point2:CGPointMake(100, 5)]] animationDuration:1];
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        view.alpha = 0.0;
    } completion:nil];
    
    self.mark.title = self.titleTextField.text;
    self.mark.details = self.pickerTextField.text;
    self.mark.photo = self.photoImageView.image;
    self.mark.fishId = self.selectedFishTypes;
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

- (void)setupPickerView {
    UIPickerView *fishPicker = [UIPickerView new];
    UIToolbar *toolBar = [UIToolbar new];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Выбрать" style:UIBarButtonItemStylePlain target:self action:@selector(pickerViewDone)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Отмена" style:UIBarButtonItemStylePlain target:self action:@selector(pickerViewCancel)];
    toolBar.items = @[doneButton, space, cancelButton];
    self.pickerTextField.inputView = fishPicker;
    self.pickerTextField.inputAccessoryView = toolBar;
    [toolBar sizeToFit];
    self.fishPicker = fishPicker;
    self.fishPicker.delegate = self;
    self.fishPicker.dataSource = self;
    self.fishPicker.backgroundColor = [UIColor whiteColor];
}

- (void)fetchFishTypes {
    self.fishTypes = [NSMutableDictionary dictionary];
    NSData *fishData = [[NSUserDefaults standardUserDefaults] objectForKey:fishesDataKey];
    NSSet *classes = [NSSet setWithObjects:[NSArray class], [FishModel class], nil];
    NSArray *decodedFishInfo = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:fishData error:nil];
    for (FishModel *fish in decodedFishInfo) {
        [self.fishTypes addEntriesFromDictionary:@{fish.idFish: fish.nameFish}];
    }
    self.keysForTypes = self.fishTypes.allKeys;
}

- (void)setupMarkInfo {
    if (!self.mark) {
        self.mark = [Mark new];
        self.mapView.scrollEnabled = NO;
        self.mapView.zoomEnabled = NO;
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
    self.pickerTextField.text = self.mark.details;
    self.selectedFishTypes = [NSMutableArray arrayWithArray:self.mark.fishId];
    [self updateFishTypesButtons];
    if (self.mark.photo) {
        [self.photoButton setTitle:@"Изменить фото" forState:UIControlStateNormal];
        self.deletePhotoButton.hidden = NO;
        self.photoImageView.hidden = NO;
        self.photoImageView.image = self.mark.photo;
    }
}

- (void)updateFishTypesButtons {
    if (self.selectedFishTypes.count == 0) {
        self.removeFishButton.enabled = NO;
        self.addFishButton.enabled = YES;
    } else if (self.selectedFishTypes.count == self.fishTypes.allKeys.count) {
        self.removeFishButton.enabled = YES;
        self.addFishButton.enabled = NO;
    } else {
        self.removeFishButton.enabled = YES;
        self.addFishButton.enabled = YES;
    }
}

- (void)pickerViewDone {
    NSInteger row = [self.fishPicker selectedRowInComponent:0];
    if (self.isAddingFishType) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", self.selectedFishTypes];
        NSArray *availableTypes = [self.keysForTypes filteredArrayUsingPredicate:predicate];
        NSNumber *key = availableTypes[row];
        [self.selectedFishTypes addObject:key];
    } else {
        [self.selectedFishTypes removeObjectAtIndex:row];
    }
    NSMutableArray *allTypes = [NSMutableArray array];
    [self.fishTypes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([self.selectedFishTypes containsObject:key]) {
            [allTypes addObject:obj];
        }
    }];
    self.pickerTextField.text = [allTypes componentsJoinedByString:@", "];
    self.isAddingFishType = YES;
    [self.pickerTextField resignFirstResponder];
    [self updateFishTypesButtons];
}

- (void)pickerViewCancel {
    self.isAddingFishType = YES;
    [self.pickerTextField resignFirstResponder];
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
    self.currentLocation = location;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.pickerTextField]) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.pickerTextField]) {
        if (self.isAddingFishType && self.selectedFishTypes.count == self.keysForTypes.count) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - MKMapViewDelegate

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:markAnnotationReuseId];
    view.annotation = annotation;
    view.image = [UIImage imageNamed:@"pin"];
    return view;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.isAddingFishType) {
        return self.keysForTypes.count - self.selectedFishTypes.count;
    } else {
        return self.selectedFishTypes.count;
    }
    return self.fishTypes.allKeys.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.isAddingFishType) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", self.selectedFishTypes];
        NSArray *availableTypes = [self.keysForTypes filteredArrayUsingPredicate:predicate];
        NSNumber *key = availableTypes[row];
        return self.fishTypes[key];
    } else {
        NSNumber *key = self.selectedFishTypes[row];
        return self.fishTypes[key];
    }
}

@end
