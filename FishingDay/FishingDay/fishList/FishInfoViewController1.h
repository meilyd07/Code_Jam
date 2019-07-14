//
//  ImageViewController.h
//  FishingDay
//
//  Created by Иван on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FishModel.h"

@interface FishInfoViewController1 : UIViewController

@property (strong,nonatomic) FishModel *fish;

@property (copy, nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImage *image;
@property(strong,nonatomic) UILabel *descriptionLabel;
@property(strong,nonatomic) UILabel *nameLabel;
@property(strong,nonatomic) UILabel *minLabel;
@property(strong,nonatomic) UILabel *maxLabel;

- (void)imageChanged:(NSNotification *)notification;

@end
