//
//  MarkViewController.m
//  FishingDay
//
//  Created by Liubou Sakalouskaya on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "MarkViewController.h"

NSString * const markChangedNotification = @"markChangedNotification";

@interface MarkViewController ()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailsTextField;

@end

@implementation MarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoImageView.image = self.mark.photo;
    self.titleTextField.text = self.mark.title;
    self.detailsTextField.text = self.mark.details;
    [self.saveButton addTarget:self action:@selector(onSaveButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onSaveButton {
    self.mark.title = self.titleTextField.text;
    self.mark.details = self.detailsTextField.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:markChangedNotification object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
