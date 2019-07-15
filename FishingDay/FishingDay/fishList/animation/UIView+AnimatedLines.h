//
//  UIView+AnimatedLines.h
//  FishingDay
//
//  Created by Иван on 7/15/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LinesCurvePoints : NSObject
@property(nonatomic,assign)CGPoint controlPoint1;
@property(nonatomic,assign)CGPoint controlPoint2;
+(instancetype)curvePoints:(CGPoint)point1 point2:(CGPoint)point2;
@end

@interface UIView (AnimatedLines)
-(void)animateLinesWithColor:(CGColorRef)lineColor andLineWidth:(CGFloat)lineWidth startPoint:(CGPoint)startFromPoint rollToStroke:(CGFloat)rollToStroke curveControlPoints:(NSArray<LinesCurvePoints*>*)curvePoints animationDuration:(CGFloat)duration;
@end

NS_ASSUME_NONNULL_END
