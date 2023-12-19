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
#import "IQDropDownTextField+Internal.h"

NSInteger const IQOptionalTextFieldIndex =  -1;

@interface IQDropDownTextField () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonnull, nonatomic, strong) UIToolbar *dismissToolbar;

@property BOOL hasSetInitialIsOptional;
@property NSInteger pickerSelectedRow;

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
    _pickerSelectedRow = -1;
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

- (BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    if (_pickerSelectedRow >= 0) {
        [_pickerView selectRow:_pickerSelectedRow inComponent:0 animated:NO];
    }

    return  result;
}

#pragma mark - UITextField overrides

- (CGRect)caretRectForPosition:(nonnull UITextPosition *)position
{
    if (self.dropDownMode == IQDropDownModeTextField) {
        return [super caretRectForPosition:position];
    } else {
        return CGRectZero;
    }
}

#pragma mark - UIPickerView data source

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.itemList.count + (self.isOptionalDropDown ? 1 : 0);
}

#pragma mark UIPickerView delegate

- (nonnull UIView *)pickerView:(nonnull UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    row = row - (self.isOptionalDropDown ? 1 : 0);

    if (row == IQOptionalTextFieldIndex) {
        UILabel *labelText = (UILabel*)view;

        if (labelText == nil)
        {
            labelText = [[UILabel alloc] init];
            [labelText setTextAlignment:NSTextAlignmentCenter];
            [labelText setAdjustsFontSizeToFitWidth:YES];
            labelText.backgroundColor = [UIColor clearColor];
            labelText.backgroundColor = [UIColor clearColor];
        }

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
        labelText.text = self.optionalItemText;

        return labelText;

    } else {
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

            if (_dropDownFont) {
                labelText.font = _dropDownFont;
            } else {
                labelText.font = [UIFont boldSystemFontOfSize:18.0];
            }

            NSString *text = [self.itemList objectAtIndex:row];

            [labelText setText:text];

            {
                BOOL canSelect = YES;

                if ([self.dataSource respondsToSelector:@selector(textField:canSelectItem:row:)])
                {
                    canSelect = [self.dataSource textField:self canSelectItem:text row:row];
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
}

- (void)pickerView:(nonnull UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _pickerSelectedRow = row;

    row = row - (self.isOptionalDropDown ? 1 : 0);

    if (row == IQOptionalTextFieldIndex) {
        [self _setSelectedItem:nil animated:NO shouldNotifyDelegate:YES];
    } else if (row >= 0) {

        NSString *text = [self.itemList objectAtIndex:row];

        BOOL canSelect = YES;

        if ([self.dataSource respondsToSelector:@selector(textField:canSelectItem:row:)])
        {
            canSelect = [self.dataSource textField:self canSelectItem:text row:row];
        }

        if (canSelect)
        {
            [self _setSelectedItem:text animated:NO shouldNotifyDelegate:YES];
        }
        else
        {
            IQProposedSelection proposedSelection = IQProposedSelectionBoth;

            if ([self.dataSource respondsToSelector:@selector(textField:proposedSelectionModeForItem:row:)])
            {
                proposedSelection = [self.dataSource textField:self proposedSelectionModeForItem:text row:row];
            }

            NSInteger aboveIndex = row-1;
            NSInteger belowIndex = row+1;

            if (proposedSelection == IQProposedSelectionAbove)
            {
                belowIndex = self.itemList.count;
            }
            else if (proposedSelection == IQProposedSelectionBelow)
            {
                aboveIndex = -1;
            }

            while (aboveIndex >= 0 || belowIndex < self.itemList.count)
            {
                if (aboveIndex >= 0)
                {
                    NSString *aboveText = [self.itemList objectAtIndex:aboveIndex];

                    if ([self.dataSource textField:self canSelectItem:aboveText row:aboveIndex])
                    {
                        [self _setSelectedItem:aboveText animated:YES shouldNotifyDelegate:YES];
                        return;
                    }

                    aboveIndex--;
                }

                if (belowIndex < self.itemList.count)
                {
                    NSString *belowText = [self.itemList objectAtIndex:aboveIndex];

                    if ([self.dataSource textField:self canSelectItem:belowText row:belowIndex])
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
}

#pragma mark - Selected Row

- (NSInteger)selectedRow
{
    NSInteger pickerViewSelectedRow = _pickerSelectedRow;   //It may return -1
    pickerViewSelectedRow = MAX(pickerViewSelectedRow, 0);

    return pickerViewSelectedRow - (self.isOptionalDropDown ? 1 : 0);
}

-(void)setSelectedRow:(NSInteger)selectedRow
{
    [self setSelectedRow:selectedRow animated:NO];
}

- (void)setSelectedRow:(NSInteger)row animated:(BOOL)animated
{
    if (row == IQOptionalTextFieldIndex) {
        if (self.isOptionalDropDown) {
            super.text = @"";
        } else if (_itemList.count > 0) {
            super.text = [_itemListUI?:_itemList objectAtIndex:0];
        } else {
            super.text = @"";
        }
    } else {
        super.text = [_itemListUI?:_itemList objectAtIndex:row];
    }

    NSInteger pickerViewRow = row + (self.isOptionalDropDown ? 1 : 0);
    _pickerSelectedRow = pickerViewRow;
    [self.pickerView selectRow:pickerViewRow inComponent:0 animated:animated];
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

-(nonnull UIToolbar *)dismissToolbar
{
    if (_dismissToolbar == nil)
    {
        _dismissToolbar = [[UIToolbar alloc] init];
        _dismissToolbar.translucent = YES;
        [_dismissToolbar sizeToFit];
        UIBarButtonItem *buttonFlexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignFirstResponder)];
        [_dismissToolbar setItems:@[buttonFlexible, buttonDone]];
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

- (void)setItemList:(nullable NSArray *)itemList
{
    _itemList = itemList;
    
    //Refreshing pickerView
    [self setIsOptionalDropDown:_isOptionalDropDown];
    
    [self setSelectedRow:self.selectedRow];
}

- (nullable NSString*)selectedItem
{
    switch (_dropDownMode)
    {
        case IQDropDownModeTextPicker:
        {
            NSInteger selectedRow = self.selectedRow;

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

-(void)setSelectedItem:(nullable NSString *)selectedItem
{
    [self _setSelectedItem:selectedItem animated:NO shouldNotifyDelegate:NO];
}

-(void)setSelectedItem:(nullable NSString *)selectedItem animated:(BOOL)animated
{
    [self _setSelectedItem:selectedItem animated:animated shouldNotifyDelegate:NO];
}

-(nullable NSString *)optionalItemText
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

-(void)setOptionalItemText:(nullable NSString *)optionalItemText
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
    if (_hasSetInitialIsOptional == NO || _isOptionalDropDown != isOptionalDropDown)
    {
        NSInteger previousSelectedRow = self.selectedRow;

        _isOptionalDropDown = isOptionalDropDown;
        _hasSetInitialIsOptional = YES;

        if (_hasSetInitialIsOptional == YES && self.dropDownMode == IQDropDownModeTextPicker)
        {
            [self.pickerView reloadAllComponents];

            [self setSelectedRow:previousSelectedRow];
        }
    }
}

- (void) _updateOptionsList {

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
            [self.pickerView reloadAllComponents];
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

- (nonnull UIPickerView *) pickerView {
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
