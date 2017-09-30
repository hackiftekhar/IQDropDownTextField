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
#import <objc/runtime.h>

NSInteger const IQOptionalTextFieldIndex =  -1;

@interface IQDropDownTextField () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIToolbar *dismissToolbar;

@property BOOL hasSetInitialIsOptional;

@end


@interface IQDropDownTextField (Internal)

@property(nonatomic, strong) NSArray *internalItemList;

-(void)_setSelectedItem:(NSString *)selectedItem animated:(BOOL)animated shouldNotifyDelegate:(BOOL)shouldNotifyDelegate;

@end


@implementation IQDropDownTextField

@synthesize dropDownMode = _dropDownMode;
@synthesize itemList = _itemList;
@synthesize isOptionalDropDown = _isOptionalDropDown;
@synthesize optionalItemText = _optionalItemText;
@synthesize adjustPickerLabelFontSizeWidth = _adjustPickerLabelFontSizeWidth;

@synthesize dropDownFont = _dropDownFont;
@synthesize dropDownTextColor = _dropDownTextColor;
@synthesize optionalItemTextColor = _optionalItemTextColor;

@dynamic delegate;
@dynamic text;
@dynamic attributedText;

@synthesize pickerView = _pickerView;

#pragma mark - NSObject

- (void)dealloc {
    [_pickerView setDelegate:nil];
    [_pickerView setDataSource:nil];
    _pickerView = nil;
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
    return self.internalItemList.count;
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
        
        NSString *text = [self.internalItemList objectAtIndex:row];
        
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
    NSString *text = [self.internalItemList objectAtIndex:row];
    
    BOOL canSelect = YES;
    
    if ([self.dataSource respondsToSelector:@selector(textField:canSelectItem:)])
    {
        canSelect = [self.dataSource textField:self canSelectItem:text];
    }
    
    if (canSelect)
    {
        [self _setSelectedItem:[self.internalItemList objectAtIndex:row] animated:NO shouldNotifyDelegate:YES];
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
            belowIndex = self.internalItemList.count;
        }
        else if (proposedSelection == IQProposedSelectionBelow)
        {
            aboveIndex = -1;
        }
        
        
        while (aboveIndex >= 0 || belowIndex < self.internalItemList.count)
        {
            if (aboveIndex >= 0)
            {
                NSString *aboveText = [self.internalItemList objectAtIndex:aboveIndex];
                
                if ([self.dataSource textField:self canSelectItem:aboveText])
                {
                    [self _setSelectedItem:aboveText animated:YES shouldNotifyDelegate:YES];
                    return;
                }
                
                aboveIndex--;
            }
            
            if (belowIndex < self.internalItemList.count)
            {
                NSString *belowText = [self.internalItemList objectAtIndex:aboveIndex];
                
                if ([self.dataSource textField:self canSelectItem:belowText])
                {
                    [self _setSelectedItem:belowText animated:YES shouldNotifyDelegate:YES];
                    return;
                }
                
                belowIndex++;
            }
        }
        
        return [self setSelectedRow:0 animated:YES];
    }
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
    NSInteger count = ([_itemList count] + 1);
    if (row < count)
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

#pragma mark - Toolbar

-(void)setShowDismissToolbar:(BOOL)showDismissToolbar
{
    self.inputAccessoryView = (showDismissToolbar ? self.dismissToolbar : nil);
}

-(BOOL)showDismissToolbar
{
    return (self.inputAccessoryView == _dismissToolbar);
}

-(UIToolbar *)dismissToolbar
{
    if (_dismissToolbar == nil)
    {
        _dismissToolbar = [[UIToolbar alloc] init];
        _dismissToolbar.translucent = YES;
        [_dismissToolbar sizeToFit];
        UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignFirstResponder)];
        [_dismissToolbar setItems:@[buttonflexible,buttonDone]];
    }
    
    return _dismissToolbar;
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
            return  [super.text length]  ?   [self.dateFormatter stringFromDate:self.datePicker.date]    :   nil;    break;
        }
            break;
        case IQDropDownModeTimePicker:
        {
            return  [super.text length]  ?   [self.timeFormatter stringFromDate:self.timePicker.date]    :   nil;    break;
        }
            break;
        case IQDropDownModeDateTimePicker:
        {
            return  [super.text length]  ?   [self.dateTimeFormatter stringFromDate:self.dateTimePicker.date]    :   nil;    break;
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
    [self _setSelectedItem:selectedItem animated:NO shouldNotifyDelegate:NO];
}

