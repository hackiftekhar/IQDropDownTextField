//
//  ViewController.h
//  Drop Down TextField
//
//  Created by hp on 10/11/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQDropDownTextField.h"

@interface ViewController : UIViewController
{

    IBOutlet IQDropDownTextField *textFieldTextPicker;
    IBOutlet IQDropDownTextField *textFieldOptionalTextPicker;
    IBOutlet IQDropDownTextField *textFieldDatePicker;
    IBOutlet IQDropDownTextField *textFieldTimePicker;
    IBOutlet IQDropDownTextField *textFieldDateTimePicker;

}
@end
