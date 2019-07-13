//
//  MapViewController.m
//  FishingDay
//  Created by Hanna Rybakova on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CLLocationManager.h>

#import "MapViewController.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property(strong, nonatomic) MKMapView *mapView;

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

- (void)updateCurrentPosition {
    CLLocation *location = [self.locationManager location];
    self.currentPosition = [location coordinate];
}

- (void)updateMap {
    CLLocationDegrees latitude = self.currentPosition.latitude;
    CLLocationDegrees longitude = self.currentPosition.longitude;
    
    NSLog(@"update map!");
}

#pragma mark - <MKMapViewDelegate>

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
//    scroll start
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//    scroll finished
}

- (void)mapViewDidChangeVisibleRegion:(MKMapView *)mapView {
//    on every! scroll
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    NSLog(@"mapView DID ADD ANNOTATION view");
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    NSLog(@"- ()... --> viewForAnnotation");
    return nil;
}

//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0);
//- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0);
//
//- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView NS_AVAILABLE(10_9, 4_0);
//- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView NS_AVAILABLE(10_9, 4_0);
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation NS_AVAILABLE(10_9, 4_0);
//- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error NS_AVAILABLE(10_9, 4_0);
//
//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
//   fromOldState:(MKAnnotationViewDragState)oldState NS_AVAILABLE(10_9, 4_0) __TVOS_PROHIBITED;
//
//- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
//
//- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(10_9, 7_0);
//- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray<MKOverlayRenderer *> *)renderers NS_AVAILABLE(10_9, 7_0);


#pragma mark - Touch Handlers

- (void)handleLongPress:(UITapGestureRecognizer *)longTapGesture {
    if (longTapGesture.state == UIGestureRecognizerStateEnded) {
        
        CGPoint point = [longTapGesture locationInView:self.mapView];
        CLLocationCoordinate2D coordingate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = coordingate;
        annotation.subtitle = @"sub";
        annotation.title = @"ola";
        
        [self.mapView addAnnotation:annotation];
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

#pragma mark - Utils

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

@end
