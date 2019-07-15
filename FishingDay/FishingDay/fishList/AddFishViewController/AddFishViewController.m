//
//  AddFishViewController.m
//  FishingDay
//
//  Created by Иван on 7/14/19.
//  Copyright © 2019 None. All rights reserved.
//

#import "AddFishViewController.h"
#import "UIView+AnimatedLines.h"

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
    else {
        self.fish = [FishModel new];
        //self.mark.location =
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    //view.backgroundColor = [UIColor whiteColor];
    UIGraphicsBeginImageContext(view.frame.size);
    [[UIImage imageNamed:@"save2"] drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    view.backgroundColor = [UIColor colorWithPatternImage:image];
    //UIImage *img = [UIImage imageNamed:@"save"];
    
    [self.view addSubview:view];
    

    [view animateLinesWithColor:[UIColor redColor].CGColor andLineWidth:8 startPoint:CGPointMake(100, -200) rollToStroke:0.25
               curveControlPoints:@[[LinesCurvePoints curvePoints:CGPointMake(-50, -2) point2:CGPointMake(60, 5)],[LinesCurvePoints curvePoints:CGPointMake(-60, 10) point2:CGPointMake(100, 5)]] animationDuration:1];
    [UIView animateWithDuration:2.0 animations:^{
         view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
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
