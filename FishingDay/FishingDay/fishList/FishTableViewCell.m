//
//  ImageURLTableViewCell.m
//  FishingDay
//
//  Created by Иван on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "FishTableViewCell.h"

static void *ImageViewImageContext = &ImageViewImageContext;

@interface FishTableViewCell ()

@property (assign, nonatomic) BOOL didSetupConstraints;
@property (strong, nonatomic) NSLayoutConstraint *imageViewHeightConstraint;

@end

@implementation FishTableViewCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCenteredImageView];
        [self setupImageURLLabel];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.centeredImageView.image = [UIImage imageNamed:@"fish_food"];
}

- (void)updateConstraints {
    CGFloat aspectRatio = self.centeredImageView.image.size.height / self.centeredImageView.image.size.width;
    if (!self.didSetupConstraints) {
        self.imageViewHeightConstraint = [self.centeredImageView.heightAnchor constraintEqualToConstant:aspectRatio*100];
        self.imageViewHeightConstraint.priority = UILayoutPriorityRequired - 1;
        [NSLayoutConstraint activateConstraints:@[self.imageViewHeightConstraint,
                                                  [self.centeredImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
                                                  [self.centeredImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
                                                  [self.centeredImageView.widthAnchor constraintEqualToConstant:100],
                                                  [self.contentView.heightAnchor constraintGreaterThanOrEqualToAnchor:self.centeredImageView.heightAnchor multiplier:1.0 constant:40],
                                                  [self.fishNameLabel.leadingAnchor constraintEqualToAnchor:self.centeredImageView.trailingAnchor constant:25],
                                                  [self.fishNameLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20],
                                                  [self.contentView.trailingAnchor constraintEqualToAnchor:self.fishNameLabel.trailingAnchor constant:20],
                                                  [self.contentView.bottomAnchor constraintEqualToAnchor:self.fishNameLabel.bottomAnchor constant:20]]];
        self.didSetupConstraints = YES;
    } else {
        self.imageViewHeightConstraint.constant = aspectRatio * 100;
    }
    [super updateConstraints];
}

- (void)dealloc
{
    [_centeredImageView removeObserver:self forKeyPath:@"image"];
}

#pragma mark - Private

- (void)setupCenteredImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fish_food"]];
    [self.contentView addSubview:imageView];
    self.centeredImageView = imageView;
    [self.centeredImageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:ImageViewImageContext];
    self.centeredImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.centeredImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewTap:)];
    [self.centeredImageView addGestureRecognizer:tap];
}

- (void)setupImageURLLabel {
    UILabel *label = [UILabel new];
    [self.contentView addSubview:label];
    self.fishNameLabel = label;
    self.fishNameLabel.numberOfLines = 0;
    self.fishNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.fishNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisVertical];
}

#pragma mark - Key-Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == ImageViewImageContext) {
        UIImage *oldImageView = change[NSKeyValueChangeOldKey];
        UIImage *newImageView = change[NSKeyValueChangeNewKey];
        CGFloat aspectRatioOld = oldImageView.size.height / oldImageView.size.width;
        CGFloat aspectRatioNew = newImageView.size.height / newImageView.size.width;
        if (aspectRatioNew != aspectRatioOld) {
            [self setNeedsUpdateConstraints];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Custom Accessors

- (void)setFishName:(NSString *)fishName{
    self.fishNameLabel.text = fishName;
}

#pragma mark - Gesture Recognizers

- (void)onImageViewTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(didTapOnImageViewInCell:)]) {
        [self.delegate didTapOnImageViewInCell:self];
    }
}

@end

