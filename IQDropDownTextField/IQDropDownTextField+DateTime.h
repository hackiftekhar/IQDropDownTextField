//
//  IQDropDownTextField+DateTime.h
//  IQDropDownTextField
//
//  Created by Iftekhar on 12/19/23.
//

#import "IQDropDownTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface IQDropDownTextField (DateTime)

/**
 These are the picker object which internally used for showing list. Changing some properties might not work properly so do it at your own risk.
 */
@property (nonnull, nonatomic, readonly) UIDatePicker *datePicker;
@property (nonnull, nonatomic, readonly) UIDatePicker *timePicker;
@property (nonnull, nonatomic, readonly) UIDatePicker *dateTimePicker;


///--------------------------------------------------------
/// @name IQDropDownModeDatePicker/IQDropDownModeTimePicker
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
/// @name IQDropDownModeDatePicker
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

NS_ASSUME_NONNULL_END
