IQDropDownTextField
===================

TextField with DropDown support using UIPickerView

[![Simple](https://raw.githubusercontent.com/hackiftekhar/IQDropDownTextField/master/Images/simple.png)]
[![Large Text](https://raw.githubusercontent.com/hackiftekhar/IQDropDownTextField/master/Images/large_text.png)]
[![Multi List](https://raw.githubusercontent.com/hackiftekhar/IQDropDownTextField/master/Images/multi_list.png)]
[![Date](https://raw.githubusercontent.com/hackiftekhar/IQDropDownTextField/master/Images/date.png)]
[![Time](https://raw.githubusercontent.com/hackiftekhar/IQDropDownTextField/master/Images/time.png)]
[![Date Time](https://raw.githubusercontent.com/hackiftekhar/IQDropDownTextField/master/Images/date_time)]

## Installing

Install using [cocoapods](http://cocoapods.org). Add in your `Podfile`:

```
pod 'IQDropDownTextField'
```

Or below for Swift version
```
pod 'IQDropDownTextFieldSwift'
```

## How to Use

In IB (_story boards or xibs_) you can add `UITextField`'s and set the class as `IQDropDownTextField`

### Objective-C

Nothing more easy than it!

```objective-c

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    textFieldTextPicker.isOptionalDropDown = NO;
    [textFieldTextPicker setItemList:[NSArray arrayWithObjects:@"London",@"Johannesburg",@"Moscow",@"Mumbai",@"Tokyo",@"Sydney", nil]];
}
@end

```

### Swift

It's very simple to setup your `IQDropDownTextField`. The sample below shows you how to:

```swift
import IQDropDownTextFieldSwift

class MyController : UIViewController {
  @IBOutlet var occupationTextField: IQDropDownTextField!
  
  override func viewDidLoad() {
    occupationTextField.isOptionalDropDown = false
    occupationTextField.itemList = ["programmer", "teacher", "engineer"]
  }
}
```

And that's all you need! =)

## Contributions

Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

## Author

If you wish to contact me, email at: hack.iftekhar@gmail.com

## LICENSE

Copyright (c) 2010-2015

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
