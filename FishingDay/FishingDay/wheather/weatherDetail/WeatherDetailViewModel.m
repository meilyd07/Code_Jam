//
//  WeatherDetailViewModel.m
//  FishingDay
//
//  Created by Hanna Rybakova on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "WeatherDetailViewModel.h"

@implementation WeatherDetailViewModel
- (id)initWithMark:(Mark *)mark {
    self = [super init];
    if (self) {
        self.mark = mark;
    }
    return self;
}

-(void)getWeatherData{
    //dounload from internet
}

-(NSString *)getWindDirectionValue {
    return @"76";
}

-(NSString *)getWindSpeedValue {
    return @"15";
}

-(NSString *)getTemperatureValue {
    return @"45";
}

-(NSString *)getMinTemperatureValue {
    return @"77";
}

-(NSString *)getMaxTemperatureValue {
    return @"55";
}

-(NSString *)getAtmosphericPressureValue {
    return @"700";
}

-(NSString *)getHumidityValue {
    return @"67";
}
@end
