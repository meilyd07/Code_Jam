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
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextvVew;
@property (strong, nonatomic) IBOutlet UIScrollView *addScrollView;


@end

@implementation AddFishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.fish)
    {
        self.nameTextfield.text = self.fish.nameFish;
        self.minTempTextField.text = [self.fish.maxTemperature stringValue];
         self.maxTempTextField.text = [self.fish.minTemperature stringValue];
        self.urrTextField.text = self.fish.imageUrl;
        self.descriptionTextvVew.text = self.fish.descriptionFish;
        
    }
    else {
        self.fish = [FishModel new];
        
    }
  
      self.addScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.maxTempTextField.delegate=self;
    self.minTempTextField.delegate=self;
     [self.saveBtn addTarget:self action:@selector(onSaveButton) forControlEvents:UIControlEventTouchUpInside];
    [self registerForKeyboardNotifications];
    // Do any additional setup after loading the view from its nib.
}


- (void)onSaveButton {
    if([self.nameTextfield.text isEqualToString:@""]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Внимание!"
                                                                       message:@"Введите название рыбы"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    self.fish.nameFish = self.nameTextfield.text;
    self.fish.maxTemperature = [NSNumber numberWithFloat: [self.minTempTextField.text floatValue]];
    self.fish.minTemperature = [NSNumber numberWithFloat: [self.maxTempTextField.text floatValue]];
    self.fish.imageUrl=self.urrTextField.text;
    self.fish.descriptionFish = self.descriptionTextvVew.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:fishChangedNotification object:self];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height/2-100, 200, 200)];
    UIGraphicsBeginImageContext(view.frame.size);
    [[UIImage imageNamed:@"save2"] drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    [self.view addSubview:view];
    [view animateLinesWithColor:[UIColor blueColor].CGColor andLineWidth:8 startPoint:CGPointMake(  0+view.frame.origin.y-self.saveBtn.frame.origin.y,0-view.frame.origin.x-self.saveBtn.frame.origin.x) rollToStroke:0.3
               curveControlPoints:@[[LinesCurvePoints curvePoints:CGPointMake(-50, -2) point2:CGPointMake(60, 5)],[LinesCurvePoints curvePoints:CGPointMake(-60, 10) point2:CGPointMake(100, 5)]] animationDuration:1];
    
    [UIView animateWithDuration:2.0 animations:^{
         view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890+"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.addScrollView.contentInset = contentInsets;
    self.addScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
   CGPoint poin =  CGPointMake(_descriptionTextvVew.frame.origin.x, _descriptionTextvVew.frame.origin.y+50);
    
    if (!CGRectContainsPoint(aRect, poin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, _descriptionTextvVew.frame.origin.y-kbSize.height+125);
        [self.addScrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.addScrollView.contentInset = contentInsets;
    self.addScrollView.scrollIndicatorInsets = contentInsets;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
