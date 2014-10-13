//
//  IQDropDownTextField.m
//
//  Created by Iftekhar on 19/10/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import "IQDropDownTextField.h"

@interface IQDropDownTextField () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *_ItemListsInternal;
}

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
    [self setIsOptionalDropDown:YES];
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
    return _ItemListsInternal.count;
}

#pragma mark UIPickerView delegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *labelText = [[UILabel alloc] init];
    [labelText setTextAlignment:NSTextAlignmentCenter];
    [labelText setText:[_ItemListsInternal objectAtIndex:row]];
    labelText.backgroundColor = [UIColor clearColor];

    if (self.isOptionalDropDown && row == 0)
    {
        labelText.font = [UIFont boldSystemFontOfSize:30.0];
        labelText.textColor = [UIColor lightGrayColor];
    }
    else
    {
        labelText.font = [UIFont boldSystemFontOfSize:20.0];
        labelText.textColor = [UIColor blackColor];
    }
    return labelText;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setSelectedItem:[_ItemListsInternal objectAtIndex:row]];
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
    
    //Refreshing pickerView
    [self setIsOptionalDropDown:_isOptionalDropDown];
    
    if ([self.text length] == 0)
    {
        [self selectRow:0 animated:NO];
    }

}

-(NSDate *)date
{
    switch (self.dropDownMode)
    {
        case IQDropDownModeDatePicker:  return  self.datePicker.date;   break;
        case IQDropDownModeTimePicker:  return  self.timePicker.date;   break;
        default:                        return nil;                     break;
    }
}

-(void)setDate:(NSDate *)date
{
    [self setDate:date animated:NO];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
    [self setSelectedItem:[self.dropDownDateFormatter stringFromDate:date] animated:animated];
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
    if (row < [_ItemListsInternal count])
    {
        if (self.isOptionalDropDown && row == 0)
        {
            self.text = @"";
        }
        else
        {
            self.text = _ItemListsInternal[row];
        }
        
        [self.pickerView selectRow:row inComponent:0 animated:animated];
    }
}

-(void)setSelectedItem:(NSString *)selectedItem
{
    [self setSelectedItem:selectedItem animated:NO];
}

-(void)setSelectedItem:(NSString *)selectedItem animated:(BOOL)animated
{
    switch (_dropDownMode)
    {
        case IQDropDownModeTextPicker:
            if ([_ItemListsInternal containsObject:selectedItem])
            {
                _selectedItem = selectedItem;
                
                [self selectRow:[_ItemListsInternal indexOfObject:selectedItem] animated:animated];
            }
            break;
        case IQDropDownModeDatePicker:
        {
            NSDate *date = [self.dropDownDateFormatter dateFromString:selectedItem];
            if (date)
            {
                _selectedItem = selectedItem;
                self.text = selectedItem;
                [self.datePicker setDate:date animated:animated];
            }
            else
            {
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
                self.text = selectedItem;
                [self.timePicker setDate:date animated:animated];
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

-(void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;
    
    self.datePicker.minimumDate = minimumDate;
    self.timePicker.minimumDate = minimumDate;
}

-(void)setMaximumDate:(NSDate *)maximumDate
{
    _maximumDate = maximumDate;
    
    self.datePicker.maximumDate = maximumDate;
    self.timePicker.maximumDate = maximumDate;
}

-(void)setIsOptionalDropDown:(BOOL)isOptionalDropDown
{
    _isOptionalDropDown = isOptionalDropDown;
    
    if (_isOptionalDropDown)
    {
        NSArray *array = [[NSArray alloc] initWithObjects:@"Select", nil];
        _ItemListsInternal = [array arrayByAddingObjectsFromArray:_itemList];
    }
    else
    {
        _ItemListsInternal = [_itemList copy];
    }
    
    [self.pickerView reloadAllComponents];
}

#pragma mark - Getter

- (NSInteger)selectedRow
{
    if (self.isOptionalDropDown)
    {
        return [self.pickerView selectedRowInComponent:0]-1;
    }
    else
    {
        return [self.pickerView selectedRowInComponent:0];
    }
}


-(NSDateComponents *)dateComponents
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.date];
}

- (NSInteger)year   {   return [[self dateComponents] year];    }
- (NSInteger)month  {   return [[self dateComponents] month];   }
- (NSInteger)day    {   return [[self dateComponents] day]; }
- (NSInteger)hour   {   return [[self dateComponents] hour];    }
- (NSInteger)minute {   return [[self dateComponents] minute];  }
- (NSInteger)second {   return [[self dateComponents] second];  }

@end
