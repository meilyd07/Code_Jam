//
//  WheatherViewController.m
//  FishingDay
//
//  Created by Hanna Rybakova on 7/13/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "WeatherViewController.h"
#import "LocationMarkCellDelegate.h"
#import "LocationMarkCell.h"

@interface WeatherViewController () <UITableViewDelegate, UITableViewDataSource, LocationMarkCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation WeatherViewController
static NSString *TableViewCellIdentifier = @"LocationMarkCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"Погода по локациям";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupTable];
}

-(void)setupTable {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 20;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.viewModel getData];
}

- (void)didClickOnCellAtIndex:(NSInteger)cellIndexRow {
//    DetailViewController *vc = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
//    vc.person = [self.viewModel getContactBySection:cellIndexSection row:cellIndexRow];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationMarkCell *markCell = nil;
    
    markCell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (markCell == nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"LocationMarkCell"
                                                      owner:self options:nil];
        markCell = (LocationMarkCell *)[nibs objectAtIndex:0];
    }
    
    Mark *mark = [self.viewModel getMarkByRow:indexPath.row];
    markCell.markTitle.text = mark.title;
    markCell.uniqueId = @"temp";
    markCell.delegate = self;
    markCell.cellIndexRow = indexPath.row;
    return markCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel getRowsCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

@end