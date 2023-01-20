//
//  IQDropDownTextField+Date.swift
//  IQDropDownTextFieldSwift
//
//  Created by Iftekhar on 18/12/21.
//

import UIKit

extension IQDropDownTextField {

    // MARK: - UIDatePicker delegate

    @objc func dateChanged(_ picker:UIDatePicker) {
        self._setSelectedItem(selectedItem: self.dateFormatter.string(from: picker.date), animated:false, shouldNotifyDelegate:true)
    }

    @objc func timeChanged(_ picker:UIDatePicker) {
        self._setSelectedItem(selectedItem: self.timeFormatter.string(from: picker.date), animated:false, shouldNotifyDelegate:true)
    }

    @objc func dateTimeChanged(_ picker:UIDatePicker) {
        self._setSelectedItem(selectedItem: self.dateTimeFormatter.string(from: picker.date), animated:false, shouldNotifyDelegate:true)
    }

    public var date: Date? {
        get {
            switch (self.dropDownMode)
            {
                case .date:

                    if isOptionalDropDown {
                        return  (super.text?.isEmpty ?? true)  ?  nil : self.datePicker.date
                    } else {
                        return self.datePicker.date
                    }

                case .time:

                    if isOptionalDropDown {
                        return  (super.text?.isEmpty ?? true)  ?  nil : self.timePicker.date
                    } else {
                        return self.timePicker.date
                    }

                case .dateTime:

                    if isOptionalDropDown {
                        return  (super.text?.isEmpty ?? true)  ?  nil : self.dateTimePicker.date
                    } else {
                        return self.dateTimePicker.date
                    }
            case .list, .textField:
                return nil
            }
        }
        set {
            self.setDate(date: newValue ?? Date(), animated:false)
        }
    }

    public func setDate(date: Date, animated:Bool) {
        switch (self.dropDownMode)
        {
            case .date:
                self._setSelectedItem(selectedItem: self.dateFormatter.string(from: date), animated:animated, shouldNotifyDelegate:false)
                break
            case .time:
                self._setSelectedItem(selectedItem: self.timeFormatter.string(from: date), animated:animated, shouldNotifyDelegate:false)
                break
            case .dateTime:
                self._setSelectedItem(selectedItem: self.dateTimeFormatter.string(from: date), animated:animated, shouldNotifyDelegate:false)
                break
            default:
                break
        }
    }

    public var dateComponents: DateComponents {
        return Calendar.current.dateComponents([.second,.minute,.hour,.day,.month,.year,.era], from: date ?? Date())
    }

    public var year: Int {   return self.dateComponents.year ?? 0 }
    public var month: Int {   return self.dateComponents.month ?? 0 }
    public var day: Int {   return self.dateComponents.day ?? 0 }
    public var hour: Int {   return self.dateComponents.hour ?? 0 }
    public var minute: Int {   return self.dateComponents.minute ?? 0 }
    public var second: Int {   return self.dateComponents.second ?? 0 }
}
