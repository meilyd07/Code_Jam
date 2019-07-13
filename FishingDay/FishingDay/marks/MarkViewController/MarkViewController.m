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

@interface MarkViewController ()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailsTextField;

@end

@implementation MarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.mark) {
        self.photoImageView.image = self.mark.photo;
        self.titleTextField.text = self.mark.title;
        self.detailsTextField.text = self.mark.details;
        //set location from mark
    } else {
        self.mark = [Mark new];
        //set current location
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
        self.mark.photo = [UIImage imageNamed:@"fish_food"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:markChangedNotification object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
