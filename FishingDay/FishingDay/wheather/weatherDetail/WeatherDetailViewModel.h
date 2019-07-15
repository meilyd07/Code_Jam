//
//  WeatherDetailViewModel.h
//  FishingDay
//
//  Created by Hanna Rybakova on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mark.h"

@interface WeatherDetailViewModel : NSObject
- (id)initWithMark:(Mark *)mark;
-(NSString *)getWindDirectionValue;
-(NSString *)getWindSpeedValue;
-(NSString *)getTemperatureValue;
-(NSString *)getMinTemperatureValue;
-(NSString *)getMaxTemperatureValue;
-(NSString *)getAtmosphericPressureValue;
-(NSString *)getHumidityValue;
-(void)getWeatherData:(void(^)(void))getCompletion;
@end

