//
//  IQDropDownTextFieldConstants.h
//  IQDropDownTextField
//
//  Created by Iftekhar on 12/19/23.
//

#ifndef IQDropDownTextFieldConstants_h
#define IQDropDownTextFieldConstants_h

#import <Foundation/Foundation.h>

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

/**
 `IQProposedSelectionAbove`
 pickerView find the nearest items above the deselected item that can be selected and then selecting that row.

 `IQProposedSelectionBelow`
 pickerView find the nearest items below the deselected item that can be selected and then selecting that row.

 `IQProposedSelectionBoth`
 pickerView find the nearest items that can be selected above or below the deselected item and then selecting that row.
 */
typedef NS_ENUM(NSInteger, IQProposedSelection) {
    IQProposedSelectionBoth,
    IQProposedSelectionAbove,
    IQProposedSelectionBelow
};


#endif /* IQDropDownTextFieldConstants_h */
