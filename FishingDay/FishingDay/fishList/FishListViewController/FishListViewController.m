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
#import "AddFishViewController.h"



NSString * const key1 = @"image";
NSString * const key2 = @"isImageLoaded";
NSString * const cellReuseId = @"cellReuseId";

@interface FishListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *fishesTableView;

@property(strong,nonatomic) NSMutableArray *fishesArr;
@property(strong,nonatomic) NSArray *fishesAr;

//@property (copy, nonatomic) NSArray *imageURLs;
@property (strong, nonatomic) NSCache *imageCache;


@property (strong, nonatomic) NSIndexPath *tappedRowIndexPath;

@end

@implementation FishListViewController

#pragma mark - Lifecycle
-(instancetype)init{
    if(self){
      NSData *marksData = [[NSUserDefaults standardUserDefaults] objectForKey:fishesDataKey];
        if (!marksData) {
           
            NSArray *imageUrls = @[@"http://fishingclub.by/templates/Pisces/images/fish_book/128.jpg", @"http://fishingclub.by/templates/Pisces/images/fish_book/193.jpg", @"http://fishingclub.by/templates/Pisces/images/fish_book/152.jpg", @"http://fishingclub.by/templates/Pisces/images/fish_book/145.jpg", @"http://fishingclub.by/templates/Pisces/images/fish_book/525.jpg", @"http://fishingclub.by/templates/Pisces/images/fish_book/210.jpg", @"http://fishingclub.by/templates/Pisces/images/fish_book/122.jpg", @"http://fishingclub.by/templates/Pisces/images/fish_book/112.gif",
                @"http://fishingclub.by/templates/Pisces/images/fish_book/132.jpg",
                @"http://fishingclub.by/templates/Pisces/images/fish_book/161.jpg"];
            
            NSArray *namesOfFishes =@[@"Окунь", @"Судак", @"Щука", @"Налим", @"Форель", @"Карп", @"Лещ", @"Карась",@"Плотва",@"Сом"];
            NSArray *arrMin = @[@18,@12,@15,@5,@10,@22,@18,@20,@12,@20,];
             NSArray *arrMax = @[@20,@18,@16,@6,@12,@28,@20,@28,@18,@28,];
            
            
            NSString *str =@"feieiofjneoinfeoifneoifneoifnjeoijfeoijfeoijfoejfeoijfeoifjeofjeoifjeoifjeoifjirnjrenfjenfeinfeinfeiojfehgwephguwehgpehgoheoihgoeigheogheowhrowhwoinvcoweinhfoierhg[weohgwe[ohnq'ihwpeorghwe[goihwe[ihgrwe[goihwg[wihgw[gihw[ihg[wihgw[ighw[whgwghwg";
            
            NSMutableArray *arr = [NSMutableArray new];
            for(int i =0;i<namesOfFishes.count;i++){
                FishModel *model = [FishModel new];
                model.idFish= [NSNumber numberWithInt:i];
                model.imageUrl=imageUrls[i];
                model.nameFish = namesOfFishes[i];
                model.maxTemperature= arrMax[i];
                model.minTemperature = arrMin[i];
                
                model.descriptionFish=str;
                [arr addObject:model];
            }
            NSData *fishesData = [NSKeyedArchiver archivedDataWithRootObject:arr requiringSecureCoding:NO error:nil];
            [[NSUserDefaults standardUserDefaults] setObject:fishesData forKey:fishesDataKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSData *marksDataa = [[NSUserDefaults standardUserDefaults] objectForKey:fishesDataKey];
            NSSet *classes = [NSSet setWithObjects:[NSArray class], [FishModel class], nil];
            NSArray *decodedMarks = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:marksDataa error:nil];
            
            self.fishesAr = decodedMarks;
        } else {
            NSData *marksDataa = [[NSUserDefaults standardUserDefaults] objectForKey:fishesDataKey];
            NSSet *classes = [NSSet setWithObjects:[NSArray class], [FishModel class], nil];
            NSArray *decodedMarks = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:marksDataa error:nil];
            
            self.fishesAr = decodedMarks;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Fishes";
   self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
      UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFish)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.imageCache = [NSCache new];
    
    
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
  //  self.fishesTableView.allowsSelection = NO;
    
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

- (void)addFish {
    AddFishViewController *markVC = [AddFishViewController new];
    markVC.row = self.fishesAr.count;
    [self.navigationController pushViewController:markVC animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fishChanged:) name:fishChangedNotification object:markVC];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fishesAr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId forIndexPath:indexPath];
    FishModel *model = self.fishesAr[indexPath.row];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FishModel *model = self.fishesAr[indexPath.row];
    FishInfoViewController *imageVC = [FishInfoViewController new];
     imageVC.fish = model;
    NSString *imageURL = model.imageUrl;
    UIImage *image = [self.imageCache objectForKey:imageURL];
    if (image) {
        imageVC.image = image;
    }
    
    self.tappedRowIndexPath = indexPath;
   
    [self.navigationController pushViewController:imageVC animated:YES];
}



- (void)fishChanged:(NSNotification *)notification {
    AddFishViewController *fishVC = notification.object;
    NSInteger row = fishVC.row;
    FishModel *fish;
    if (row == self.fishesAr.count) { // create mark
        fish = [FishModel new];
        NSMutableArray *fishes = [self mutableArrayValueForKey:@"fishesAr"];
        fish.idFish = [NSNumber numberWithInt: fishes.count];
        fish.nameFish = fishVC.fish.nameFish;
        fish.minTemperature= fishVC.fish.minTemperature;
        fish.maxTemperature = fishVC.fish.maxTemperature;
        fish.descriptionFish = fishVC.fish.descriptionFish;
        [fishes addObject:fish];
        
    } else { // update mark
        fish = self.fishesAr[row];
    }
    
    
    [self.fishesTableView reloadData];
    [self saveData];
}

- (void)saveData {
    NSData *marksData = [NSKeyedArchiver archivedDataWithRootObject:self.fishesAr requiringSecureCoding:NO error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:marksData forKey:fishesDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *change = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"change" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        AddFishViewController *vc = [AddFishViewController new];
        vc.fish =  self.fishesAr[indexPath.row];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fishChanged:) name:fishChangedNotification object:vc];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSMutableArray *marks = [self mutableArrayValueForKey:@"fishesAr"];
        [marks removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        [self saveData];
    }];

    delete.backgroundColor = [UIColor redColor];
    change.backgroundColor = [UIColor blueColor];
    
    UISwipeActionsConfiguration *configur = [UISwipeActionsConfiguration configurationWithActions:@[delete,change]];
    configur.performsFirstActionWithFullSwipe = YES;
    return configur;
}

@end
