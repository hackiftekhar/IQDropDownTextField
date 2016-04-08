//
//  ViewController.m
//  Drop Down TextField
//
//  Created by hp on 10/11/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<IQDropDownTextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    textFieldDatePicker.inputAccessoryView = toolbar;
    textFieldTextPicker.inputAccessoryView = toolbar;
    textFieldTimePicker.inputAccessoryView = toolbar;
    textFieldDateTimePicker.inputAccessoryView = toolbar;
    textFieldOptionalTextPicker.inputAccessoryView = toolbar;
    
    textFieldTextPicker.isOptionalDropDown = NO;
    [textFieldTextPicker setItemList:[NSArray arrayWithObjects:@"London",@"Johannesburg",@"Moscow",@"Mumbai",@"Tokyo",@"Sydney", nil]];
    [textFieldOptionalTextPicker setItemList:[NSArray arrayWithObjects:@"London",@"Johannesburg",@"Moscow",@"Mumbai",@"Tokyo",@"Sydney", nil]];

    [textFieldDatePicker setDropDownMode:IQDropDownModeDatePicker];
    
    [textFieldTimePicker setDropDownMode:IQDropDownModeTimePicker];
    
    [textFieldDateTimePicker setDropDownMode:IQDropDownModeDateTimePicker];
}

-(void)textField:(nonnull IQDropDownTextField*)textField didSelectItem:(nullable NSString*)item
{
    NSLog(@"%@: %@",textField,NSStringFromSelector(_cmd));
}

-(BOOL)textField:(nonnull IQDropDownTextField*)textField canSelectItem:(nullable NSString*)item
{
    NSLog(@"%@: %@",textField,NSStringFromSelector(_cmd));
    return YES;
}

-(IQProposedSelection)textField:(nonnull IQDropDownTextField*)textField proposedSelectionModeForItem:(nullable NSString*)item
{
    NSLog(@"%@: %@",textField,NSStringFromSelector(_cmd));
    return IQProposedSelectionBoth;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
