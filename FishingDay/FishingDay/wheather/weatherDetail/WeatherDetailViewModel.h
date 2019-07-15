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
-(NSString *)getWindSpeedValue:(NSInteger)row;
-(NSString *)getTemperatureValue:(NSInteger)row;
-(NSString *)getMinTemperatureValue:(NSInteger)row;
-(NSString *)getMaxTemperatureValue:(NSInteger)row;
-(NSString *)getAtmosphericPressureValue:(NSInteger)row;
-(NSString *)getHumidityValue:(NSInteger)row;
-(NSString *)getDateValue:(NSInteger)row;
-(void)getWeatherData:(void(^)(void))getCompletion;
@end

