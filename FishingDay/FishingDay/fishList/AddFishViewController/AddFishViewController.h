//
//  AddFishViewController.h
//  FishingDay
//
//  Created by Иван on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FishModel.h"

NS_ASSUME_NONNULL_BEGIN
extern NSString * const fishChangedNotification;
@interface AddFishViewController : UIViewController

@property (assign, nonatomic) NSInteger row;
@property (strong, nonatomic) FishModel *fish;

@end

NS_ASSUME_NONNULL_END
