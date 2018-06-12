//
//  APXCustomFieldsViewController.m
//  NewSDKTestApplication
//
//  Created by Raz Elkayam on 4/14/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import "APXCustomFieldsViewController.h"
#import <AppoxeeSDK/AppoxeeSDK.h>

@interface APXCustomFieldsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@property (weak, nonatomic) IBOutlet UIButton *setFieldButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *incrementFieldButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *getFieldButtonOutlet;

@property (weak, nonatomic) IBOutlet UIView *pickerContainerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerTopConstraint;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation APXCustomFieldsViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Custom Fields";
    self.keyTextField.delegate = self;
    self.valueTextField.delegate = self;
    [self.segmentController setSelectedSegmentIndex:0];
    self.incrementFieldButtonOutlet.enabled = NO;
}

#pragma mark - Custom Fields

- (void)setString:(NSString *)string forKey:(NSString *)key
{
    [self.activityIndicator startAnimating];
    
    [[Appoxee shared] setStringValue:string forKey:key withCompletionHandler:^(NSError * _Nullable appoxeeError, id  _Nullable data) {
        
        [self.activityIndicator stopAnimating];
        
        [self clearView];
        
        if (!appoxeeError) {
            
            NSString *msg = [NSString stringWithFormat:@"operation was succesfull.\nupdated data:\n%@ for key: %@", string, key];
            
            [[[UIAlertView alloc] initWithTitle:@"Success" message:msg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
            
        } else {
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (void)setDateField:(NSDate *)date withKey:(NSString *)key
{
    [self.activityIndicator startAnimating];
    
    [[Appoxee shared] setDateValue:date forKey:key withCompletionHandler:^(NSError * _Nullable appoxeeError, id  _Nullable data) {
        
        [self.activityIndicator stopAnimating];
        
        [self clearView];
        
        if (!appoxeeError) {
            
            NSString *msg = [NSString stringWithFormat:@"operation was succesfull.\nupdated date:\n%@ for key: %@", date, key];
            
            [[[UIAlertView alloc] initWithTitle:@"Success" message:msg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
            
        } else {
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (void)setNumber:(NSString *)number forKey:(NSString *)key
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *possibleNumber = [numberFormatter numberFromString:number];
    
    if (possibleNumber && key) {
        
        [self.activityIndicator startAnimating];
        
        [[Appoxee shared] setNumberValue:possibleNumber forKey:key withCompletionHandler:^(NSError * _Nullable appoxeeError, id  _Nullable data) {
            
            [self.activityIndicator stopAnimating];
            
            [self clearView];
            
            if (!appoxeeError) {
                
                NSString *msg = [NSString stringWithFormat:@"operation was succesfull.\nupdated data:\n%@ for key: %@", possibleNumber, key];
                
                [[[UIAlertView alloc] initWithTitle:@"Success" message:msg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                
            } else {
                
                [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            
            
        }];
        
    } else {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please input a numeric value" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }
}

#pragma mark - IBActions

- (IBAction)segmentedControllerValueChanged:(UISegmentedControl *)sender
{
    [self.view endEditing:YES];
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            self.incrementFieldButtonOutlet.enabled = NO;
            self.valueTextField.enabled = YES;
            self.valueTextField.keyboardType = UIKeyboardTypeDefault;
            [self hidePicker];
        }
            break;
        case 1:
        {
            self.incrementFieldButtonOutlet.enabled = NO;
            self.valueTextField.enabled = NO;
            self.valueTextField.keyboardType = UIKeyboardTypeDefault;
            [self showPicker];
        }
            break;
        case 2:
        {
            self.incrementFieldButtonOutlet.enabled = YES;
            self.valueTextField.enabled = YES;
            self.valueTextField.keyboardType = UIKeyboardTypeDecimalPad;
            [self hidePicker];
        }
            break;
    }
}

- (IBAction)setCustomFieldButtonPressed:(id)sender
{
    if ([self.keyTextField.text length]) {
        
        switch (self.segmentController.selectedSegmentIndex) {
            case 0:
            {
                [self setString:self.valueTextField.text forKey:self.keyTextField.text];
            }
                break;
            case 1:
            {
                [self setDateField:self.datePicker.date withKey:self.keyTextField.text];
            }
                break;
            case 2:
            {
                [self setNumber:self.valueTextField.text forKey:self.keyTextField.text];
            }
                break;
        }
        
    } else {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please input values" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }
}

- (IBAction)incrementCustomFieldButtonPressed:(id)sender
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *possibleNumber = [numberFormatter numberFromString:self.valueTextField.text];
    
    if (possibleNumber) {
        
        [self.activityIndicator startAnimating];
        
        [[Appoxee shared] incrementNumericKey:self.keyTextField.text byNumericValue:possibleNumber withCompletionHandler:^(NSError * _Nullable appoxeeError, id  _Nullable data) {
            
            [self.activityIndicator stopAnimating];
            
            [self clearView];
            
            if (!appoxeeError) {
                
                NSString *msg = [NSString stringWithFormat:@"operation was succesfull.\nupdated data:\n%@ for key: %@", possibleNumber, self.keyTextField.text];
                
                [[[UIAlertView alloc] initWithTitle:@"Success" message:msg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                
            } else {
                
                [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            
        }];
        
    } else {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please input a numeric value" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }
}

- (IBAction)getCustomFieldButtonPressed:(id)sender
{
    if ([self.keyTextField.text length]) {
        
        [self.activityIndicator startAnimating];
        
        [[Appoxee shared] fetchCustomFieldByKey:self.keyTextField.text withCompletionHandler:^(NSError *appoxeeError, id data) {
            
            [self.activityIndicator stopAnimating];
            
            if (!appoxeeError && [data isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dictionary = (NSDictionary *)data;
                
                NSString *key = [[dictionary allKeys] firstObject];
                id value = dictionary[key];
                
                self.valueTextField.text = [value description];
                
            } else {
                
                [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
        
    } else {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please input values" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }
}

- (IBAction)okButtonPressed:(id)sender
{
    self.valueTextField.text = [self.datePicker.date description];
    [self hidePicker];
}

- (IBAction)cancelCButtonPressed:(id)sender
{
    self.valueTextField.text = @"";
    [self hidePicker];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UI

- (void)showPicker
{
    self.datePickerTopConstraint.constant = -self.pickerContainerView.frame.size.height;
    
    [UIView animateWithDuration:0.33f animations:^{
        
        [self.view layoutIfNeeded];
        
    }];
}

- (void)hidePicker
{
    self.datePickerTopConstraint.constant = 0;
    
    [UIView animateWithDuration:0.33f animations:^{
        
        [self.view layoutIfNeeded];
        
    }];
}

- (void)clearView
{
    self.valueTextField.text = @"";
    self.keyTextField.text = @"";
    [self.view endEditing:YES];
    [self hidePicker];
}

@end
