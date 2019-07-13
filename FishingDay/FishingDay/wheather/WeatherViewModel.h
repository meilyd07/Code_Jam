//
//  WeatherViewModel.h
//  FishingDay
//
//  Created by Hanna Rybakova on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mark.h"

@interface WeatherViewModel : NSObject
-(void)getData;
-(NSInteger)getRowsCount;
-(Mark *)getMarkByRow:(NSUInteger)row;
@end
