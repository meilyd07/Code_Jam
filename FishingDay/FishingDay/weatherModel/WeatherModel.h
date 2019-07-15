//
//  WeatherModel.h
//  FishingDay
//
//  Created by Hanna Rybakova on 7/15/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject
@property (strong, nonatomic) NSString *humidity;
@property (strong, nonatomic) NSString *pressure;
@property (strong, nonatomic) NSString *temperature;
@property (strong, nonatomic) NSString *tempMax;
@property (strong, nonatomic) NSString *tempMin;
@property (strong, nonatomic) NSString *speed;
@property (strong, nonatomic) NSString *dateString;
@end
