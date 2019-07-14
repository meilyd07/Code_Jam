//
//  WeatherDetailViewController.h
//  FishingDay
//
//  Created by Hanna Rybakova on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDetailViewModel.h"
#import "WeatherSection.h"

@interface WeatherDetailViewController : UIViewController
@property(strong, nonatomic) WeatherDetailViewModel *viewModel;
@end
