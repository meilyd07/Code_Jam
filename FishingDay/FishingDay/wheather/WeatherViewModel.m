//
//  WeatherViewModel.m
//  FishingDay
//
//  Created by Hanna Rybakova on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "WeatherViewModel.h"
@interface WeatherViewModel()
@property (copy, nonatomic) NSArray *marks;
@end

@implementation WeatherViewModel

-(void)getData{
    self.marks = [NSArray array];
    NSData *marksData = [[NSUserDefaults standardUserDefaults] objectForKey:marksDataKey];
    if (marksData) {
        NSSet *classes = [NSSet setWithObjects:[NSArray class], [Mark class], nil];
        NSArray *decodedMarks = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:marksData error:nil];
        self.marks = decodedMarks;
    } else {
        NSMutableArray *tempMarks = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            Mark *mark = [Mark new];
            mark.photo = [UIImage imageNamed:@"fish_food"];
            mark.title = [NSString stringWithFormat:@"Mark %d", i + 1];
            mark.details = @"aaaaaaaaaaaaaaaaaa";
            [tempMarks addObject:mark];
        }
        self.marks = tempMarks;
    }
}

-(NSInteger)getRowsCount {
    return self.marks.count;
}

-(Mark *)getMarkByRow:(NSUInteger)row {
    return (Mark *)self.marks[row];
}
@end
