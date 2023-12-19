//
//  IQDropDownTextField+DateTime.m
//  IQDropDownTextField
//
//  Created by Iftekhar on 12/19/23.
//

#import "IQDropDownTextField+DateTime.h"
#import "IQDropDownTextField+Internal.h"
#import <objc/runtime.h>

@implementation IQDropDownTextField (DateTime)

- (nonnull UIDatePicker *) timePicker
{
    UIDatePicker *_timePicker = objc_getAssociatedObject(self, _cmd);
    if (!_timePicker)
    {
        _timePicker = [[UIDatePicker alloc] init];
        [_timePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [_timePicker setDatePickerMode:UIDatePickerModeTime];
        if (@available(iOS 13.4, *)) {
            [_timePicker setPreferredDatePickerStyle:UIDatePickerStyleWheels];
        }
        [_timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
        objc_setAssociatedObject(self, _cmd, _timePicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return _timePicker;
}

- (nonnull UIDatePicker *) dateTimePicker
{
    UIDatePicker *_dateTimePicker = objc_getAssociatedObject(self, _cmd);

    if (!_dateTimePicker)
    {
        _dateTimePicker = [[UIDatePicker alloc] init];
        [_dateTimePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [_dateTimePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        if (@available(iOS 13.4, *)) {
            [_dateTimePicker setPreferredDatePickerStyle:UIDatePickerStyleWheels];
        }
        [_dateTimePicker addTarget:self action:@selector(dateTimeChanged:) forControlEvents:UIControlEventValueChanged];
        objc_setAssociatedObject(self, _cmd, _dateTimePicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _dateTimePicker;
}

- (nonnull UIDatePicker *) datePicker
{
    UIDatePicker *_datePicker = objc_getAssociatedObject(self, _cmd);

    if (!_datePicker)
    {
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        if (@available(iOS 13.4, *)) {
            [_datePicker setPreferredDatePickerStyle:UIDatePickerStyleWheels];
        }
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        objc_setAssociatedObject(self, _cmd, _datePicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return _datePicker;
}

#pragma mark - UIDatePicker delegate

- (void)dateChanged:(nonnull UIDatePicker *)datePicker
{
    [self _setSelectedItem:[self.dateFormatter stringFromDate:datePicker.date] animated:NO shouldNotifyDelegate:YES];
}

- (void)timeChanged:(nonnull UIDatePicker *)timePicker
{
    [self _setSelectedItem:[self.timeFormatter stringFromDate:timePicker.date] animated:NO shouldNotifyDelegate:YES];
}

- (void)dateTimeChanged:(nonnull UIDatePicker *)datePicker
{
    [self _setSelectedItem:[self.dateTimeFormatter stringFromDate:datePicker.date] animated:NO shouldNotifyDelegate:YES];
}

-(nullable NSDate *)date
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

-(void)setDate:(nullable NSDate *)date
{
    [self setDate:date animated:NO];
}

- (void)setDate:(nullable NSDate *)date animated:(BOOL)animated
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

-(nullable NSDateComponents *)dateComponents
{
    return [[NSCalendar currentCalendar] components: kCFCalendarUnitSecond | kCFCalendarUnitMinute | kCFCalendarUnitHour | kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear | kCFCalendarUnitEra fromDate:self.date];
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

-(nullable NSDateFormatter *)dateFormatter
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

-(void)setDateFormatter:(nullable NSDateFormatter *)dateFormatter
{
    objc_setAssociatedObject(self, @selector(dateFormatter), dateFormatter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.datePicker setLocale:dateFormatter.locale];
}

-(nullable NSDateFormatter *)timeFormatter
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

-(void)setTimeFormatter:(nullable NSDateFormatter *)timeFormatter
{
    objc_setAssociatedObject(self, @selector(timeFormatter), timeFormatter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.timePicker setLocale:timeFormatter.locale];
}

-(nullable NSDateFormatter *)dateTimeFormatter
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

-(void)setDateTimeFormatter:(nullable NSDateFormatter *)dateTimeFormatter
{
    objc_setAssociatedObject(self, @selector(dateTimeFormatter), dateTimeFormatter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.dateTimePicker setLocale:dateTimeFormatter.locale];
}

@end
