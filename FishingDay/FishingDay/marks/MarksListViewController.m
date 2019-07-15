//
//  MarksListViewController.m
//  FishingDay
//
//  Created by Hanna Rybakova on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "MarksListViewController.h"
#import "MarkTableViewCell.h"
#import "Mark.h"
#import "MarkViewController.h"

NSString * const markCellId = @"markCellId";

@interface MarksListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (copy, nonatomic) NSArray *marks;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIImageView *noDataImageView;
@property (weak, nonatomic) UILabel *addFirstMarkLabel;

@end

@implementation MarksListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"Места улова рыбы";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMark)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchMarks];
    [self.tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)setupTableView {
    UITableView *marksTableView = [UITableView new];
    [self.view addSubview:marksTableView];
    self.tableView = marksTableView;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
          [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.leadingAnchor],
          [self.tableView.topAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.topAnchor],
          [self.view.layoutMarginsGuide.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor],
          [self.view.layoutMarginsGuide.bottomAnchor constraintEqualToAnchor:self.tableView.bottomAnchor]]];
    UINib *markCellNib = [UINib nibWithNibName:NSStringFromClass([MarkTableViewCell class]) bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:markCellNib forCellReuseIdentifier:markCellId];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
}

- (void)fetchMarks {
    self.marks = [NSArray array];
    NSData *marksData = [[NSUserDefaults standardUserDefaults] objectForKey:marksDataKey];
    if (!marksData) {
        [self showNoMarks];
    } else {
        NSSet *classes = [NSSet setWithObjects:[NSArray class], [Mark class], nil];
        NSArray *decodedMarks = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:marksData error:nil];
        self.marks = decodedMarks;
    }
}

- (void)showNoMarks {
    self.tableView.hidden = YES;
    UIImage *fishHookImage = [UIImage imageNamed:@"fishingMan"];
    UIImageView *noDataImageView = [[UIImageView alloc] initWithImage:fishHookImage];
    UILabel *addFirstMarkLabel = [UILabel new];
    [self.view addSubview:noDataImageView];
    [self.view addSubview:addFirstMarkLabel];
    self.noDataImageView = noDataImageView;
    self.addFirstMarkLabel = addFirstMarkLabel;
    self.addFirstMarkLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightSemibold];
    self.addFirstMarkLabel.text = @"Добавьте первую метку";
    self.noDataImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.addFirstMarkLabel.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat aspectRatio = fishHookImage.size.height / fishHookImage.size.width;
    [NSLayoutConstraint activateConstraints:@[
        [self.noDataImageView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.4],
        [self.noDataImageView.heightAnchor constraintEqualToAnchor:self.noDataImageView.widthAnchor multiplier:aspectRatio],
        [self.noDataImageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:25],
        [self.noDataImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.addFirstMarkLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.addFirstMarkLabel.topAnchor constraintEqualToAnchor:self.noDataImageView.bottomAnchor constant:15]]];
}

- (void)addMark {
    CLAuthorizationStatus permissionStatus = [CLLocationManager authorizationStatus];
    if (permissionStatus == kCLAuthorizationStatusDenied){
        UIAlertController *locationDenied = [UIAlertController alertControllerWithTitle:@"Внимание!" message:@"Невозможно создать метку: включите доступ к местоположению в настройках телефона" preferredStyle:UIAlertControllerStyleAlert];
        [locationDenied addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:locationDenied animated:YES completion:nil];
        return;
    }
    MarkViewController *markVC = [MarkViewController new];
    markVC.isCurrentLocation = YES;
    markVC.row = self.marks.count;
    [self.navigationController pushViewController:markVC animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markChanged:) name:markChangedNotification object:markVC];
}

- (void)saveData {
    NSData *marksData;
    if (self.marks.count != 0) {
        marksData = [NSKeyedArchiver archivedDataWithRootObject:self.marks requiringSecureCoding:NO error:nil];
    }
    [[NSUserDefaults standardUserDefaults] setObject:marksData forKey:marksDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.marks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markCellId forIndexPath:indexPath];
    Mark *mark = self.marks[indexPath.row];
    if (!mark.photo) {
        cell.photoImageView.image = [UIImage imageNamed:@"noPhoto"];
    } else {
        cell.photoImageView.image = mark.photo;
    }
    cell.titleLabel.text = mark.title;
    cell.fishTypesLabel.text = mark.details;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *marks = [self mutableArrayValueForKey:@"marks"];
        [marks removeObjectAtIndex:indexPath.row];
        [self saveData];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (marks.count == 0) {
            [self showNoMarks];
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Mark *mark = self.marks[indexPath.row];
    MarkViewController *markVC = [MarkViewController new];
    markVC.isCurrentLocation = NO;
    markVC.mark = mark;
    markVC.row = indexPath.row;
    [self.navigationController pushViewController:markVC animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markChanged:) name:markChangedNotification object:markVC];
}

#pragma mark - Notification Handlers

- (void)markChanged:(NSNotification *)notification {
    MarkViewController *markVC = notification.object;
    NSInteger row = markVC.row;
    Mark *mark;
    if (row == self.marks.count) { // create mark
        mark = [Mark new];
        NSMutableArray *marks = [self mutableArrayValueForKey:@"marks"];
        [marks addObject:mark];
        self.noDataImageView.hidden = YES;
        self.addFirstMarkLabel.hidden = YES;
        self.tableView.hidden = NO;
    } else { // update mark
        mark = self.marks[row];
    }
    mark.title = markVC.mark.title;
    mark.details = markVC.mark.details;
    mark.photo = markVC.mark.photo;
    mark.location = markVC.mark.location;
    [self.tableView reloadData];
    [self saveData];
}

@end