-(void)setSelectedItem:(NSString *)selectedItem animated:(BOOL)animated
{
    [self _setSelectedItem:selectedItem animated:animated shouldNotifyDelegate:NO];
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
        self.internalItemList = [array arrayByAddingObjectsFromArray:_itemList];
    }
    else
    {
        self.internalItemList = [_itemList copy];
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

@end



@implementation IQDropDownTextField (DateTime)

- (UIDatePicker *) timePicker
{
    UIDatePicker *_timePicker = objc_getAssociatedObject(self, _cmd);
    if (!_timePicker)
    {
        _timePicker = [[UIDatePicker alloc] init];
        [_timePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [_timePicker setDatePickerMode:UIDatePickerModeTime];
        [_timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
        objc_setAssociatedObject(self, _cmd, _timePicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _timePicker;
}

- (UIDatePicker *) dateTimePicker
{
    UIDatePicker *_dateTimePicker = objc_getAssociatedObject(self, _cmd);
    
    if (!_dateTimePicker)
    {
        _dateTimePicker = [[UIDatePicker alloc] init];
        [_dateTimePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [_dateTimePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        [_dateTimePicker addTarget:self action:@selector(dateTimeChanged:) forControlEvents:UIControlEventValueChanged];
        objc_setAssociatedObject(self, _cmd, _dateTimePicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _dateTimePicker;
}

- (UIDatePicker *) datePicker
{
    UIDatePicker *_datePicker = objc_getAssociatedObject(self, _cmd);
    
    if (!_datePicker)
    {
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        objc_setAssociatedObject(self, _cmd, _datePicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _datePicker;
}

#pragma mark - UIDatePicker delegate

- (void)dateChanged:(UIDatePicker *)dPicker
{
    [self _setSelectedItem:[self.dateFormatter stringFromDate:dPicker.date] animated:NO shouldNotifyDelegate:YES];
}

- (void)timeChanged:(UIDatePicker *)tPicker
{
    [self _setSelectedItem:[self.timeFormatter stringFromDate:tPicker.date] animated:NO shouldNotifyDelegate:YES];
}

- (void)dateTimeChanged:(UIDatePicker *)dtPicker
{
    [self _setSelectedItem:[self.dateTimeFormatter stringFromDate:dtPicker.date] animated:NO shouldNotifyDelegate:YES];
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
    switch (self.dropDownMode)
    {
        case IQDropDownModeDatePicker:
            [self _setSelectedItem:[self.dateFormatter stringFromDate:date] animated:animated shouldNotifyDelegate:NO];
            break;
        case IQDropDownModeTimePicker:
            [self _setSelectedItem:[self.timeFormatter stringFromDate:date] animated:animated shouldNotifyDelegate:NO];
            break;
        case IQDropDownModeDateTimePicker:
            [self _setSelectedItem:[self.dateTimeFormatter stringFromDate:date] animated:animated shouldNotifyDelegate:NO];
            break;
        default:
            break;
    }
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

-(UIDatePickerMode)datePickerMode
{
    NSNumber *datePickerMode = objc_getAssociatedObject(self, @selector(datePickerMode));
    return [datePickerMode integerValue];
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    if (self.dropDownMode == IQDropDownModeDatePicker)
    {
        objc_setAssociatedObject(self, @selector(datePickerMode), @(datePickerMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self.datePicker setDatePickerMode:datePickerMode];
        
        switch (datePickerMode) {
            case UIDatePickerModeCountDownTimer:
                [self.dateFormatter setDateStyle:NSDateFormatterNoStyle];
                [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
                break;
            case UIDatePickerModeDate:
                [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
                [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
                break;
            case UIDatePickerModeTime:
                [self.timeFormatter setDateStyle:NSDateFormatterNoStyle];
                [self.timeFormatter setTimeStyle:NSDateFormatterShortStyle];
                break;
            case UIDatePickerModeDateAndTime:
                [self.dateTimeFormatter setDateStyle:NSDateFormatterShortStyle];
                [self.dateTimeFormatter setTimeStyle:NSDateFormatterShortStyle];
                break;
        }
    }
}

-(NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = objc_getAssociatedObject(self, @selector(dateFormatter));
    
    if (!dateFormatter) {
        
        if ([[IQDropDownTextField appearance] dateFormatter])
        {
            dateFormatter = [[IQDropDownTextField appearance] dateFormatter];
        }
        else
        {
            static NSDateFormatter *defaultDateFormatter = nil;
            
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                defaultDateFormatter = [[NSDateFormatter alloc] init];
                [defaultDateFormatter setDateStyle:NSDateFormatterMediumStyle];
                [defaultDateFormatter setTimeStyle:NSDateFormatterNoStyle];
            });
            
            dateFormatter = defaultDateFormatter;
        }
    }
    
    return dateFormatter;
}

-(void)setDateFormatter:(NSDateFormatter *)dateFormatter
{
    objc_setAssociatedObject(self, @selector(dateFormatter), dateFormatter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.datePicker setLocale:dateFormatter.locale];
}

-(NSDateFormatter *)timeFormatter
{
    NSDateFormatter *timeFormatter = objc_getAssociatedObject(self, @selector(timeFormatter));
    
    if (!timeFormatter)
    {
        if ([[IQDropDownTextField appearance] timeFormatter])
        {
            timeFormatter = [[IQDropDownTextField appearance] timeFormatter];
        }
        else
        {
            static NSDateFormatter *defaultTimeFormatter = nil;
            
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                defaultTimeFormatter = [[NSDateFormatter alloc] init];
                [defaultTimeFormatter setDateStyle:NSDateFormatterNoStyle];
                [defaultTimeFormatter setTimeStyle:NSDateFormatterShortStyle];
            });
            
            timeFormatter = defaultTimeFormatter;
        }
    }
    
    return timeFormatter;
}

-(void)setTimeFormatter:(NSDateFormatter *)timeFormatter
{
    objc_setAssociatedObject(self, @selector(timeFormatter), timeFormatter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.timePicker setLocale:timeFormatter.locale];
}

-(NSDateFormatter *)dateTimeFormatter
{
    NSDateFormatter *dateTimeFormatter = objc_getAssociatedObject(self, @selector(dateTimeFormatter));
    
    if (!dateTimeFormatter) {
        if ([[IQDropDownTextField appearance] dateTimeFormatter])
        {
            dateTimeFormatter = [[IQDropDownTextField appearance] dateTimeFormatter];
        }
        else
        {
            static NSDateFormatter *defaultDateTimeFormatter = nil;
            
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                defaultDateTimeFormatter = [[NSDateFormatter alloc] init];
                [defaultDateTimeFormatter setDateStyle:NSDateFormatterMediumStyle];
                [defaultDateTimeFormatter setTimeStyle:NSDateFormatterShortStyle];
            });
            
            dateTimeFormatter = defaultDateTimeFormatter;
        }
    }
    
    return dateTimeFormatter;
}

-(void)setDateTimeFormatter:(NSDateFormatter *)dateTimeFormatter
{
    objc_setAssociatedObject(self, @selector(dateTimeFormatter), dateTimeFormatter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.dateTimePicker setLocale:dateTimeFormatter.locale];
}

@end


@implementation IQDropDownTextField (Internal)

-(NSArray *)internalItemList
{
    return objc_getAssociatedObject(self, @selector(internalItemList));
}

-(void)setInternalItemList:(NSArray *)internalItemList
{
    objc_setAssociatedObject(self, @selector(internalItemList), internalItemList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)_setSelectedItem:(NSString *)selectedItem animated:(BOOL)animated shouldNotifyDelegate:(BOOL)shouldNotifyDelegate
{
    switch (self.dropDownMode)
    {
        case IQDropDownModeTextPicker:
        {
            if ([self.internalItemList containsObject:selectedItem])
            {
                [self setSelectedRow:[self.internalItemList indexOfObject:selectedItem] animated:animated];
                
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
            NSDate *date = [self.dateFormatter dateFromString:selectedItem];
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
            NSDate *time = [self.timeFormatter dateFromString:selectedItem];
            
            if (time)
            {
                NSDate *day = [NSDate dateWithTimeIntervalSinceReferenceDate: 0];
                NSDateComponents *componentsDay = [[NSCalendar currentCalendar] components: NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate: day];
                NSDateComponents *componentsTime = [[NSCalendar currentCalendar] components: NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate: time];
                componentsDay.hour = componentsTime.hour;
                componentsDay.minute = componentsTime.minute;
                componentsDay.second = componentsTime.second;
                
                NSDate *date = [[NSCalendar currentCalendar] dateFromComponents: componentsDay];
                
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
            NSDate *date = [self.dateTimeFormatter dateFromString:selectedItem];
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

@end
