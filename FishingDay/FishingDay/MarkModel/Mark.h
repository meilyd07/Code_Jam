//
//  Mark.h
//  FishingDay
//
//  Created by Liubou Sakalouskaya on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Mark : NSObject <NSCoding>

//TODO: add property to store location
@property (strong, nonatomic) UIImage *photo;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *details;

@end
