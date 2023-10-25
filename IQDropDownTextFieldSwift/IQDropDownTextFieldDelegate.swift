//
//  IQDropDownTextFieldDelegate.swift
// https://github.com/hackiftekhar/IQDropDownTextField
// Copyright (c) 2020-21 Iftekhar Qurashi.
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

import UIKit

@MainActor
public protocol IQDropDownTextFieldDelegate: UITextFieldDelegate {

    // Called when textField changes it's selected item. Supported for list mode
    @MainActor
    func textField(textField: IQDropDownTextField, didSelectItem item: String?)

    // Called when textField changes it's selected item. Supported for multiList mode
    @MainActor
    func textField(textField: IQDropDownTextField, didSelectItems items: [String?])

    // Called when textField changes it's selected item. Supported for time, date, dateTime mode
    @MainActor
    func textField(textField: IQDropDownTextField, didSelectDate date: Date?)
}

@MainActor
extension IQDropDownTextFieldDelegate {

    func textField(textField: IQDropDownTextField, didSelectItem item: String?) { }

    func textField(textField: IQDropDownTextField, didSelectItems items: [String?]) { }

    func textField(textField: IQDropDownTextField, didSelectDate date: Date?) { }
}
