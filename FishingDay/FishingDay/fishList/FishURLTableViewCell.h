//
//  FishListTableViewCell.h
//  FishingDay
//
//  Created by Иван on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FishURLTableViewCell;

@protocol ImageURLTableViewCellDelegate <NSObject>

- (void)didTapOnImageViewInCell:(FishURLTableViewCell *)cell;

@end

@interface FishURLTableViewCell : UITableViewCell

@property (weak, nonatomic) UIImageView *centeredImageView;
@property (weak, nonatomic) UILabel *imageURLLabel;
@property (copy, nonatomic) NSString *imageURL;
@property (weak, nonatomic) id<ImageURLTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
