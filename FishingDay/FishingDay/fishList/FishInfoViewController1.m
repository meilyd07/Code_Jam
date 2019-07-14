//
//  ImageViewController.m
//  FishingDay
//
//  Created by Иван on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "FishInfoViewController1.h"
#import "FishListViewController.h"


@interface FishInfoViewController1 ()

@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation FishInfoViewController1

#pragma mark - Lifecycle

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

#pragma mark - Private

- (void)setupImageView {

    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [NSLayoutConstraint activateConstraints:@[[self.imageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
                                              [self.imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10],
                                              [self.imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:10],
                                              [self.imageView.heightAnchor constraintEqualToConstant:200],
                                              ]];
    
    
    
    
    
}

#pragma mark - Notifications

- (void)imageChanged:(NSNotification *)notification {
    if (![[notification.userInfo objectForKey:key2] boolValue]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.image = [notification.userInfo objectForKey:key1];
    self.imageView.image = self.image;
    
    
    
    
}

@end
