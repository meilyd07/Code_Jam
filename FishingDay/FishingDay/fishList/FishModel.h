//
//  FishModel.h
//  FishingDay
//
//  Created by Иван on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const fishesDataKey;

@interface FishModel : NSObject <NSCoding, NSSecureCoding>

@property(nonatomic) NSNumber *idFish;

@property(strong,nonatomic) NSString *nameFish;
@property(strong,nonatomic) NSString *imageUrl;

@property(strong,nonatomic) NSNumber *minTemperature;
@property(strong,nonatomic) NSNumber *maxTemperature;
@end

NS_ASSUME_NONNULL_END
