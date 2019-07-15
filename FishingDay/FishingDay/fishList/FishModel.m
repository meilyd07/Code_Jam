//
//  FishModel.m
//  FishingDay
//
//  Created by Иван on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "FishModel.h"


NSString * const fishesDataKey = @"fishesDataKey";

@implementation FishModel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    
    self.idFish = [coder decodeObjectOfClass:[NSNumber class] forKey:@"idFish"];
    self.nameFish = [coder decodeObjectOfClass:[NSString class] forKey:@"nameFish"];
    self.imageUrl = [coder decodeObjectOfClass:[NSString class] forKey:@"imageUrl"];
    self.maxTemperature = [coder decodeObjectOfClass:[NSNumber class] forKey:@"minTemperature"];
     self.minTemperature = [coder decodeObjectOfClass:[NSNumber class] forKey:@"maxTemperature"];
    self.descriptionFish = [coder decodeObjectOfClass:[NSString class] forKey:@"descriptionFish"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.idFish forKey:@"idFish"];
    [coder encodeObject:self.nameFish forKey:@"nameFish"];
    [coder encodeObject:self.imageUrl forKey:@"imageUrl"];
     [coder encodeObject:self.maxTemperature forKey:@"minTemperature"];
     [coder encodeObject:self.minTemperature forKey:@"maxTemperature"];
    [coder encodeObject:self.descriptionFish forKey:@"descriptionFish"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}
@end
