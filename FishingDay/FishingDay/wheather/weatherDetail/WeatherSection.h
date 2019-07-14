//
//  WeatherSection.h
//  FishingDay
//
//  Created by Hanna Rybakova on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <Foundation/Foundation.h>

enum WeatherSectionType:NSUInteger {
    temperatureSection,
    pressureAndHumiditySection,
    windSection
};

enum WeatherItem:NSUInteger {
    temperature,
    pressure,
    humidity,
    tempMin,
    tempMax,
    windSpeed,
    windDeg
};

@interface WeatherSection : NSObject
@property(assign, nonatomic) enum WeatherSectionType type;
@property(strong, nonatomic) NSArray* items;
- (id)init:(enum WeatherSectionType)type items:(NSArray *) items;
@end
