//
//  WeatherViewModel.m
//  FishingDay
//
//  Created by Hanna Rybakova on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "WeatherViewModel.h"
@interface WeatherViewModel()
@property (copy, nonatomic) NSMutableArray *marks;
@end

@implementation WeatherViewModel

-(void)getData{
    NSData *marksData = [[NSUserDefaults standardUserDefaults] objectForKey:marksDataKey];
    if (marksData) {
        NSSet *classes = [NSSet setWithObjects:[NSArray class], [Mark class], nil];
        NSArray *decodedMarks = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:marksData error:nil];
        self.marks = [decodedMarks mutableCopy];
    } else {
        self.marks = [NSMutableArray array];
    }
}

-(NSInteger)getRowsCount {
    return self.marks.count;
}

-(Mark *)getMarkByRow:(NSUInteger)row {
    return (Mark *)self.marks[row];
}
@end
