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

/**
 Drop Down Mode settings.

 `IQDropDownModeTextPicker`
 Show pickerView with provided text data.
 
 `IQDropDownModeTimePicker`
 Show UIDatePicker to pick time.
 
 `IQDropDownModeDatePicker`
 Show UIDatePicker to pick date.
 */
typedef NS_ENUM(NSInteger, IQDropDownMode) {
    IQDropDownModeTextPicker,
    IQDropDownModeTimePicker,
    IQDropDownModeDatePicker,
    IQDropDownModeDateTimePicker,
    IQDropDownModeTextField
};

typedef NS_ENUM(NSInteger, IQProposedSelection) {
    IQProposedSelectionBoth,
    IQProposedSelectionAbove,
    IQProposedSelectionBelow
};


/**
 Integer constant to use with `selectedRow` property, this will select `Select` option in optional textField.
 */
extern NSInteger const IQOptionalTextFieldIndex;


@class IQDropDownTextField;

/**
 Drop down text field delegate.
 */
@protocol IQDropDownTextFieldDelegate <UITextFieldDelegate>

@optional
-(void)textField:(nonnull IQDropDownTextField*)textField didSelectItem:(nullable NSString*)item; //Called when textField changes it's selected item. Supported for IQDropDownModeTextPicker

-(void)textField:(nonnull IQDropDownTextField*)textField didSelectDate:(nullable NSDate*)date; //Called when textField changes it's selected item. Supported for IQDropDownModeTimePicker, IQDropDownModeDatePicker, IQDropDownModeDateTimePicker

@end


/**
 Drop down text field data source. This is only valid for IQDropDownModeTextField mode
 */
@protocol IQDropDownTextFieldDataSource <NSObject>

@optional
-(BOOL)textField:(nonnull IQDropDownTextField*)textField canSelectItem:(nonnull NSString*)item;    //Check if an item can be selected by dropdown texField.
-(IQProposedSelection)textField:(nonnull IQDropDownTextField*)textField proposedSelectionModeForItem:(nonnull NSString*)item;    //If canSelectItem return NO, then textField:proposedSelectionModeForItem: asked for propsed selection mode.
//IQProposedSelectionAbove: pickerView find the nearest items above the deselected item that can be selected and then selecting that row.
//IQProposedSelectionBelow: pickerView find the nearest items below the deselected item that can be selected and then selecting that row.
//IQProposedSelectionBoth: pickerView find the nearest items that can be selected above or below the deselected item and then selecting that row.

@end


/**
 Add a UIPickerView as inputView
 */
@interface IQDropDownTextField : UITextField

/**
 This is picker object which internaly used for showing list. Changing some properties might not work properly so do it at your own risk.
 */
@property (nonnull, nonatomic, readonly) UIPickerView *pickerView;

@property(nullable, nonatomic,weak) IBOutlet id<IQDropDownTextFieldDelegate> delegate;             // default is nil. weak reference
@property(nullable, nonatomic,weak) IBOutlet id<IQDropDownTextFieldDataSource> dataSource;             // default is nil. weak reference

/**
 If YES then a toolbar will be added at the top to dismiss textfield, if NO then toolbar will be removed. Default to NO.
 */
@property (nonatomic, assign) BOOL showDismissToolbar;

/**
 DropDownMode style to show in picker. Default is IQDropDownModeTextPicker.
 */
@property (nonatomic, assign) IQDropDownMode dropDownMode;

/**
 Label for the optional iten if isOptionalDropDown is YES. Default is Select.
 */
@property (nullable, nonatomic, copy) IBInspectable NSString *optionalItemText;

/**
 If YES then it will add a optionalItemLabel item at top of dropDown list. If NO then first field will automatically be selected. Default is YES
 */
@property (nonatomic, assign) IBInspectable BOOL isOptionalDropDown;

/**
 Use selectedItem property to get/set dropdown text.
 */
