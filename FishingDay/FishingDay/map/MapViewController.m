//
//  MapViewController.m
//  FishingDay
//  Created by Hanna Rybakova on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CLLocationManager.h>

#import "Mark.h"
#import "FishModel.h"
#import "MapViewController.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>
@property(strong, nonatomic) MKMapView *mapView;
@property(strong, nonatomic) NSMutableArray *marks;

@property(strong, nonatomic) CLLocationManager *locationManager;
@end

NSString * const annotationReuseId = @"annotation";

@implementation MapViewController

#pragma mark - Lifecycle

- (void)loadView {
    [super loadView];
    
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
    [self.mapView registerClass:[MKAnnotationView class] forAnnotationViewWithReuseIdentifier:annotationReuseId];
    [self zoomMap:self.mapView byDelta:0.00003f];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.mapView addGestureRecognizer:tapGesture];

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

#pragma mark - <MKMapViewDelegate>

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationReuseId];
    
    UIImage *image = [UIImage imageNamed:@"pin"];
    view.annotation = annotation;
    view.image = image;
    view.canShowCallout = YES;
    
    if (![view gestureRecognizers]) {
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPressGesture.minimumPressDuration = 0.5f;
        longPressGesture.delegate = self;
        
        [view addGestureRecognizer:longPressGesture];
    }
    
    return view;
}

#pragma mark - Touch Handlers

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]
        && [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

- (void)handleLongPress:(UITapGestureRecognizer *)longTapGesture {
    if (longTapGesture.state == UIGestureRecognizerStateEnded) {

        CGPoint point = [longTapGesture locationInView:self.mapView];
        UIView *view = [self.mapView hitTest:point withEvent:nil];
        
        if ([view isKindOfClass:[MKAnnotationView class]]) {
            MKAnnotationView *annotationView = (MKAnnotationView *)view;
            
            Mark *mark;
            int index = 0;
            
            for (index; index < [self.marks count]; index++) {
                Mark *currentMark = self.marks[index];
                if ([self isAnnotation:annotationView.annotation equalToMark:currentMark]) {
                    mark = currentMark;
                    break;
                }
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to delete this Mark?"
                                                                           message:[NSString stringWithFormat:@"Title: %@", mark.title]
                                                                    preferredStyle:UIAlertControllerStyleAlert];

            NSMutableArray __weak *marks = self.marks;
            __block MapViewController *safeSelf = self;

            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Delete"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                           [marks removeObjectAtIndex:index];
                                                           [safeSelf saveData];
                                                       }];

            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                           handler:nil];

            [alert addAction:ok];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    CGPoint point = [tapGesture locationInView:self.mapView];
    
    UIView *view = [self.mapView hitTest:point withEvent:nil];
    
    if ([view isKindOfClass:[MKAnnotationView class]]) {
        NSLog(@"handleTap");
    } else {
        CLLocationCoordinate2D coordingate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add mark with Title: "
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        NSMutableArray __weak *marks = self.marks;
        __block MapViewController *safeSelf = self;
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Add"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       NSString *titleText = alert.textFields[0].text;
                                                       
                                                       if (titleText.length) {
                                                           Mark *mark = [[Mark alloc] init];
                                                           mark.title = titleText;
                                                           mark.location = coordingate;
                                                           
                                                           [marks addObject:mark]; // Do I Really need safe?
                                                           [safeSelf saveData];
                                                       }
                                                   }];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:nil];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Title";
            textField.keyboardType = UIKeyboardTypeDefault;
        }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways
        || status == kCLAuthorizationStatusAuthorizedWhenInUse){
        
        CLLocation *location = [self.locationManager location];
        [self.mapView setCenterCoordinate:[location coordinate] animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocation *location = [self.locationManager location];
    [self.mapView setCenterCoordinate:[location coordinate] animated:YES];
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

- (BOOL)isAnnotation:(MKPointAnnotation *)annotation equalToMark:(Mark *)mark {
    if ([self isCoordinate:mark.location equalTo:annotation.coordinate]
        && [mark.title isEqualToString:annotation.title])
    {
        return YES;
    }
    return NO;
}

- (BOOL)isCoordinate:(CLLocationCoordinate2D)coordinate equalTo:(CLLocationCoordinate2D)anotherCoordinate {
    if (coordinate.longitude == anotherCoordinate.longitude
        && coordinate.latitude == anotherCoordinate.latitude)
    {
        return YES;
    }
    return NO;
}

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
