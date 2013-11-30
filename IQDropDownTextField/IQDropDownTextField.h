//
//  IQDropDownTextField.h
//
//  Created by Iftekhar on 19/10/13.
//  Copyright (c) 2013 Canopus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum IQDropDownMode
{
    IQDropDownModeTextPicker,
    IQDropDownModeTimePicker,
    IQDropDownModeDatePicker,
}IQDropDownMode;

/*Do not modify it's delegate*/
@interface IQDropDownTextField : UITextField

@property(nonatomic, assign) IQDropDownMode dropDownMode;

//For IQdropDownModePickerView
@property(nonatomic, strong) NSArray *itemList;

//For IQdropDownModeDatePicker
- (void)setDate:(NSDate *)date animated:(BOOL)animated;
@property(nonatomic) UIDatePickerMode datePickerMode;             // default is UIDatePickerModeDate

@property(nonatomic, strong) NSString *selectedItem;


@end
