//
//  WeatherSection.h
//  FishingDay
//
//  Created by Hanna Rybakova on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <Foundation/Foundation.h>

enum WeatherSectionType:NSUInteger {
    weatherSection,
    fishSection
};

enum WeatherItem:NSUInteger {
    temperature,
    pressure,
    humidity,
    tempMin,
    tempMax,
    windSpeed,
    windDeg,
    fishesList
};

@interface WeatherSection : NSObject
@property(assign, nonatomic) enum WeatherSectionType type;
@property(strong, nonatomic) NSArray* items;
- (id)init:(enum WeatherSectionType)type items:(NSArray *) items;
@end
