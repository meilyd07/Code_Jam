//
//  Mark.m
//  FishingDay
//
//  Created by Liubou Sakalouskaya on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "Mark.h"

NSString * const marksDataKey = @"marksDataKey";

@implementation Mark

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    self.latitude = [coder decodeDoubleForKey:@"latitude"];
    self.longitude = [coder decodeDoubleForKey:@"longitude"];
    self.location = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    self.title = [coder decodeObjectOfClass:[NSString class] forKey:@"title"];
    self.details = [coder decodeObjectOfClass:[NSString class] forKey:@"details"];
    self.photo = [coder decodeObjectOfClass:[UIImage class] forKey:@"photo"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeDouble:self.latitude forKey:@"latitude"];
    [coder encodeDouble:self.longitude forKey:@"longitude"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.details forKey:@"details"];
    [coder encodeObject:self.photo forKey:@"photo"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
