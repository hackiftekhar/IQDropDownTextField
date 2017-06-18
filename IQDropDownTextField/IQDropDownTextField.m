//
//  IQDropDownTextField.m
// https://github.com/hackiftekhar/IQDropDownTextField
// Copyright (c) 2013-15 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "IQDropDownTextField.h"

NSInteger const IQOptionalTextFieldIndex =  -1;

@interface IQDropDownTextField () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *_ItemListsInternal;
}

@property (nonatomic, strong) NSDateFormatter *dropDownDateFormatter;
@property (nonatomic, strong) NSDateFormatter *dropDownTimeFormatter;

@property BOOL hasSetInitialIsOptional;

@end

@implementation IQDropDownTextField

@synthesize dropDownMode = _dropDownMode;
@synthesize itemList = _itemList;
@synthesize isOptionalDropDown = _isOptionalDropDown;
@synthesize datePickerMode = _datePickerMode;
@synthesize optionalItemText = _optionalItemText;
@synthesize adjustPickerLabelFontSizeWidth = _adjustPickerLabelFontSizeWidth;

@synthesize dropDownFont = _dropDownFont;
@synthesize dropDownTextColor = _dropDownTextColor;
@synthesize optionalItemTextColor = _optionalItemTextColor;

@dynamic delegate;
@dynamic text;
@dynamic attributedText;

@synthesize pickerView = _pickerView, datePicker = _datePicker, timePicker = _timePicker, dateTimePicker = _dateTimePicker;
@synthesize dropDownDateFormatter,dropDownTimeFormatter, dropDownDateTimeFormater;
@synthesize dateFormatter, timeFormatter;

#pragma mark - NSObject

- (void)dealloc {
    [_pickerView setDelegate:nil];
    [_pickerView setDataSource:nil];
    [_datePicker removeTarget:nil action:NULL forControlEvents:UIControlEventValueChanged];
    [_timePicker removeTarget:nil action:NULL forControlEvents:UIControlEventValueChanged];
    [_dateTimePicker removeTarget:nil action:NULL forControlEvents:UIControlEventValueChanged];
    _pickerView = nil;
    _datePicker = nil;
    _dateTimePicker = nil;
    dropDownDateFormatter = nil;
    dropDownTimeFormatter = nil;
    _ItemListsInternal = nil;
    self.delegate = nil;
    _dataSource = nil;
    _optionalItemText = nil;
    _itemList = nil;
    _dropDownFont = nil;
    _dropDownTextColor = nil;
    _optionalItemTextColor = nil;
}

#pragma mark - Initialization

