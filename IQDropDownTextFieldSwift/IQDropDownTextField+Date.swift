//
//  IQDropDownTextField+Date.swift
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
extension IQDropDownTextField {

    // MARK: - UIDatePicker delegate

    @objc internal func dateChanged(_ picker: UIDatePicker) {
        let selectedItem: String = dateFormatter.string(from: picker.date)
        privateSetSelectedItems(selectedItems: [selectedItem], animated: false, shouldNotifyDelegate: true)
    }

    @objc internal func timeChanged(_ picker: UIDatePicker) {
        let selectedItem: String = timeFormatter.string(from: picker.date)
        privateSetSelectedItems(selectedItems: [selectedItem], animated: false, shouldNotifyDelegate: true)
    }

    @objc internal func dateTimeChanged(_ picker: UIDatePicker) {
        let selectedItem: String = dateTimeFormatter.string(from: picker.date)
        privateSetSelectedItems(selectedItems: [selectedItem], animated: false, shouldNotifyDelegate: true)
    }

    @objc open var datePickerMode: UIDatePicker.Mode {
        get {
            return datePicker.datePickerMode
        }
        set {
            if dropDownMode == .date {
                datePicker.datePickerMode = newValue
                switch newValue {
                case .countDownTimer:
                    dateFormatter.dateStyle = .none
                    dateFormatter.timeStyle = .none
                case .date:
                    dateFormatter.dateStyle = .short
                    dateFormatter.timeStyle = .none
                case .time:
                    timeFormatter.dateStyle = .none
                    timeFormatter.timeStyle = .short
                case .dateAndTime:
                    dateTimeFormatter.dateStyle = .short
                    dateTimeFormatter.timeStyle = .short
                @unknown default:
                    break
                }
            }
        }
    }

    @objc open var date: Date? {
        get {
            switch dropDownMode {
            case .date:
                if isOptionalDropDown {
                    return  (super.text?.isEmpty ?? true)  ?  nil : datePicker.date
                } else {
                    return datePicker.date
                }
            case .time:
                if isOptionalDropDown {
                    return  (super.text?.isEmpty ?? true)  ?  nil : timePicker.date
                } else {
                    return timePicker.date
                }
            case .dateTime:
                if isOptionalDropDown {
                    return  (super.text?.isEmpty ?? true)  ?  nil : dateTimePicker.date
                } else {
                    return dateTimePicker.date
                }
            case .list, .textField, .multiList:
                return nil
            }
        }
        set {
            setDate(date: newValue, animated: false)
        }
    }

    @objc open func setDate(date: Date?, animated: Bool) {
        switch dropDownMode {
        case .date:
            let selectedItem: String?
            if let date = date {
                selectedItem = dateFormatter.string(from: date)
            } else {
                selectedItem = nil
            }
            privateSetSelectedItems(selectedItems: [selectedItem], animated: animated, shouldNotifyDelegate: false)
        case .time:
            let selectedItem: String?
            if let date = date {
                selectedItem = timeFormatter.string(from: date)
            } else {
                selectedItem = nil
            }

            privateSetSelectedItems(selectedItems: [selectedItem], animated: animated, shouldNotifyDelegate: false)
        case .dateTime:
            let selectedItem: String?
            if let date = date {
                selectedItem = dateTimeFormatter.string(from: date)
            } else {
                selectedItem = nil
            }

            privateSetSelectedItems(selectedItems: [selectedItem], animated: animated, shouldNotifyDelegate: false)
        default:
            break
        }
    }

    public var dateComponents: DateComponents {
        let components: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year, .era]
        return Calendar.current.dateComponents(components, from: date ?? Date())
    }

    public var year: Int {   return dateComponents.year ?? 0 }
    public var month: Int {   return dateComponents.month ?? 0 }
    public var day: Int {   return dateComponents.day ?? 0 }
    public var hour: Int {   return dateComponents.hour ?? 0 }
    public var minute: Int {   return dateComponents.minute ?? 0 }
    public var second: Int {   return dateComponents.second ?? 0 }
}
