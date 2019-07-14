//
//  MapViewController.m
//  FishingDay
//  Created by Hanna Rybakova on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CLLocationManager.h>

#import "Mark.h"
#import "MapViewController.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>
@property(strong, nonatomic) MKMapView *mapView;
@property(strong, nonatomic) NSMutableArray *marks;

@property(strong, nonatomic) CLLocationManager *locationManager;
@property(assign, nonatomic) CLLocationCoordinate2D currentPosition;
@end

@implementation MapViewController

#pragma mark - Lifecycle

- (void)loadView {
    [super loadView];
    
    self.tabBarController.tabBar.translucent = YES;
    
    [self initLocationManager];
    [self initMap];
    [self initMarksWithSubscription];
    
    if ([CLLocationManager locationServicesEnabled]){
        CLAuthorizationStatus permissionStatus = [CLLocationManager authorizationStatus];
        
        if (permissionStatus == kCLAuthorizationStatusNotDetermined){
            [self.locationManager requestWhenInUseAuthorization];
        } else if (permissionStatus == kCLAuthorizationStatusDenied) {
            [self showAlert];
        }
        
    } else {
        [self showAlert];
    }
}

- (void)dealloc {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObserver:self forKeyPath:marksDataKey];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

- (void)initLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
}

- (void)initMap {
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapView.delegate = self;
    
    [self zoomMap:self.mapView byDelta:0.00003f];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGesture.minimumPressDuration = 0.5f;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapGesture shouldRequireFailureOfGestureRecognizer:longPressGesture];
    
    [self.mapView addGestureRecognizer:tapGesture];
    [self.mapView addGestureRecognizer:longPressGesture];

    [self.view addSubview:self.mapView];
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.mapView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                              [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
                                              ]];
}

- (void)initMarksWithSubscription {
    [self addObserver:self forKeyPath:@"marks" options:NSKeyValueObservingOptionNew context:@selector(drawAnnotations)];
    
    NSData *marksData = [[NSUserDefaults standardUserDefaults] objectForKey:marksDataKey];
    
    if (marksData) {
        NSSet *classes = [NSSet setWithObjects:[NSArray class], [Mark class], nil];
        NSArray *decodedMarks = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:marksData error:nil];
        self.marks = [decodedMarks mutableCopy];
    } else {
        self.marks = [NSMutableArray array];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults addObserver:self
               forKeyPath:marksDataKey
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
}

- (void)updateMarks {
    NSArray *anottions = [self.mapView annotations];
    [self.mapView removeAnnotations:anottions];
    
    NSData *marksData = [[NSUserDefaults standardUserDefaults] objectForKey:marksDataKey];
    
    NSSet *classes = [NSSet setWithObjects:[NSArray class], [Mark class], nil];
    NSArray *decodedMarks = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:marksData error:nil];
    self.marks = [decodedMarks mutableCopy];
}

- (void)drawAnnotations {
    for (Mark *mark in self.marks) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = mark.location;
        annotation.subtitle = mark.details;
        annotation.title = mark.title;

        [self.mapView addAnnotation:annotation];
    }
}

- (void)updateCurrentPosition {
    CLLocation *location = [self.locationManager location];
    self.currentPosition = [location coordinate];
}

- (void)updateMap {
    self.mapView.centerCoordinate = self.currentPosition;
}

#pragma mark - <MKMapViewDelegate>

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//    scroll finished
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    NSLog(@"mapView DID ADD ANNOTATION view");
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    NSLog(@"- ()... --> viewForAnnotation");
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
}

#pragma mark - Touch Handlers

- (void)handleLongPress:(UITapGestureRecognizer *)longTapGesture {
    if (longTapGesture.state == UIGestureRecognizerStateEnded) {

        CGPoint point = [longTapGesture locationInView:self.mapView];
        CLLocationCoordinate2D coordingate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Mark"
                                                                       message:@"Write title and details: "
                                                                preferredStyle:UIAlertControllerStyleAlert];

        NSMutableArray __weak *marks = self.marks;
        __block MapViewController *safeSelf = self;
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Add"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                           Mark *mark = [[Mark alloc] init];
                                                           mark.title = alert.textFields[0].text;
                                                           mark.details = alert.textFields[1].text;
                                                           mark.location = coordingate;
                                                           
                                                           [marks addObject:mark]; // Do I Really need safe?
                                                           [safeSelf saveData];
                                                       }];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:nil];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Title";
            textField.keyboardType = UIKeyboardTypeDefault;
        }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Details";
            textField.keyboardType = UIKeyboardTypeDefault;
        }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
//    NSLog(@"Tap gesture");
}

#pragma mark - <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways
        || status == kCLAuthorizationStatusAuthorizedWhenInUse){
        
        [self updateCurrentPosition];
        [self updateMap];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:marksDataKey]) {
        [self updateMarks];
    }
    
    if (context == @selector(drawAnnotations)) {
        [self drawAnnotations];
    }
}

#pragma mark - Utils

- (void)saveData {
    NSData *marksData = [NSKeyedArchiver archivedDataWithRootObject:self.marks requiringSecureCoding:NO error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:marksData forKey:marksDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location Permission Denied"
                                                                   message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {}];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)zoomMap:(MKMapView*)mapView byDelta:(float)delta {
    MKCoordinateRegion region = mapView.region;
    
    MKCoordinateSpan span = mapView.region.span;
    span.latitudeDelta *= delta;
    span.longitudeDelta *= delta;
    
    region.span = span;
    [mapView setRegion:region animated:YES];
}

@end
