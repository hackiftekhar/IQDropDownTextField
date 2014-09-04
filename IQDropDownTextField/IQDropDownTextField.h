//
//  IQDropDownTextField.h
//
//  Created by Iftekhar on 19/10/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IQDropDownMode) {
    IQDropDownModeTextPicker,
    IQDropDownModeTimePicker,
    IQDropDownModeDatePicker
};

/*Do not modify it's delegate*/
@interface IQDropDownTextField : UITextField

@property (nonatomic, assign) IQDropDownMode dropDownMode;

@property (nonatomic, strong) NSString *selectedItem;

- (void)setSelectedItem:(NSString*)selectedItem animated:(BOOL)animated;

//For IQdropDownModePickerView
@property (nonatomic, strong) NSArray *itemList;
@property (nonatomic, readonly) NSInteger selectedRow;
@property (nonatomic, assign) BOOL isOptionalDropDown;  //If YES then, it will add a 'Select' item at top of dropDown list. If NO then first field will automatically be selected. Default is YES.

- (void)selectRow:(NSInteger)row animated:(BOOL)animated;

//For IQdropDownModeDatePicker
@property(nonatomic, strong) NSDate *date; //get/set date.
@property (nonatomic, retain) NSDate *minimumDate; // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
@property (nonatomic, retain) NSDate *maximumDate; // default is nil

- (void)setDate:(NSDate *)date animated:(BOOL)animated;

- (void)setDateFormatter:(NSDateFormatter *)userDateFormatter;
- (void)setTimeFormatter:(NSDateFormatter *)userTimeFormatter;

@property (nonatomic, assign) UIDatePickerMode datePickerMode; // default is UIDatePickerModeDate

@end
