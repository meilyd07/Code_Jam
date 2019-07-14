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
    self.title = [coder decodeObjectOfClass:[NSString class] forKey:@"title"];
    self.details = [coder decodeObjectOfClass:[NSString class] forKey:@"details"];
    self.photo = [coder decodeObjectOfClass:[UIImage class] forKey:@"photo"];
    
    CLLocationDegrees latitude = [coder decodeDoubleForKey:@"latitude"];
    CLLocationDegrees longitude = [coder decodeDoubleForKey:@"longitude"];
    self.location = CLLocationCoordinate2DMake(latitude, longitude);
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.details forKey:@"details"];
    [coder encodeObject:self.photo forKey:@"photo"];
    
    [coder encodeDouble:self.location.latitude forKey:@"latitude"];
    [coder encodeDouble:self.location.longitude forKey:@"longitude"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
