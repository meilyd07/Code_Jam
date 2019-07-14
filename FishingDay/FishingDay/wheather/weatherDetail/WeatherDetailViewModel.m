//
//  WeatherDetailViewModel.m
//  FishingDay
//
//  Created by Hanna Rybakova on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "WeatherDetailViewModel.h"
#import "WeatherService.h"

@implementation WeatherDetailViewModel
- (id)initWithMark:(Mark *)mark {
    self = [super init];
    if (self) {
        self.mark = mark;
    }
    return self;
}

-(void)getWeatherData:(void(^)(void))getCompletion {
    NSString *longitude = [[NSString alloc] initWithFormat:@"%f", self.mark.location.longitude];
    NSString *latitude = [[NSString alloc] initWithFormat:@"%f", self.mark.location.latitude];
    [WeatherService.sharedInstance getWeatherForLongitude:longitude latitude:latitude completionHandler:
     ^(NSData *data, NSURLResponse *response, NSError *error) {
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSLog(@"%@", json);
         getCompletion();
     }];
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
