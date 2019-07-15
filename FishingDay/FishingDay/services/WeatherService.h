//
//  WeatherService.h
//  FishingDay
//
//  Created by Hanna Rybakova on 7/15/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherService : NSObject
+ (WeatherService *) sharedInstance;
-(void)getWeatherForLongitude:(NSString *)longitude latitude:(NSString *)latitude completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
@end
