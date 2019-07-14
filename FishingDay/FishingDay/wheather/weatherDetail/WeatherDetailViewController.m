//
//  WeatherDetailViewController.m
//  FishingDay
//
//  Created by Hanna Rybakova on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "WeatherDetailViewController.h"
#import "WeatherDetailViewModel.h"
#import "LocationMarkCell.h"

@interface WeatherDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic) NSArray* sections;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation WeatherDetailViewController
static NSString *TableViewCellIdentifier = @"LocationMarkCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sections = @[
                      [[WeatherSection alloc] init: weatherSection items:@[
                                           @(temperature),
                                           @(pressure),
                                           @(humidity),
                                           @(tempMax),
                                           @(tempMin),
                                           @(windSpeed),
                                           @(windDeg)
                                           ]],
                      
                      [[WeatherSection alloc] init: fishSection items:@[@(fishesList)]]
                      
                      ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((WeatherSection *)self.sections[section]).items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationMarkCell *markCell = nil;
    markCell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (markCell == nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"LocationMarkCell"
                                                      owner:self options:nil];
        markCell = (LocationMarkCell *)[nibs objectAtIndex:0];
    }
    
    NSUInteger current = ((WeatherSection *)self.sections[indexPath.section]).items[indexPath.row];
    switch (current) {
        case windDeg:
            markCell.markTitle.text = @"Направление ветра, градусы:";
            break;
        case windSpeed:
            markCell.markTitle.text = @"Скорость ветра, м/с:";
            break;
        default:
            break;
    }
    return markCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSUInteger current = ((WeatherSection *)self.sections[section]).type;

    switch (current) {
    case weatherSection:
            return @"Температура, ветер, давление:";
    case fishSection:
            return @"Виды рыбы";
    default:
            return @"";
    }
}

@end