@property(nullable, nonatomic,copy)   NSString               *text NS_DEPRECATED_IOS(3_0, 5_0, "Please use selectedItem property to get/set dropdown selected text instead");

/**
 attributedText is unavailable in IQDropDownTextField.
 */
@property(nullable, nonatomic,copy)   NSAttributedString     *attributedText NS_UNAVAILABLE;

/**
 Sets a custom font for the IQDropdownTextField items. Default is boldSystemFontOfSize:18.0.
 */
@property (nullable, strong, nonatomic) UIFont *dropDownFont;

/**
 Sets a custom color for the IQDropdownTextField items. Default is blackColor.
 */
@property (nullable, strong, nonatomic) UIColor *dropDownTextColor;

/**
 Sets a custom color for the optional item. Default is lightGrayColor.
 */
@property (nullable, strong, nonatomic) UIColor *optionalItemTextColor;


///----------------------
/// @name Title Selection
///----------------------

/**
 Selected item of pickerView.
 */
@property (nullable, nonatomic, copy) NSString *selectedItem;

/**
 Set selected item of pickerView.
 */
- (void)setSelectedItem:(nullable NSString*)selectedItem animated:(BOOL)animated;


///-------------------------------
/// @name IQDropDownModeTextPicker
///-------------------------------

/**
 Items to show in pickerView. For example. @[ @"1", @"2", @"3" ]. This field must be set.
 */
@property (nullable, nonatomic, copy) NSArray <NSString*> *itemList;

/**
 UIView items to show in pickerView. For example. @[ view1, view2, view3 ]. If itemList text needs to be shown then pass [NSNull null] instead of UIView object at appropriate index. This field is optional.
 */
@property (nullable, nonatomic, copy) NSArray <__kindof NSObject*> *itemListView;

/**
 If this is set then we'll show textfield's text from this list instead from regular itemList. This is only for showing different messaging in textfield's text. This itemListUI array count must be equal to itemList array count.
 */
@property (nullable, nonatomic, copy) NSArray <NSString*> *itemListUI;

/**
 Selected row index of selected item.
 */
@property (nonatomic, assign) NSInteger selectedRow;

/**
 Defines Picker labels fontSizeAdjustment by width. Default is NO
 */
@property (nonatomic, assign) IBInspectable BOOL adjustPickerLabelFontSizeWidth;

/**
 Select row index of selected item.
 */
- (void)setSelectedRow:(NSInteger)row animated:(BOOL)animated;

@end



@interface IQDropDownTextField (DateTime)

/**
 These are the picker object which internaly used for showing list. Changing some properties might not work properly so do it at your own risk.
 */
@property (nonnull, nonatomic, readonly) UIDatePicker *datePicker;
@property (nonnull, nonatomic, readonly) UIDatePicker *timePicker;
@property (nonnull, nonatomic, readonly) UIDatePicker *dateTimePicker;


///--------------------------------------------------------
/// @name IQdropDownModeDatePicker/IQDropDownModeTimePicker
///*-------------------------------------------------------

/**
 Selected date in UIDatePicker.
 */
@property(nullable, nonatomic, copy) NSDate *date;

/**
 Select date in UIDatePicker.
 */
- (void)setDate:(nullable NSDate *)date animated:(BOOL)animated;

/**
 DateComponents for date picker.
 */
@property (nullable, nonatomic, readonly, copy) NSDateComponents *dateComponents;

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
 Date formatter to show date as text in textField.
 */
@property (nullable, nonatomic, retain) NSDateFormatter *dateFormatter UI_APPEARANCE_SELECTOR;


///-------------------------------
/// @name IQDropDownModeTimePicker
///-------------------------------

/**
 Time formatter to show time as text in textField.
 */
@property (nullable, nonatomic, retain) NSDateFormatter *timeFormatter UI_APPEARANCE_SELECTOR;

@property (nullable, nonatomic, retain) NSDateFormatter *dateTimeFormatter UI_APPEARANCE_SELECTOR;

@end
