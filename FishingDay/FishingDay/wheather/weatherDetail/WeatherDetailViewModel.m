//
//  WeatherDetailViewModel.m
//  FishingDay
//
//  Created by Hanna Rybakova on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "WeatherDetailViewModel.h"
#import "WeatherService.h"
#import "WeatherModel.h"

@interface WeatherDetailViewModel()
@property (strong, nonatomic) Mark *mark;
@property (strong, nonatomic) NSMutableArray *weatherModelsArray;
@end

@implementation WeatherDetailViewModel
- (id)initWithMark:(Mark *)mark {
    self = [super init];
    if (self) {
        self.mark = mark;
    }
    return self;
}

-(void)getWeatherData:(void(^)(void))getCompletion {
    self.weatherModelsArray = [NSMutableArray new];
    NSString *longitude = [[NSString alloc] initWithFormat:@"%f", self.mark.location.longitude];
    NSString *latitude = [[NSString alloc] initWithFormat:@"%f", self.mark.location.latitude];
    [WeatherService.sharedInstance getWeatherForLongitude:longitude latitude:latitude completionHandler:
     ^(NSData *data, NSURLResponse *response, NSError *error) {
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         for (NSDictionary *list in [json objectForKey:@"list"]) {
             WeatherModel *weatherModel = [[WeatherModel alloc] init];
             NSDictionary *main = [list objectForKey:@"main"];
             NSDictionary *wind = [list objectForKey:@"wind"];
             NSString *dateString = [NSString stringWithFormat:@"%@", [list valueForKey:@"dt_txt"]];
             NSString *humidity = [NSString stringWithFormat:@"%@", [main valueForKey:@"humidity"]];
             NSString *pressure = [NSString stringWithFormat:@"%@", [main valueForKey:@"pressure"]];
             NSString *temperature = [NSString stringWithFormat:@"%@", [main valueForKey:@"temp"]];
             NSString *tempMax = [NSString stringWithFormat:@"%@", [main valueForKey:@"temp_max"]];
             NSString *tempMin = [NSString stringWithFormat:@"%@", [main valueForKey:@"temp_min"]];
             NSString *windSpeed = [NSString stringWithFormat:@"%@", [wind valueForKey:@"speed"]];
             weatherModel.dateString = dateString;
             weatherModel.humidity = humidity;
             weatherModel.pressure = pressure;
             weatherModel.temperature = temperature;
             weatherModel.tempMax = tempMax;
             weatherModel.tempMin = tempMin;
             weatherModel.speed = windSpeed;
             [self.weatherModelsArray addObject:weatherModel];
         }
         getCompletion();
     }];
}

-(NSString *)getDateValue:(NSInteger)row {
    return ((WeatherModel *)self.weatherModelsArray[row]).dateString;
}

-(NSString *)getWindSpeedValue:(NSInteger)row {
    return ((WeatherModel *)self.weatherModelsArray[row]).speed;
}

-(NSString *)getTemperatureValue:(NSInteger)row {
    return ((WeatherModel *)self.weatherModelsArray[row]).temperature;
}

-(NSString *)getMinTemperatureValue:(NSInteger)row {
    return ((WeatherModel *)self.weatherModelsArray[row]).tempMin;
}

-(NSString *)getMaxTemperatureValue:(NSInteger)row {
    return ((WeatherModel *)self.weatherModelsArray[row]).tempMax;
}

-(NSString *)getAtmosphericPressureValue:(NSInteger)row {
    return ((WeatherModel *)self.weatherModelsArray[row]).pressure;
}

-(NSString *)getHumidityValue:(NSInteger)row {
    return ((WeatherModel *)self.weatherModelsArray[row]).humidity;
}
@end