- (void)initialize
{
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    if (self.optionalItemText == nil)
    {
        self.optionalItemText = NSLocalizedString(@"Select", nil);
    }
    
    if (self.dropDownDateFormatter == nil && [[[self class] appearance] dateFormatter])
    {
        self.dropDownDateFormatter = [[NSDateFormatter alloc] init];
        self.dropDownDateFormatter = [[[self class] appearance] dateFormatter];
    }
    else if (self.dropDownDateFormatter == nil)
    {
        self.dropDownDateFormatter = [[NSDateFormatter alloc] init];
        [self.dropDownDateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [self.dropDownDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    
    if (self.dropDownTimeFormatter == nil)
    {
        self.dropDownTimeFormatter = [[NSDateFormatter alloc] init];
        [self.dropDownTimeFormatter setDateStyle:NSDateFormatterNoStyle];
        [self.dropDownTimeFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    if (self.dropDownDateTimeFormater == nil)
    {
        self.dropDownDateTimeFormater = [[NSDateFormatter alloc] init];
        [self.dropDownDateTimeFormater setDateStyle:NSDateFormatterMediumStyle];
        [self.dropDownDateTimeFormater setTimeStyle:NSDateFormatterShortStyle];
    }
    
    //These will update the UI and other components, all the validation added if awakeFromNib for textField is called after custom UIView awakeFromNib call
    {
        self.dropDownMode = self.dropDownMode;

        self.isOptionalDropDown = self.hasSetInitialIsOptional?self.isOptionalDropDown:YES;
        self.adjustPickerLabelFontSizeWidth = self.adjustPickerLabelFontSizeWidth;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

#pragma mark - UITextField overrides

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    if (self.dropDownMode == IQDropDownModeTextField) {
        return [super caretRectForPosition:position];
    } else {
        return CGRectZero;
    }
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
    if (_itemListView.count > row && [_itemListView[row] isKindOfClass:[UIView class]])
    {
        //Archiving and Unarchiving is necessary to copy UIView instance.
        NSData *viewData = [NSKeyedArchiver archivedDataWithRootObject:_itemListView[row]];
        UIView *copyOfView = [NSKeyedUnarchiver unarchiveObjectWithData:viewData];
        
        return copyOfView;
    }
    else
    {
        UILabel *labelText = (UILabel*)view;
        
        if (labelText == nil)
        {
            labelText = [[UILabel alloc] init];
            [labelText setTextAlignment:NSTextAlignmentCenter];
            [labelText setAdjustsFontSizeToFitWidth:YES];
            labelText.backgroundColor = [UIColor clearColor];
            labelText.backgroundColor = [UIColor clearColor];
        }
        
        NSString *text = [_ItemListsInternal objectAtIndex:row];
        
        [labelText setText:text];
        
        if (self.isOptionalDropDown && row == 0)
        {
            if (_dropDownFont) {
                if (_dropDownFont.pointSize < 30) {
                    labelText.font = [_dropDownFont fontWithSize:30];
                } else {
                    labelText.font = _dropDownFont;
                }
            } else {
                labelText.font = [UIFont boldSystemFontOfSize:30.0];
            }
            labelText.textColor = _optionalItemTextColor ? _optionalItemTextColor : [UIColor lightGrayColor];
        }
        else
        {
            if (_dropDownFont) {
                labelText.font = _dropDownFont;
            } else {
                labelText.font = [UIFont boldSystemFontOfSize:18.0];
            }
            
            BOOL canSelect = YES;
            
            if ([self.dataSource respondsToSelector:@selector(textField:canSelectItem:)])
            {
                canSelect = [self.dataSource textField:self canSelectItem:text];
            }
            
            if (canSelect)
            {
                if (_dropDownTextColor) {
                    labelText.textColor = _dropDownTextColor;
                } else {
                    labelText.textColor = [UIColor blackColor];
                }
            }
            else
            {
                labelText.textColor = [UIColor lightGrayColor];
            }
            
            labelText.adjustsFontSizeToFitWidth = self.adjustPickerLabelFontSizeWidth;
        }
        return labelText;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *text = [_ItemListsInternal objectAtIndex:row];
    
    BOOL canSelect = YES;
    
    if ([self.dataSource respondsToSelector:@selector(textField:canSelectItem:)])
    {
        canSelect = [self.dataSource textField:self canSelectItem:text];
    }
    
    if (canSelect)
    {
        [self setSelectedItem:[_ItemListsInternal objectAtIndex:row] animated:NO shouldNotifyDelegate:YES];
    }
    else
    {
        IQProposedSelection proposedSelection = IQProposedSelectionBoth;
        
        if ([self.dataSource respondsToSelector:@selector(textField:proposedSelectionModeForItem:)])
        {
            proposedSelection = [self.dataSource textField:self proposedSelectionModeForItem:text];
        }
        
        NSInteger aboveIndex = row-1;
        NSInteger belowIndex = row+1;
        
        if (proposedSelection == IQProposedSelectionAbove)
        {
            belowIndex = _ItemListsInternal.count;
        }
        else if (proposedSelection == IQProposedSelectionBelow)
        {
            aboveIndex = -1;
        }
        
        
        while (aboveIndex >= 0 || belowIndex < _ItemListsInternal.count)
        {
            if (aboveIndex >= 0)
            {
                NSString *aboveText = [_ItemListsInternal objectAtIndex:aboveIndex];
                
                if ([self.dataSource textField:self canSelectItem:aboveText])
                {
                    [self setSelectedItem:aboveText animated:YES shouldNotifyDelegate:YES];
                    return;
                }
                
                aboveIndex--;
            }
            
            if (belowIndex < _ItemListsInternal.count)
            {
                NSString *belowText = [_ItemListsInternal objectAtIndex:aboveIndex];
                
                if ([self.dataSource textField:self canSelectItem:belowText])
                {
                    [self setSelectedItem:belowText animated:YES shouldNotifyDelegate:YES];
                    return;
                }
                
                belowIndex++;
            }
        }
        
        return [self setSelectedRow:0 animated:YES];
    }
}

#pragma mark - UIDatePicker delegate

- (void)dateChanged:(UIDatePicker *)dPicker
{
    [self setSelectedItem:[self.dropDownDateFormatter stringFromDate:dPicker.date] animated:NO shouldNotifyDelegate:YES];
}

- (void)timeChanged:(UIDatePicker *)tPicker
{
    [self setSelectedItem:[self.dropDownTimeFormatter stringFromDate:tPicker.date] animated:NO shouldNotifyDelegate:YES];
}

- (void)dateTimeChanged:(UIDatePicker *)dtPicker
{
    [self setSelectedItem:[self.dropDownDateTimeFormater stringFromDate:dtPicker.date] animated:NO shouldNotifyDelegate:YES];
}

#pragma mark - Selected Row

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

-(void)setSelectedRow:(NSInteger)selectedRow
{
    [self setSelectedRow:selectedRow animated:NO];
}

- (void)setSelectedRow:(NSInteger)row animated:(BOOL)animated
{
    if (row < [_itemList count]+1)
    {
        if (self.isOptionalDropDown)
        {
            if (row == IQOptionalTextFieldIndex)
            {
                super.text = @"";
            }
            else
            {
                super.text = (row == 0) ? @"" : [_itemListUI?:_itemList objectAtIndex:row-1];
            }
            [self.pickerView selectRow:row inComponent:0 animated:animated];
        }
        else
        {
            super.text = [_itemListUI?:_itemList objectAtIndex:row];
            [self.pickerView selectRow:row inComponent:0 animated:animated];
        }
    }
}

#pragma mark - Setters
- (void)setDropDownMode:(IQDropDownMode)dropDownMode
{
    _dropDownMode = dropDownMode;
    
    switch (_dropDownMode)
    {
        case IQDropDownModeTextPicker:
        {
            self.inputView = self.pickerView;
            [self setSelectedRow:self.selectedRow animated:YES];
        }
            break;
        case IQDropDownModeDatePicker:
        {
            self.inputView = self.datePicker;
            
            if (self.isOptionalDropDown == NO)
            {
                [self setDate:self.datePicker.date];
            }
        }
            break;
        case IQDropDownModeTimePicker:
        {
            self.inputView = self.timePicker;
            
            if (self.isOptionalDropDown == NO)
            {
                [self setDate:self.timePicker.date];
            }
        }
            break;
        case IQDropDownModeDateTimePicker:
        {
            self.inputView = self.dateTimePicker;
            
            if (self.isOptionalDropDown == NO)
            {
                [self setDate:self.dateTimePicker.date];
            }
        }
            break;
        case IQDropDownModeTextField:
        {
            self.inputView = nil;
        }
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
    
    [self setSelectedRow:self.selectedRow];
}

-(NSDate *)date
{
    switch (self.dropDownMode)
    {
        case IQDropDownModeDatePicker:
        {
            if (self.isOptionalDropDown)
            {
                return  [super.text length]  ?   [self.datePicker.date copy]    :   nil;    break;
            }
            else
            {
                return [self.datePicker.date copy];
            }
        }
        case IQDropDownModeTimePicker:
        {
            if (self.isOptionalDropDown)
            {
                return  [super.text length]  ?   [self.timePicker.date copy]    :   nil;    break;
            }
            else
            {
                return [self.timePicker.date copy];
            }
        }
        case IQDropDownModeDateTimePicker:
        {
            if (self.isOptionalDropDown)
            {
                return  [super.text length]  ?   [self.dateTimePicker.date copy]    :   nil;    break;
            }
            else
            {
                return [self.dateTimePicker.date copy];
            }
        }
        default:                        return  nil;                     break;
    }
}

-(void)setDate:(NSDate *)date
{
    [self setDate:date animated:NO];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
    switch (_dropDownMode)
    {
        case IQDropDownModeDatePicker:
            [self setSelectedItem:[self.dropDownDateFormatter stringFromDate:date] animated:animated shouldNotifyDelegate:NO];
            break;
        case IQDropDownModeTimePicker:
            [self setSelectedItem:[self.dropDownTimeFormatter stringFromDate:date] animated:animated shouldNotifyDelegate:NO];
            break;
        case IQDropDownModeDateTimePicker:
            [self setSelectedItem:[self.dropDownDateTimeFormater stringFromDate:date] animated:animated shouldNotifyDelegate:NO];
            break;
        default:
            break;
    }
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

- (void)setDateTimeFormatter:(NSDateFormatter *)userTimeFormatter
{
    self.dropDownDateTimeFormater = userTimeFormatter;
    [self.dateTimePicker setLocale:self.dropDownDateTimeFormater.locale];
}

- (NSString*)selectedItem
{
    switch (_dropDownMode)
    {
        case IQDropDownModeTextPicker:
        {
            NSInteger selectedRow = -1;
            if (self.isOptionalDropDown)
            {
                selectedRow = [self.pickerView selectedRowInComponent:0]-1;
            }
            else
            {
                selectedRow = [self.pickerView selectedRowInComponent:0];
            }
            
            if (selectedRow >= 0)
            {
                return [_itemList objectAtIndex:selectedRow];
            }
            else
            {
                return nil;
            }
        }
            break;
        case IQDropDownModeDatePicker:
        {
            return  [super.text length]  ?   [self.dropDownDateFormatter stringFromDate:self.datePicker.date]    :   nil;    break;
        }
            break;
        case IQDropDownModeTimePicker:
        {
            return  [super.text length]  ?   [self.dropDownTimeFormatter stringFromDate:self.timePicker.date]    :   nil;    break;
        }
            break;
        case IQDropDownModeDateTimePicker:
        {
            return  [super.text length]  ?   [self.dropDownDateTimeFormater stringFromDate:self.dateTimePicker.date]    :   nil;    break;
        }
            break;
        case IQDropDownModeTextField:
        {
            return super.text;
        }
            break;
    }
}

-(void)setSelectedItem:(NSString *)selectedItem
{
    [self setSelectedItem:selectedItem animated:NO shouldNotifyDelegate:NO];
}

-(void)setSelectedItem:(NSString *)selectedItem animated:(BOOL)animated
{
    [self setSelectedItem:selectedItem animated:animated shouldNotifyDelegate:NO];
}

-(void)setSelectedItem:(NSString *)selectedItem animated:(BOOL)animated shouldNotifyDelegate:(BOOL)shouldNotifyDelegate
{
    switch (_dropDownMode)
    {
        case IQDropDownModeTextPicker:
        {
            if ([_ItemListsInternal containsObject:selectedItem])
            {
                [self setSelectedRow:[_ItemListsInternal indexOfObject:selectedItem] animated:animated];
                
                if (shouldNotifyDelegate && [self.delegate respondsToSelector:@selector(textField:didSelectItem:)])
                    [self.delegate textField:self didSelectItem:selectedItem];
            }
            else if (self.isOptionalDropDown)
            {
                [self setSelectedRow:IQOptionalTextFieldIndex animated:animated];
                
                if (shouldNotifyDelegate && [self.delegate respondsToSelector:@selector(textField:didSelectItem:)])
                    [self.delegate textField:self didSelectItem:nil];
            }
        }
            break;
        case IQDropDownModeDatePicker:
        {
            NSDate *date = [self.dropDownDateFormatter dateFromString:selectedItem];
            if (date)
            {
                super.text = selectedItem;
                [self.datePicker setDate:date animated:animated];
                
                if (shouldNotifyDelegate && [self.delegate respondsToSelector:@selector(textField:didSelectDate:)])
                    [self.delegate textField:self didSelectDate:date];
            }
            else if (self.isOptionalDropDown && [selectedItem length] == 0)
            {
                super.text = @"";
                [self.datePicker setDate:[NSDate date] animated:animated];

                if (shouldNotifyDelegate && [self.delegate respondsToSelector:@selector(textField:didSelectDate:)])
                    [self.delegate textField:self didSelectDate:nil];
            }
            break;
        }
        case IQDropDownModeTimePicker:
        {
            NSDate *date = [self parseTime: selectedItem];
            if (date)
            {
                super.text = selectedItem;
                [self.timePicker setDate:date animated:animated];
                
                if (shouldNotifyDelegate && [self.delegate respondsToSelector:@selector(textField:didSelectDate:)])
                    [self.delegate textField:self didSelectDate:date];
            }
            else if (self.isOptionalDropDown && [selectedItem length] == 0)
            {
                super.text = @"";
                [self.timePicker setDate:[NSDate date] animated:animated];
                
                if (shouldNotifyDelegate && [self.delegate respondsToSelector:@selector(textField:didSelectDate:)])
                    [self.delegate textField:self didSelectDate:nil];
            }
            break;
        }
        case IQDropDownModeDateTimePicker:
        {
            NSDate *date = [self.dropDownDateTimeFormater dateFromString:selectedItem];
            if (date)
            {
                super.text = selectedItem;
                [self.dateTimePicker setDate:date animated:animated];
                
                if (shouldNotifyDelegate && [self.delegate respondsToSelector:@selector(textField:didSelectDate:)])
                    [self.delegate textField:self didSelectDate:date];
            }
            else if (self.isOptionalDropDown && [selectedItem length] == 0)
            {
                super.text = @"";
                [self.dateTimePicker setDate:[NSDate date] animated:animated];
                
                if (shouldNotifyDelegate && [self.delegate respondsToSelector:@selector(textField:didSelectDate:)])
                    [self.delegate textField:self didSelectDate:nil];
            }
            break;
        }
        case IQDropDownModeTextField:{
            super.text = selectedItem;
        }
            break;
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

-(NSString *)optionalItemText
{
    if (_optionalItemText.length)
    {
        return _optionalItemText;
    }
    else
    {
        return NSLocalizedString(@"Select", nil);
    }
}

-(void)setOptionalItemText:(NSString *)optionalItemText
{
    _optionalItemText = [optionalItemText copy];
    
    [self _updateOptionsList];
}

-(BOOL)adjustPickerLabelFontSizeWidth {
    return _adjustPickerLabelFontSizeWidth;
}

-(void)setAdjustPickerLabelFontSizeWidth:(BOOL)adjustPickerLabelFontSizeWidth {
    _adjustPickerLabelFontSizeWidth = adjustPickerLabelFontSizeWidth;
    
    [self _updateOptionsList];
}

-(void)setIsOptionalDropDown:(BOOL)isOptionalDropDown
{
    _isOptionalDropDown = isOptionalDropDown;
    _hasSetInitialIsOptional = YES;
    
    [self _updateOptionsList];
}

- (void) _updateOptionsList {
    if (_isOptionalDropDown)
    {
        NSArray *array = [NSArray arrayWithObject:self.optionalItemText];
        _ItemListsInternal = [array arrayByAddingObjectsFromArray:_itemList];
    }
    else
    {
        _ItemListsInternal = [_itemList copy];
    }
    
    [self.pickerView reloadAllComponents];

    switch (_dropDownMode)
    {
        case IQDropDownModeDatePicker:
        {
            if (self.isOptionalDropDown == NO)
            {
                [self setDate:self.datePicker.date];
            }
        }
            break;
        case IQDropDownModeTimePicker:
        {
            if (self.isOptionalDropDown == NO)
            {
                [self setDate:self.timePicker.date];
            }
        }
            break;
        case IQDropDownModeDateTimePicker:
        {
            if (self.isOptionalDropDown == NO)
            {
                [self setDate:self.dateTimePicker.date];
            }
        }
        case IQDropDownModeTextPicker:
        {
//            [self setSelectedRow:self.selectedRow];
        }
            break;
        default:
            break;
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL isRestrictedAction = (action == @selector(paste:) || action == @selector(cut:));
    if (isRestrictedAction && self.dropDownMode != IQDropDownModeTextField) {
        return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}

- (NSDate *)parseTime:(NSString *)text
{
	NSDate *time = [self.dropDownTimeFormatter dateFromString: text];

    if (time)
    {
        NSDate *day = [NSDate dateWithTimeIntervalSinceReferenceDate: 0];
        NSDateComponents *componentsDay = [[NSCalendar currentCalendar] components: NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate: day];
        NSDateComponents *componentsTime = [[NSCalendar currentCalendar] components: NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate: time];
        componentsDay.hour = componentsTime.hour;
        componentsDay.minute = componentsTime.minute;
        componentsDay.second = componentsTime.second;
        
        return [[NSCalendar currentCalendar] dateFromComponents: componentsDay];
    }
    else
    {
        return nil;
    }
}

#pragma mark - Getter

- (UIPickerView *) pickerView {
    if (!_pickerView)
    {
        _pickerView = [[UIPickerView alloc] init];
        [_pickerView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [_pickerView setShowsSelectionIndicator:YES];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
    }
    return _pickerView;
}

- (UIDatePicker *) timePicker
{
    if (!_timePicker)
    {
        _timePicker = [[UIDatePicker alloc] init];
        [_timePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [_timePicker setDatePickerMode:UIDatePickerModeTime];
        [_timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _timePicker;
}

- (UIDatePicker *) dateTimePicker
{
    if (!_dateTimePicker)
    {
        _dateTimePicker = [[UIDatePicker alloc] init];
        [_dateTimePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [_dateTimePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        [_dateTimePicker addTarget:self action:@selector(dateTimeChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _dateTimePicker;
}

- (UIDatePicker *) datePicker
{
    if (!_datePicker)
    {
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}


-(NSDateComponents *)dateComponents
{
    return [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear fromDate:self.date];
}

- (NSInteger)year   {   return [[self dateComponents] year];    }
- (NSInteger)month  {   return [[self dateComponents] month];   }
- (NSInteger)day    {   return [[self dateComponents] day];     }
- (NSInteger)hour   {   return [[self dateComponents] hour];    }
- (NSInteger)minute {   return [[self dateComponents] minute];  }
- (NSInteger)second {   return [[self dateComponents] second];  }

@end
