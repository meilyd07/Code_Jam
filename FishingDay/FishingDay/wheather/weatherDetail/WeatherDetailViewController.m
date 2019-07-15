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
#import "WeatherSection.h"

@interface WeatherDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic) NSArray* sections;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation WeatherDetailViewController
static NSString *TableViewCellIdentifier = @"LocationMarkCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.viewModel getWeatherData:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.sections = @[
                              [[WeatherSection alloc] init: temperatureSection items:@[
                                                                                       @(temperature),
                                                                                       @(tempMax),
                                                                                       @(tempMin),
                                                                                       @(pressure),
                                                                                       @(humidity),
                                                                                       @(windSpeed),
                                                                                       @(windSpeed)
                                                                                       ]],
                              [[WeatherSection alloc] init: temperatureSection items:@[
                                                                                       @(temperature),
                                                                                       @(tempMax),
                                                                                       @(tempMin),
                                                                                       @(pressure),
                                                                                       @(humidity),
                                                                                       @(windSpeed),
                                                                                       @(windSpeed)
                                                                                       ]],
                              [[WeatherSection alloc] init: temperatureSection items:@[
                                                                                       @(temperature),
                                                                                       @(tempMax),
                                                                                       @(tempMin),
                                                                                       @(pressure),
                                                                                       @(humidity),
                                                                                       @(windSpeed),
                                                                                       @(windSpeed)
                                                                                       ]],
                              [[WeatherSection alloc] init: temperatureSection items:@[
                                                                                       @(temperature),
                                                                                       @(tempMax),
                                                                                       @(tempMin),
                                                                                       @(pressure),
                                                                                       @(humidity),
                                                                                       @(windSpeed),
                                                                                       @(windSpeed)
                                                                                       ]],
                              [[WeatherSection alloc] init: temperatureSection items:@[
                                                                                       @(temperature),
                                                                                       @(tempMax),
                                                                                       @(tempMin),
                                                                                       @(pressure),
                                                                                       @(humidity),
                                                                                       @(windSpeed),
                                                                                       @(windSpeed)
                                                                                       ]],
                              [[WeatherSection alloc] init: temperatureSection items:@[
                                                                                       @(temperature),
                                                                                       @(tempMax),
                                                                                       @(tempMin),
                                                                                       @(pressure),
                                                                                       @(humidity),
                                                                                       @(windSpeed),
                                                                                       @(windSpeed)
                                                                                       ]],
                              [[WeatherSection alloc] init: temperatureSection items:@[
                                                                                       @(temperature),
                                                                                       @(tempMax),
                                                                                       @(tempMin),
                                                                                       @(pressure),
                                                                                       @(humidity),
                                                                                       @(windSpeed),
                                                                                       @(windSpeed)
                                                                                       ]],
                              
                              [[WeatherSection alloc] init: temperatureSection items:@[
                                                                                       @(temperature),
                                                                                       @(tempMax),
                                                                                       @(tempMin),
                                                                                       @(pressure),
                                                                                       @(humidity),
                                                                                       @(windSpeed),
                                                                                       @(windSpeed)
                                                                                       ]]
                              ];
            [self.tableView reloadData];
        });
    }];
        self.tableView.delegate = self;
    self.tableView.dataSource = self;
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

    [markCell.buttonInfo setHidden:YES];
    
    WeatherSection *section = (WeatherSection *)self.sections[indexPath.section];
    enum WeatherItem current = [section.items[indexPath.row] integerValue];
    switch (current) {
        case windSpeed:
            markCell.markTitle.text = [NSString stringWithFormat:@"Скорость ветра, м/с: %@", [self.viewModel getWindSpeedValue:indexPath.section]];
            break;
        case temperature:
            markCell.markTitle.text = [NSString stringWithFormat:@"Температура, C: %@", [self.viewModel getTemperatureValue:indexPath.section]];
            break;
        case pressure:
            markCell.markTitle.text = [NSString stringWithFormat:@"Атмосферное давление, гПа: %@", [self.viewModel getAtmosphericPressureValue:indexPath.section]];
            break;
        case humidity:
            markCell.markTitle.text = [NSString stringWithFormat:@"Влажность, %%: %@", [self.viewModel getHumidityValue:indexPath.section]];
            break;
        case tempMin:
            markCell.markTitle.text = [NSString stringWithFormat:@"Минимальная температура, C: %@", [self.viewModel getMinTemperatureValue:indexPath.section]];
            break;
        case tempMax:
            markCell.markTitle.text = [NSString stringWithFormat:@"Максимальная температура, C: %@", [self.viewModel getMaxTemperatureValue:indexPath.section]];
            break;
        default:
            break;
    }
    return markCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSUInteger current = ((WeatherSection *)self.sections[section]).type;
    switch (current) {
    case temperatureSection:
            return [NSString stringWithFormat:@"Погода на: %@", [self.viewModel getDateValue:section]];
    default:
            return @"";
    }
}

@end
