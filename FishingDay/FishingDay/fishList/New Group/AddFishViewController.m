//
//  AddFishViewController.m
//  FishingDay
//
//  Created by Иван on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "AddFishViewController.h"

NSString * const fishChangedNotification = @"fishChangedNotification";

@interface AddFishViewController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLavbel;
@property (strong, nonatomic) IBOutlet UITextField *nameTextfield;
@property (strong, nonatomic) IBOutlet UILabel *minTempLabel;
@property (strong, nonatomic) IBOutlet UITextField *minTempTextField;
@property (strong, nonatomic) IBOutlet UILabel *maxTempLabel;
@property (strong, nonatomic) IBOutlet UITextField *maxTempTextField;
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;
@property (strong, nonatomic) IBOutlet UITextField *urrTextField;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;


@end

@implementation AddFishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.fish)
    {
        self.nameTextfield.text = self.fish.nameFish;
        self.minTempTextField.text = [self.fish.minTemperature stringValue];
         self.maxTempTextField.text = [self.fish.maxTemperature stringValue];
        self.urrTextField.text = self.fish.imageUrl;
    }
    
     [self.saveBtn addTarget:self action:@selector(onSaveButton) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}


- (void)onSaveButton {
    self.fish.nameFish = self.nameTextfield.text;
    self.fish.minTemperature = [NSNumber numberWithFloat: [self.minTempTextField.text floatValue]];
    self.fish.minTemperature = [NSNumber numberWithFloat: [self.minTempTextField.text floatValue]];
    self.fish.imageUrl=self.urrTextField.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:fishChangedNotification object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
