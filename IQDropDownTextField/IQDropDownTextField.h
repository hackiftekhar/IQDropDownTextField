//
//  IQDropDownTextField.h
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


#import <UIKit/UIKit.h>

#if !(__has_feature(objc_instancetype))
#define instancetype id
#endif

/**
 Drop Down Mode settings.

 `IQDropDownModeTextPicker`
 Show pickerView with provided text data.
 
 `IQDropDownModeTimePicker`
 Show UIDatePicker to pick time.
 
 `IQDropDownModeDatePicker`
 Show UIDatePicker to pick date.
 */
#ifndef NS_ENUM

typedef enum IQDropDownMode {
    IQDropDownModeTextPicker,
    IQDropDownModeTimePicker,
    IQDropDownModeDatePicker,
    IQDropDownModeTextField
}IQDropDownMode;

#else

typedef NS_ENUM(NSInteger, IQDropDownMode) {
    IQDropDownModeTextPicker,
    IQDropDownModeTimePicker,
    IQDropDownModeDatePicker,
    IQDropDownModeTextField
};

#endif


@class IQDropDownTextField;

/**
 Drop down text field delegate.
 */
@protocol IQDropDownTextFieldDelegate <UITextFieldDelegate>

@optional
-(void)textField:(IQDropDownTextField*)textField didSelectItem:(NSString*)item; //Called when textField changes it's selected item.

@end


/**
 Add a UIPickerView as inputView
 */
@interface IQDropDownTextField : UITextField

@property(nonatomic,assign) id<IQDropDownTextFieldDelegate> delegate;             // default is nil. weak reference

/**
 DropDownMode style to show in picker. Default is IQDropDownModeTextPicker.
 */
@property (nonatomic, assign) IQDropDownMode dropDownMode;

/**
 Label for the optional iten if isOptionalDropDown is YES. Default is Select.
 */
@property (nonatomic, copy) NSString *optionalItemText;

/**
 If YES then it will add a optionalItemLabel item at top of dropDown list. If NO then first field will automatically be selected. Default is YES
 */
@property (nonatomic, assign) BOOL isOptionalDropDown;


///----------------------
/// @name Title Selection
///----------------------

/**
 Selected item of pickerView.
 */
@property (nonatomic, copy) NSString *selectedItem;

/**
 Set selected item of pickerView.
 */
- (void)setSelectedItem:(NSString*)selectedItem animated:(BOOL)animated;


///-------------------------------
/// @name IQDropDownModeTextPicker
///-------------------------------

/**
 Items to show in pickerView. Please use [ NSArray of NSString ] format for setter method, For example. @[ @"1", @"2", @"3", ]
 */
@property (nonatomic, copy) NSArray *itemList;

/**
 Selected row index of selected item.
 */
@property (nonatomic, assign) NSInteger selectedRow;

/**
 Select row index of selected item.
 */
- (void)setSelectedRow:(NSInteger)row animated:(BOOL)animated;


///--------------------------------------------------------
/// @name IQdropDownModeDatePicker/IQDropDownModeTimePicker
///*-------------------------------------------------------

/**
 Selected date in UIDatePicker.
 */
@property(nonatomic, copy) NSDate *date;

/**
 Select date in UIDatePicker.
 */
- (void)setDate:(NSDate *)date animated:(BOOL)animated;

/**
 DateComponents for date picker.
 */
@property (nonatomic, readonly, copy) NSDateComponents *dateComponents;

/**
 year
 */
@property (nonatomic, readonly) NSInteger year;

/**
 month
 */
@property (nonatomic, readonly) NSInteger month;

/**
 day
 */
@property (nonatomic, readonly) NSInteger day;

/**
 hour
 */
@property (nonatomic, readonly) NSInteger hour;

/**
 minute
 */
@property (nonatomic, readonly) NSInteger minute;

/**
 second
 */
@property (nonatomic, readonly) NSInteger second;


///-------------------------------
/// @name IQdropDownModeDatePicker
///-------------------------------

/**
 Select date in UIDatePicker. Default is UIDatePickerModeDate
 */
@property (nonatomic, assign) UIDatePickerMode datePickerMode;

/**
 Minimum selectable date in UIDatePicker. Default is nil.
 */
@property (nonatomic, retain) NSDate *minimumDate;

/**
 Maximum selectable date in UIDatePicker. Default is nil.
 */
@property (nonatomic, retain) NSDate *maximumDate;

/**
 Date formatter to show date as text in textField.
 */
@property (nonatomic, retain) NSDateFormatter *dateFormatter UI_APPEARANCE_SELECTOR;


///-------------------------------
/// @name IQDropDownModeTimePicker
///-------------------------------

/**
 Time formatter to show time as text in textField.
 */
@property (nonatomic, retain) NSDateFormatter *timeFormatter;

@end
