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

@end

@implementation MarksListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"Места улова рыбы";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMark)];
    self.navigationItem.rightBarButtonItem = addButton;
    
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    
    self.marks = [NSArray array];
    NSData *marksData = [[NSUserDefaults standardUserDefaults] objectForKey:marksDataKey];
    if (!marksData) {
//        self.tableView.hidden = YES;
//        UIImageView *noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fishWallpaper"]];
//        [self.view addSubview:noDataImageView];
        
        NSMutableArray *tempMarks = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            Mark *mark = [Mark new];
            mark.title = [NSString stringWithFormat:@"Mark %d", i + 1];
            mark.details = @"aaaaaaaaaaaaaaaaaa";
            CLLocationDegrees latitude = 53.9615398 + i/20.0;
            CLLocationDegrees longitude = 27.3475244 + i/20.0;
            mark.location = CLLocationCoordinate2DMake(latitude, longitude);
            [tempMarks addObject:mark];
        }
        self.marks = tempMarks;
        
        
    } else {
        NSSet *classes = [NSSet setWithObjects:[NSArray class], [Mark class], nil];
        NSArray *decodedMarks = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:marksData error:nil];
        self.marks = decodedMarks;
    }
}

- (void)addMark {
    MarkViewController *markVC = [MarkViewController new];
    markVC.row = self.marks.count;
    [self.navigationController pushViewController:markVC animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markChanged:) name:markChangedNotification object:markVC];
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Mark *mark = self.marks[indexPath.row];
    MarkViewController *markVC = [MarkViewController new];
    markVC.mark = mark;
    markVC.row = indexPath.row;
    [self.navigationController pushViewController:markVC animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markChanged:) name:markChangedNotification object:markVC];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *marks = [self mutableArrayValueForKey:@"marks"];
        [marks removeObjectAtIndex:indexPath.row];
        [self saveData];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)markChanged:(NSNotification *)notification {
    MarkViewController *markVC = notification.object;
    NSInteger row = markVC.row;
    Mark *mark;
    if (row == self.marks.count) { // create mark
        mark = [Mark new];
        NSMutableArray *marks = [self mutableArrayValueForKey:@"marks"];
        [marks addObject:mark];
    } else { // update mark
        mark = self.marks[row];
    }
    mark.title = markVC.mark.title;
    mark.details = markVC.mark.details;
    mark.photo = markVC.mark.photo;
    [self.tableView reloadData];
    [self saveData];
}

- (void)saveData {
    NSData *marksData;
    if (self.marks.count != 0) {
        marksData = [NSKeyedArchiver archivedDataWithRootObject:self.marks requiringSecureCoding:NO error:nil];
    }
    [[NSUserDefaults standardUserDefaults] setObject:marksData forKey:marksDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
