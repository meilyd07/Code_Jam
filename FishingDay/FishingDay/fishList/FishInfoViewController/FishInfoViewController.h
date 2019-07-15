//
//  FishInfoViewController.h
//  FishingDay
//
//  Created by Иван on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FishModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FishInfoViewController : UIViewController

@property (strong,nonatomic) FishModel *fish;
@property (copy, nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImage *image;



- (void)imageChanged:(NSNotification *)notification;
@end

NS_ASSUME_NONNULL_END
