//
//  MarkViewController.h
//  FishingDay
//
//  Created by Liubou Sakalouskaya on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mark.h"

extern NSString * const markChangedNotification;

@interface MarkViewController : UIViewController

@property (strong, nonatomic) Mark *mark;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) BOOL isCurrentLocation;

@end
