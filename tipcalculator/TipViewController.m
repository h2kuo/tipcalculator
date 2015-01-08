//
//  TipViewController.m
//  tipcalculator
//
//  Created by Helen Kuo on 12/30/14.
//  Copyright (c) 2014 Helen Kuo. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

@property (nonatomic) NSNumberFormatter *numberFormatter;

- (IBAction)onTap:(id)sender;
- (void)updateValues;
- (void)onSettingsButton;
- (void)showDefaultTip;
- (void)trackTime;
@end

const float tipValues[] = {0.1, 0.15, 0.2};

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Tip Calculator";
    [self updateValues];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
    
}

- (NSNumberFormatter *)numberFormatter {
    if (_numberFormatter == nil) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [_numberFormatter setLocale:[NSLocale currentLocale]];
    }
    return _numberFormatter;
}

- (void)showDefaultTip {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int defaultTipIndex = (int)[defaults integerForKey:@"default_tip_index"];
    [self.tipControl setSelectedSegmentIndex:defaultTipIndex];
}

- (void)trackTime {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastTime = [defaults objectForKey:@"last_time_used"];
    NSDate *currentTime = [NSDate date];
    if (lastTime == NULL || [[lastTime dateByAddingTimeInterval:600] compare:currentTime] == NSOrderedAscending) {
        self.billTextField.text = @"";
        [self.billTextField becomeFirstResponder];
        
    }
    [defaults setObject:[NSDate date] forKey:@"last_time_used"];
    [defaults synchronize];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showDefaultTip];
    [self trackTime];
    [self updateValues];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trackTime)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.billTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}


- (IBAction)onTap:(id)sender {
    if (sender != self.billTextField) {
        [self.view endEditing:YES];
    }
    [self updateValues];
}


- (void)updateValues {
    float billAmount = [self.billTextField.text floatValue];
    
    float tipAmount = billAmount * tipValues[self.tipControl.selectedSegmentIndex];
    float totalAmount = tipAmount + billAmount;
    
    self.tipLabel.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithFloat:tipAmount]];
    self.totalLabel.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithFloat:totalAmount]];
}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

@end
