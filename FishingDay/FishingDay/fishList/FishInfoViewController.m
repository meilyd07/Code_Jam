//
//  FishInfoViewController.m
//  FishingDay
//
//  Created by Иван on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "FishInfoViewController.h"
#import "FishListViewController.h"

@interface FishInfoViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *fishImageViiew;
@property (strong, nonatomic) IBOutlet UILabel *fishNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *fishMaxLabel;
@property (strong, nonatomic) IBOutlet UILabel *fishMinLabel;

@end

@implementation FishInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Image";
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.image) {
        self.image = [UIImage imageNamed:@"fish_food"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageChanged:) name:self.imageURL object:nil];
    }
    [self setupImageView];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setupImageView {
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    [self.view addSubview:imageView];
    self.fishImageViiew = imageView;
    self.fishImageViiew.translatesAutoresizingMaskIntoConstraints = NO;
    self.fishImageViiew.contentMode = UIViewContentModeScaleAspectFit;
    [NSLayoutConstraint activateConstraints:@[[self.fishImageViiew.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
                                              [self.fishImageViiew.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10],
                                              [self.fishImageViiew.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:10],
                                              [self.fishImageViiew.heightAnchor constraintEqualToConstant:200],
                                              ]];
    
    
    //UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
   // self.fishNameLabel = lab;
    self.fishNameLabel.text = self.fish.nameFish;
    self.fishNameLabel.textColor = [UIColor blackColor];
    
    NSString *str = self.fishNameLabel.text;
   // self.fishNameLabel.text = [self.fish.minTemperature stringValue];
   // self.fishNameLabel.text = [self.fish.maxTemperature stringValue];
    
    
    
    
}

- (void)imageChanged:(NSNotification *)notification {
    if (![[notification.userInfo objectForKey:key2] boolValue]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.image = [notification.userInfo objectForKey:key1];
    self.fishImageViiew.image = self.image;
}

@end
