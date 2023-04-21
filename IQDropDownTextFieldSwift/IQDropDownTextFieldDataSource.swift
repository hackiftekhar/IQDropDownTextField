//
//  IQDropDownTextFieldDataSource.swift
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

public protocol IQDropDownTextFieldDataSource: AnyObject {

    // Check if an item can be selected by dropdown texField.
    func textField(textField: IQDropDownTextField, canSelectItem item: String) -> Bool

    // If canSelectItem return NO, then textField:proposedSelectionModeForItem: asked for propsed selection mode.
    // .above: pickerView find the nearest items above the deselected item
    //          that can be selected and then selecting that row.
    // .below: pickerView find the nearest items below the deselected item
    //          that can be selected and then selecting that row.
    // both.: pickerView find the nearest items that can be selected
    //          above or below the deselected item and then selecting that row.
    func textField(textField: IQDropDownTextField, proposedSelectionModeForItem item: String) -> IQProposedSelection
}

extension IQDropDownTextFieldDataSource {

    func textField(textField: IQDropDownTextField, didSelectDate date: Date?) { }
    func textField(textField: IQDropDownTextField, canSelectItem item: String) -> Bool { return true }
    func textField(textField: IQDropDownTextField, proposedSelectionModeForItem item: String) -> IQProposedSelection {
        return .both
    }
}
