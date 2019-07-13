//
//  ImageTableViewController.m
//  FishingDay
//
//  Created by Иван on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "FishListViewController.h"
#import "FishTableViewCell.h"
#import "FishInfoViewController.h"
#import "FishModel.h"

NSString * const key1 = @"image";
NSString * const key2 = @"isImageLoaded";
NSString * const cellReuseId = @"cellReuseId";

@interface FishListViewController () <UITableViewDelegate, UITableViewDataSource, FishTableViewCellDelegate>

@property (weak, nonatomic) UITableView *fishesTableView;

@property(strong,nonatomic) NSMutableArray *fishesArr;

@property (copy, nonatomic) NSArray *imageURLs;
@property (strong, nonatomic) NSCache *imageCache;


@property (strong, nonatomic) NSIndexPath *tappedRowIndexPath;
//@property (strong, nonatomic) NSMutableSet *failedDownloads;

@end

@implementation FishListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Fishes";
   self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.imageCache = [NSCache new];
    self.imageURLs = @[@"http://fishingclub.by/templates/Pisces/images/fish_book/belij_amur.jpg", @"http://fishingclub.by/templates/Pisces/images/fish_book/422.jpg", @"http://fishingclub.by/templates/Pisces/images/fish_book/6.jpg", @"http://fishingclub.by/templates/Pisces/images/fish_book/2.jpg", @"http://fishingclub.by/templates/Pisces/images/fish_book/167.jpg", @"http://fishingclub.by/templates/Pisces/images/fish_book/195.jpg", @"http://fishingclub.by/templates/Pisces/images/fish_book/259.jpg", @"http://lookw.ru/1/519/1402242484-064.jpg"];
    
    NSArray *namesOfFishes =@[@"рыба1", @"рыба2", @"рыба3", @"рыба4", @"рыба5", @"рыба6", @"рыба7", @"рыба8"];
    self.fishesArr = [NSMutableArray new];
    for(int i =0;i<namesOfFishes.count;i++){
        FishModel *model = [FishModel new];
        model.imageUrl=self.imageURLs[i];
        model.nameFish = namesOfFishes[i];
        [self.fishesArr addObject:model];
    }
    
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.tappedRowIndexPath) {
        [self.fishesTableView scrollToRowAtIndexPath:self.tappedRowIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
- (void)viewDidLayoutSubviews {
    if (self.tappedRowIndexPath) {
        [self.fishesTableView scrollToRowAtIndexPath:self.tappedRowIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        self.tappedRowIndexPath = nil;
    }
}

#pragma mark - Private

- (void)setupTableView {
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    self.fishesTableView = tableView;
    self.fishesTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.fishesTableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.fishesTableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.view.safeAreaLayoutGuide.trailingAnchor constraintEqualToAnchor:self.fishesTableView.trailingAnchor],
                                              [self.view.safeAreaLayoutGuide.bottomAnchor constraintEqualToAnchor:self.fishesTableView.bottomAnchor]
                                              ]];
    self.fishesTableView.delegate = self;
    self.fishesTableView.dataSource = self;
    [self.fishesTableView registerClass:[FishTableViewCell class] forCellReuseIdentifier:cellReuseId];
    self.fishesTableView.tableFooterView = [UIView new];
    self.fishesTableView.allowsSelection = NO;
}





- (void)loadNewImageWithURL:(NSString *)stringURL forCell:(FishTableViewCell *)cell {
    
  
    dispatch_queue_t utilityQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);
    dispatch_async(utilityQueue, ^{
        NSURL *url = [NSURL URLWithString:stringURL];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *loadedImage = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (loadedImage) {
                [self.imageCache setObject:loadedImage forKey:stringURL];
                [[NSNotificationCenter defaultCenter] postNotificationName:stringURL object:self userInfo:@{key2: @YES, key1: loadedImage}];
                if ([cell.imageUrlName isEqualToString:stringURL]) {
                    cell.centeredImageView.image = loadedImage;
                }
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:stringURL object:self userInfo:@{key2: @NO}];
            }
        });
    });
}

#pragma mark - UITableViewDelegate



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageURLs.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId forIndexPath:indexPath];
    cell.delegate = self;
    FishModel *model = self.fishesArr[indexPath.row];
    NSString *imageURL = model.imageUrl;
    cell.imageUrlName = imageURL;
    cell.fishName = model.nameFish;
    [cell setNeedsUpdateConstraints];
    UIImage *image = [self.imageCache objectForKey:imageURL];
    if (image) {
        cell.centeredImageView.image = image;
    } else {
        [self loadNewImageWithURL:imageURL forCell:cell];
    }
    return cell;
}

#pragma mark - ImageURLTableViewCellDelegate

- (void)didTapOnImageViewInCell:(FishTableViewCell *)cell {
    NSIndexPath *indexPath = [self.fishesTableView indexPathForCell:cell];
    NSString *imageURL = self.imageURLs[indexPath.row];
    FishInfoViewController *imageVC = [FishInfoViewController new];
    imageVC.imageURL = imageURL;
    UIImage *image = [self.imageCache objectForKey:imageURL];
    if (image) {
        imageVC.image = image;
    }
    
    
    self.tappedRowIndexPath = indexPath;
    [self.navigationController pushViewController:imageVC animated:YES];
}

@end
