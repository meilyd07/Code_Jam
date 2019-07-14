//
//  WeatherDetailViewModel.h
//  FishingDay
//
//  Created by Hanna Rybakova on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mark.h"

@interface WeatherDetailViewModel : NSObject
@property (strong, nonatomic) Mark *mark;
//@property (assign, nonatomic) NSInteger row;
- (id)initWithMark:(Mark *)mark;
@end

