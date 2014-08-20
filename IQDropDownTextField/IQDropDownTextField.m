//
//  IQDropDownTextField.m
//
//  Created by Iftekhar on 19/10/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import "IQDropDownTextField.h"

@interface IQDropDownTextField () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIDatePicker *timePicker;
@property (nonatomic, strong) NSDateFormatter *dropDownDateFormatter;
@property (nonatomic, strong) NSDateFormatter *dropDownTimeFormatter;

@end

@implementation IQDropDownTextField

#pragma mark - Initialization

- (void)initialize
{
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self setBorderStyle:UITextBorderStyleRoundedRect];
    [self setDelegate:self];
    
    self.dropDownDateFormatter = [[NSDateFormatter alloc] init];
    [self.dropDownDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.dropDownTimeFormatter = [[NSDateFormatter alloc] init];
    [self.dropDownTimeFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.dropDownTimeFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    self.pickerView = [[UIPickerView alloc] init];
    [self.pickerView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [self.pickerView setShowsSelectionIndicator:YES];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    
    self.datePicker = [[UIDatePicker alloc] init];
    [self.datePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.timePicker = [[UIDatePicker alloc] init];
    [self.timePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [self.timePicker setDatePickerMode:UIDatePickerModeTime];
    [self.timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    
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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

#pragma mark - UITextField overrides

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

#pragma mark - UIPickerView data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _itemList.count;
}

#pragma mark UIPickerView delegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *labelText = [[UILabel alloc] init];
    labelText.font = [UIFont boldSystemFontOfSize:20.0];
    labelText.backgroundColor = [UIColor clearColor];
    [labelText setTextAlignment:NSTextAlignmentCenter];
    [labelText setText:[_itemList objectAtIndex:row]];
    return labelText;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setSelectedItem:[_itemList objectAtIndex:row]];
}

#pragma mark - UIDatePicker delegate

- (void)dateChanged:(UIDatePicker *)dPicker
{
    [self setSelectedItem:[self.dropDownDateFormatter stringFromDate:dPicker.date]];
}

- (void)timeChanged:(UIDatePicker *)tPicker
{
    [self setSelectedItem:[self.dropDownTimeFormatter stringFromDate:tPicker.date]];
}

#pragma mark - Setters

- (void)setDropDownMode:(IQDropDownMode)dropDownMode
{
    _dropDownMode = dropDownMode;

    switch (_dropDownMode)
    {
        case IQDropDownModeTextPicker:
            self.inputView = self.pickerView;
            break;
        case IQDropDownModeDatePicker:
            self.inputView = self.datePicker;
            break;
        case IQDropDownModeTimePicker:
            self.inputView = self.timePicker;
            break;
        default:
            break;
    }
}

- (void)setItemList:(NSArray *)itemList
{
    _itemList = itemList;
    
    if ([self.text length] == 0 && [_itemList count] > 0)
    {
//        [self setText:[_itemList objectAtIndex:0]];
    }
    [self.pickerView reloadAllComponents];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
    [self setSelectedItem:[self.dropDownDateFormatter stringFromDate:date]];
}

- (void)setDateFormatter:(NSDateFormatter *)userDateFormatter
{
    self.dropDownDateFormatter = userDateFormatter;
    [self.datePicker setLocale:self.dropDownDateFormatter.locale];
}

- (void)setTimeFormatter:(NSDateFormatter *)userTimeFormatter
{
    self.dropDownTimeFormatter = userTimeFormatter;
    [self.timePicker setLocale:self.dropDownTimeFormatter.locale];
}

- (void)selectRow:(NSInteger)row animated:(BOOL)animated
{
    if (row < [_itemList count]) {
        self.text = @"";
        [self insertText:_itemList[row]];
        [self.pickerView selectRow:row inComponent:0 animated:animated];
    }
}

- (void)setSelectedItem:(NSString *)selectedItem
{
    switch (_dropDownMode) {
        case IQDropDownModeTextPicker:
            if ([_itemList containsObject:selectedItem])
            {
                _selectedItem = selectedItem;
                self.text = @"";
                [self insertText:selectedItem];
                [self.pickerView selectRow:[_itemList indexOfObject:selectedItem] inComponent:0 animated:YES];
            }
            break;
        case IQDropDownModeDatePicker:
        {
            NSDate *date = [self.dropDownDateFormatter dateFromString:selectedItem];
            if (date)
            {
                _selectedItem = selectedItem;
                self.text = @"";
                [self insertText:selectedItem];
                [self.datePicker setDate:date animated:YES];
            }
            else {
                NSLog(@"Invalid date or date format:%@",selectedItem);
            }
            break;
        }
        case IQDropDownModeTimePicker:
        {
            NSDate *date = [self.dropDownTimeFormatter dateFromString:selectedItem];
            if (date)
            {
                _selectedItem = selectedItem;
                self.text = @"";
                [self insertText:selectedItem];
                [self.timePicker setDate:date animated:YES];
            }
            else
            {
                NSLog(@"Invalid time or time format:%@",selectedItem);
            }
            break;
        }
    }
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    if (_dropDownMode == IQDropDownModeDatePicker)
    {
        _datePickerMode = datePickerMode;
        [self.datePicker setDatePickerMode:datePickerMode];
        
        switch (datePickerMode) {
            case UIDatePickerModeCountDownTimer:
                [self.dropDownDateFormatter setDateStyle:NSDateFormatterNoStyle];
                [self.dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];
                break;
            case UIDatePickerModeDate:
                [self.dropDownDateFormatter setDateStyle:NSDateFormatterShortStyle];
                [self.dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];
                break;
            case UIDatePickerModeTime:
                [self.dropDownDateFormatter setDateStyle:NSDateFormatterNoStyle];
                [self.dropDownDateFormatter setTimeStyle:NSDateFormatterShortStyle];
                break;
            case UIDatePickerModeDateAndTime:
                [self.dropDownDateFormatter setDateStyle:NSDateFormatterShortStyle];
                [self.dropDownDateFormatter setTimeStyle:NSDateFormatterShortStyle];
                break;
        }
    }
}

- (void)setDatePickerMaximumDate:(NSDate*)date
{
    if (_dropDownMode == IQDropDownModeDatePicker)
    {
        self.datePicker.maximumDate = date;
    }
}

#pragma mark - Getter

- (NSInteger)selectedRow {
    return [self.pickerView selectedRowInComponent:0];
}

@end
