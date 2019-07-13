//
//  WeatherViewController.h
//  FishingDay
//
//  Created by Hanna Rybakova on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherViewModel.h"

@interface WeatherViewController : UIViewController
@property(strong, nonatomic) WeatherViewModel *viewModel;
@end
