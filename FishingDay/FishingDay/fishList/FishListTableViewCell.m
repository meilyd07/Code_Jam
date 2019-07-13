//
//  FishListTableViewCell.m
//  FishingDay
//
//  Created by Иван on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "FishURLTableViewCell.h"

static void *ImageViewImageContext = &ImageViewImageContext;

@interface ImageURLTableViewCell ()

@property (assign, nonatomic) BOOL didSetupConstraints;
@property (strong, nonatomic) NSLayoutConstraint *imageViewHeightConstraint;

@end

@implementation ImageURLTableViewCell

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
    self.centeredImageView.image = [UIImage imageNamed:@"placeholderImage"];
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
                                                  [self.imageURLLabel.leadingAnchor constraintEqualToAnchor:self.centeredImageView.trailingAnchor constant:25],
                                                  [self.imageURLLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20],
                                                  [self.contentView.trailingAnchor constraintEqualToAnchor:self.imageURLLabel.trailingAnchor constant:20],
                                                  [self.contentView.bottomAnchor constraintEqualToAnchor:self.imageURLLabel.bottomAnchor constant:20]]];
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
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholderImage"]];
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
    self.imageURLLabel = label;
    self.imageURLLabel.numberOfLines = 0;
    self.imageURLLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imageURLLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisVertical];
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

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = [imageURL copy];
    self.imageURLLabel.text = _imageURL;
}

#pragma mark - Gesture Recognizers

- (void)onImageViewTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(didTapOnImageViewInCell:)]) {
        [self.delegate didTapOnImageViewInCell:self];
    }
}

@end
