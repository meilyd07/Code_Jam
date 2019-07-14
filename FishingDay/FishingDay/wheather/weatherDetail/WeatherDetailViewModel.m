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
@end
