//
//  ImageViewController.h
//  FishingDay
//
//  Created by Иван on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FishInfoViewController : UIViewController

@property (copy, nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImage *image;
@property(strong,nonatomic) UILabel *descriptionLabel;

- (void)imageChanged:(NSNotification *)notification;

@end
