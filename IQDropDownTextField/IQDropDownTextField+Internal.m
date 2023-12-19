//
//  IQDropDownTextField+Internal.m
//  IQDropDownTextField
//
//  Created by Iftekhar on 12/19/23.
//

#import "IQDropDownTextField+Internal.h"
#import "IQDropDownTextField+DateTime.h"

@implementation IQDropDownTextField (Internal)

-(void)_setSelectedItem:(NSString *)selectedItem animated:(BOOL)animated shouldNotifyDelegate:(BOOL)shouldNotifyDelegate
{
    switch (self.dropDownMode)
    {
        case IQDropDownModeTextPicker:
        {
            if ([self.itemList containsObject:selectedItem])
            {
                NSInteger index = [self.itemList indexOfObject:selectedItem];
                [self setSelectedRow:index animated:animated];

                if (shouldNotifyDelegate && [self.delegate respondsToSelector:@selector(textField:didSelectItem:row:)])
                    [self.delegate textField:self didSelectItem:selectedItem row:index];
            }
            else
            {
                NSInteger selectedIndex = self.isOptionalDropDown ? IQOptionalTextFieldIndex : 0;

                [self setSelectedRow:selectedIndex animated:animated];

                if (shouldNotifyDelegate && [self.delegate respondsToSelector:@selector(textField:didSelectItem:row:)])
                    [self.delegate textField:self didSelectItem:nil row:selectedIndex];
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
