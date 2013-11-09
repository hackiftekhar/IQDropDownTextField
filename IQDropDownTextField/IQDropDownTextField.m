//
//  IQDropDownTextField.m
//
//  Created by Iftekhar on 19/10/13.
//  Copyright (c) 2013 Canopus. All rights reserved.
//

#import "IQDropDownTextField.h"

@interface IQDropDownTextField ()<UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation IQDropDownTextField
{
    UIPickerView *pickerView;
    UIDatePicker *datePicker;
    NSDateFormatter *dropDownDateFormatter;
}

-(void)initialize
{
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self setBorderStyle:UITextBorderStyleRoundedRect];
    [self setDelegate:self];
    
    dropDownDateFormatter = [[NSDateFormatter alloc] init];
    [dropDownDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];

    pickerView = [[UIPickerView alloc] init];
    [pickerView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [pickerView setShowsSelectionIndicator:YES];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self setDropDownMode:IQDropDownModeTextPicker];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)setDropDownMode:(IQDropDownMode)dropDownMode
{
    _dropDownMode = dropDownMode;
    
    switch (_dropDownMode)
    {
        case IQDropDownModeTextPicker:
            self.inputView = pickerView;
            break;

        case IQDropDownModeDatePicker:
            self.inputView = datePicker;
            break;

        default:
            break;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _itemList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_itemList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setSelectedItem:[_itemList objectAtIndex:row]];
}

-(void)dateChanged:(UIDatePicker*)dPicker
{
    [self setSelectedItem:[dropDownDateFormatter stringFromDate:dPicker.date]];
}

-(void)setItemList:(NSArray *)itemList
{
    _itemList = itemList;
    
    if ([self.text length] == 0 && [_itemList count] > 0)
    {
//        [self setText:[_itemList objectAtIndex:0]];
    }
    
    [pickerView reloadAllComponents];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
    [self setSelectedItem:[dropDownDateFormatter stringFromDate:date]];
}


-(void)setSelectedItem:(NSString *)selectedItem
{
    switch (_dropDownMode)
    {
        case IQDropDownModeTextPicker:
            if ([_itemList containsObject:selectedItem])
            {
                _selectedItem = selectedItem;
                [self setText:selectedItem];
                [pickerView selectRow:[_itemList indexOfObject:selectedItem] inComponent:0 animated:YES];
            }
            break;
            
        case IQDropDownModeDatePicker:
        {
            NSDate *date = [dropDownDateFormatter dateFromString:selectedItem];
            if (date)
            {
                _selectedItem = selectedItem;
                [self setText:selectedItem];
                [datePicker setDate:date animated:YES];
            }
            else
            {
                NSLog(@"Invalid date or date format:%@",selectedItem);
            }
        }
            
            break;
    }
}

-(void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    if (_dropDownMode == IQDropDownModeDatePicker)
    {
        _datePickerMode = datePickerMode;
        [datePicker setDatePickerMode:datePickerMode];
        
        switch (datePickerMode) {
            case UIDatePickerModeCountDownTimer:
                [dropDownDateFormatter setDateStyle:NSDateFormatterNoStyle];
                [dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];
                break;
            case UIDatePickerModeDate:
                [dropDownDateFormatter setDateStyle:NSDateFormatterShortStyle];
                [dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];
                break;
            case UIDatePickerModeTime:
                [dropDownDateFormatter setDateStyle:NSDateFormatterNoStyle];
                [dropDownDateFormatter setTimeStyle:NSDateFormatterShortStyle];
                break;
            case UIDatePickerModeDateAndTime:
                [dropDownDateFormatter setDateStyle:NSDateFormatterShortStyle];
                [dropDownDateFormatter setTimeStyle:NSDateFormatterShortStyle];
                break;
        }
    }
}

@end
