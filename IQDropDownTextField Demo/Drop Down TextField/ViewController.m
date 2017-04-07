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
//    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
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
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];

    UISwitch *aSwitch = [[UISwitch alloc] init];
    
    [textFieldTextPicker setItemList:[NSArray arrayWithObjects:@"London",@"Johannesburg",@"Moscow",@"Mumbai",@"Tokyo",@"Sydney",@"Mumbai",@"Tokyo",@"Sydney",@"Mumbai",@"Tokyo",@"Sydney", nil]];
    [textFieldTextPicker setItemListView:@[[NSNull null],indicator,[NSNull null],aSwitch,[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null]]];
    
    /*  
        Uncomment the following lines to set a custom font or text color for the items, as well as a custom text color for
        the optional item.
     */
//    textFieldTextPicker.font = [UIFont fontWithName:@"Montserrat-Regular" size:16];
//    textFieldTextPicker.textColor = [UIColor redColor];
//    textFieldTextPicker.optionalItemTextColor = [UIColor brownColor];

    [textFieldOptionalTextPicker setItemList:[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil]];
    [textFieldOptionalTextPicker setItemListUI:[NSArray arrayWithObjects:@"1 Year Old",@"2 Years Old",@"3 Years Old",@"4 Years Old",@"5 Years Old",@"6 Years Old", nil]];

    [textFieldDatePicker setDropDownMode:IQDropDownModeDatePicker];
    
    [textFieldTimePicker setDropDownMode:IQDropDownModeTimePicker];
    
    [textFieldDateTimePicker setDropDownMode:IQDropDownModeDateTimePicker];
}

-(void)textField:(nonnull IQDropDownTextField*)textField didSelectItem:(nonnull NSString*)item
{
    NSLog(@"%@: %@",NSStringFromSelector(_cmd),item);
}

-(void)textField:(IQDropDownTextField *)textField didSelectDate:(NSDate *)date
{
    NSLog(@"%@: %@",NSStringFromSelector(_cmd),date);
}

-(BOOL)textField:(nonnull IQDropDownTextField*)textField canSelectItem:(nullable NSString*)item
{
    NSLog(@"%@: %@",NSStringFromSelector(_cmd),item);
    return YES;
}

-(IQProposedSelection)textField:(nonnull IQDropDownTextField*)textField proposedSelectionModeForItem:(nullable NSString*)item
{
    NSLog(@"%@: %@",NSStringFromSelector(_cmd),item);
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
