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

//For IQdropDownModePickerView
@property (nonatomic, strong) NSArray *itemList;
@property (nonatomic, readonly) NSInteger selectedRow;

//For IQdropDownModeDatePicker
- (void)setDate:(NSDate *)date animated:(BOOL)animated;
- (void)setDateFormatter:(NSDateFormatter *)userDateFormatter;
- (void)setTimeFormatter:(NSDateFormatter *)userTimeFormatter;

@property (nonatomic, assign) UIDatePickerMode datePickerMode; // default is UIDatePickerModeDate

@property (nonatomic, strong) NSString *selectedItem;

- (void)setDatePickerMaximumDate:(NSDate*)date;

@end
