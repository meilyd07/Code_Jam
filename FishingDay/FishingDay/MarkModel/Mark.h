//
//  Mark.h
//  FishingDay
//
//  Created by Liubou Sakalouskaya on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

extern NSString * const marksDataKey;

@interface Mark : NSObject <NSCoding, NSSecureCoding>

@property (assign, nonatomic) CLLocationCoordinate2D location;
@property (strong, nonatomic) UIImage *photo;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *details;
@property (copy, nonatomic) NSArray *fishId;

@end
