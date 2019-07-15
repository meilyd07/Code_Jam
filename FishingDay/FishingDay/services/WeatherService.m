//
//  WeatherService.m
//  FishingDay
//
//  Created by Hanna Rybakova on 7/15/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "WeatherService.h"

@implementation WeatherService
static WeatherService *shared = nil;

+ (WeatherService *) sharedInstance
{
    if (shared == nil)
    {
        shared = [[WeatherService alloc] init];
    }
    return shared;
}

-(void)getWeatherForLongitude:(NSString *)longitude latitude:(NSString *)latitude completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?lat=%@&units=metric&appid=c3a585d3bd51f4d6d275d1cf13120ce0&lon=%@&cnt=8", latitude, longitude]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:completionHandler];
    [dataTask resume];
}

@end
