//
//  WeatherSection.m
//  FishingDay
//
//  Created by Hanna Rybakova on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "WeatherSection.h"

@implementation WeatherSection

- (id)init:(enum WeatherSectionType)type items:(NSArray *) items {
    self = [super init];
    if (self) {
        self.type = type;
        self.items = items;
    }
    return self;
}
@end
