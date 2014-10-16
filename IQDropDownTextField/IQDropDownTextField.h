//
//  IQDropDownTextField.h
// https://github.com/hackiftekhar/IQDropDownTextField
// Copyright (c) 2013-14 Iftekhar Qurashi.
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

typedef NS_ENUM(NSInteger, IQDropDownMode) {
    IQDropDownModeTextPicker,
    IQDropDownModeTimePicker,
    IQDropDownModeDatePicker
};

@class IQDropDownTextField;

@protocol IQDropDownTextFieldDelegate <UITextFieldDelegate>

@optional
-(void)textField:(IQDropDownTextField*)textField didSelectItem:(NSString*)item;

@end

@interface IQDropDownTextField : UITextField

@property(nonatomic,assign) id<IQDropDownTextFieldDelegate> delegate;             // default is nil. weak reference

@property (nonatomic, assign) IQDropDownMode dropDownMode;

@property (nonatomic, strong) NSString *selectedItem;

- (void)setSelectedItem:(NSString*)selectedItem animated:(BOOL)animated;

//For IQdropDownModePickerView
@property (nonatomic, strong) NSArray *itemList;
@property (nonatomic, readonly) NSInteger selectedRow;
@property (nonatomic, assign) BOOL isOptionalDropDown;  //If YES then, it will add a 'Select' item at top of dropDown list. If NO then first field will automatically be selected. Default is YES.

- (void)selectRow:(NSInteger)row animated:(BOOL)animated;


/*  For IQdropDownModeDatePicker & IQDropDownModeTimePicker */
@property(nonatomic, strong) NSDate *date; //get/set date.
@property (nonatomic, retain) NSDate *minimumDate; // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
@property (nonatomic, retain) NSDate *maximumDate; // default is nil

- (void)setDate:(NSDate *)date animated:(BOOL)animated;

- (void)setDateFormatter:(NSDateFormatter *)userDateFormatter;
- (void)setTimeFormatter:(NSDateFormatter *)userTimeFormatter;

@property (nonatomic, assign) UIDatePickerMode datePickerMode; // default is UIDatePickerModeDate

- (NSDateComponents*)dateComponents;
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;

@end
