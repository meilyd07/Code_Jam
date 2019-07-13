//
//  ImageURLTableViewCell.h
//  FishingDay
//
//  Created by Иван on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FishModel.h"
@class FishTableViewCell;

@protocol FishTableViewCellDelegate <NSObject>

- (void)didTapOnImageViewInCell:(FishTableViewCell *)cell;

@end

@interface FishTableViewCell : UITableViewCell

@property (weak, nonatomic) UIImageView *centeredImageView;
@property (weak, nonatomic) UILabel *fishNameLabel;
@property (copy, nonatomic) NSString *imageUrlName;
@property (copy, nonatomic) NSString *fishName;


@property (weak, nonatomic) id<FishTableViewCellDelegate> delegate;

@end
