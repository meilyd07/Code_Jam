//
//  MapViewController.m
//  FishingDay
//
//  Created by Hanna Rybakova on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CLLocationManager.h>
#import <MapKit/MapKit.h>

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property(strong, nonatomic) MKMapView *mapView;

@property(strong, nonatomic) CLLocationManager *locationManager;
@property(assign, nonatomic) CLLocationCoordinate2D currentPosition;
@end

@implementation MapViewController

#pragma mark - Lifecycle

- (void)loadView {
    [super loadView];
    
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
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UITabBar *tabBar = self.tabBarController.tabBar;
    
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    
    NSInteger navBarHeight = CGRectGetHeight(statusBarFrame) + CGRectGetHeight(navBar.frame);
    NSInteger tabBarHeight = CGRectGetHeight(tabBar.frame);
    

    [self.view addSubview:self.mapView];
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:navBarHeight],
                                              [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                              [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-tabBarHeight],
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
    NSLog(@"region will change!");
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"region did change!");
}

- (void)mapViewDidChangeVisibleRegion:(MKMapView *)mapView {
    NSLog(@"View did change visible Region!");
}
//
//- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView;
//- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView;
//- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error;
//
//- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView NS_AVAILABLE(10_9, 7_0);
//- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered NS_AVAILABLE(10_9, 7_0);
//
//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views;
//- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
//
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
