//
//  ViewController.swift
//  DropDownTextFieldSwift
//
//  Created by Iftekhar on 31/08/20.
//  Copyright © 2020 Iftekhar. All rights reserved.
//

import UIKit
import IQDropDownTextFieldSwift

class ViewController: UIViewController {

//    @IBOutlet var mainStackView: UIStackView!

    @IBOutlet var textFieldTextPicker: IQDropDownTextField!
    @IBOutlet var textFieldOptionalTextPicker: IQDropDownTextField!
    @IBOutlet var textFieldMultiListTextPicker: IQDropDownTextField!
    @IBOutlet var textFieldDatePicker: IQDropDownTextField!
    @IBOutlet var textFieldTimePicker: IQDropDownTextField!
    @IBOutlet var textFieldDateTimePicker: IQDropDownTextField!

//    private var dropDown: IQDropDownTextField = IQDropDownTextField()

    // swiftlint:disable function_body_length
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.dropDown.itemList = ["London",
//                                  "Johannesburg",
//                                  "Moscow",
//                                  "Mumbai",
//                                  "Tokyo",
//                                  "Sydney",
//                                  "Paris",
//                                  "Bangkok",
//                                  "New York",
//                                  "Istanbul",
//                                  "Dubai",
//                                  "Singapore"]
//        self.dropDown.dropDownMode = .list
//        self.dropDown.selectedRow = 2
//        self.dropDown.isOptionalDropDown = true
//        self.mainStackView.addArrangedSubview(self.dropDown)

        textFieldTextPicker.showDismissToolbar = true
        textFieldOptionalTextPicker.showDismissToolbar = true
        textFieldMultiListTextPicker.showDismissToolbar = true
        textFieldDatePicker.showDismissToolbar = true
        textFieldTimePicker.showDismissToolbar = true
        textFieldDateTimePicker.showDismissToolbar = true

        let indicator: UIActivityIndicatorView! = {
            if #available(iOS 13.0, *) {
                return UIActivityIndicatorView(style: .medium)
            } else {
                return UIActivityIndicatorView(style: .gray)
            }
        }()
        indicator.startAnimating()

        let aSwitch: UISwitch = UISwitch()

        textFieldTextPicker.itemList = ["London",
                                        "Johannesburg",
                                        "Moscow",
                                        "Mumbai",
                                        "Tokyo",
                                        "Sydney",
                                        "Paris",
                                        "Bangkok",
                                        "New York",
                                        "Istanbul",
                                        "Dubai",
                                        "Singapore"]

//        textFieldTextPicker.itemList = ["Thomas Jefferson High School for Science and Technology",
//                                        "Gwinnett School of Mathematics, Science and Technology",
//                                        "California Academy of Mathematics and Science",
//                                        "Loveless Academic Magnet Program High School",
//                                        "Irma Lerma Rangel Young Women's Leadership School",
//                                        "Middlesex County Academy for Science, Mathematics and Engineering Technologies",
//                                        "Queens High School for the Sciences at York College"]
//        textFieldTextPicker.adjustsFontSizeToFitWidth = false

        textFieldTextPicker.selectedRow = 2
        let viewList: [UIView?] = [nil, indicator, nil, aSwitch]
        textFieldTextPicker.itemListView = viewList

        /*
            Uncomment the following lines to set a custom font or text color for the items,
            as well as a custom text color for the optional item.
         */
    //    textFieldTextPicker.font = [UIFont fontWithName:@"Montserrat-Regular" size:16];
    //    textFieldTextPicker.textColor = [UIColor redColor];
    //    textFieldTextPicker.optionalItemTextColor = [UIColor brownColor];

        textFieldOptionalTextPicker.itemList = ["1", "2", "3", "4", "5", "6"]
        textFieldOptionalTextPicker.selectedRow = 3

        textFieldOptionalTextPicker.selectionFormatHandler = { (selectedItem, selectedIndex) in

            if let selectedItem = selectedItem {
                if selectedItem == "1" {
                    return selectedItem + " Year Old"
                } else {
                    return selectedItem + " Years Old"
                }
            } else {
                return ""
            }
        }
        textFieldMultiListTextPicker.dropDownMode = .multiList
        let heightFeet: [String] = ["Not Sure", "4", "5", "6", "7", "8"]
        let heightInches: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]

//        textFieldMultiListTextPicker.widthsForComponents = [100, 150]
//        textFieldMultiListTextPicker.heightsForComponents = [30, 100]
        textFieldMultiListTextPicker.isOptionalDropDowns = [true, false]
        textFieldMultiListTextPicker.optionalItemTexts = ["Select Feet", "Select Inches"]
        textFieldMultiListTextPicker.multiItemList = [heightFeet, heightInches]
        textFieldMultiListTextPicker.multilistSelectionFormatHandler = { (selectedItems, selectedIndexes) in

            if selectedIndexes.first == 0 {
                return "Not Sure"
            } else if let first = selectedItems.first, let first = first,
                        let last = selectedItems.last, let last = last {
                return "\(first)' \(last)\""
            } else {
                return ""
            }
        }

    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"EEE MMMM dd yyyy"];
    //    [textFieldDatePicker setDateFormatter:formatter];

        textFieldDatePicker.dropDownMode = .date
        textFieldTimePicker.dropDownMode = .time
        textFieldDateTimePicker.dropDownMode = .dateTime

        textFieldTextPicker.delegate = self
        textFieldTextPicker.dataSource = self

        textFieldOptionalTextPicker.delegate = self
        textFieldOptionalTextPicker.dataSource = self

        textFieldDatePicker.delegate = self
        textFieldDatePicker.dataSource = self

        textFieldTimePicker.delegate = self
        textFieldTimePicker.dataSource = self

        textFieldDateTimePicker.delegate = self
        textFieldDateTimePicker.dataSource = self

        if #available(iOS 15.0, *) {
            textFieldTextPicker.showMenuButton = true
            textFieldOptionalTextPicker.showMenuButton = true
            textFieldMultiListTextPicker.showMenuButton = true
            textFieldDatePicker.showMenuButton = true
            textFieldTimePicker.showMenuButton = true
            textFieldDateTimePicker.showMenuButton = true
        }

//        dropDown.delegate = self
//        dropDown.dataSource = self
    }
    // swiftlint:enable function_body_length

    func textField(textField: IQDropDownTextField, didSelectItem item: String?) {
        print(#function)
//        print(item)
    }

    func textField(textField: IQDropDownTextField!, didSelectDate date: NSDate?) {
        print(#function)
//        print(date)
    }

    func textField(textField: IQDropDownTextField, canSelectItem item: String?) -> Bool {
        print(#function)
//        print(item)
        return true
    }

    func textField(textField: IQDropDownTextField, proposedSelectionModeForItem item: String?) -> IQProposedSelection {
        print(#function)
//        print(item)
        return .both
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        print(#function)
    }

    func textFieldDidEndEditing(textField: UITextField) {
        print(#function)
    }

    func doneClicked(button: UIBarButtonItem!) {
        self.view.endEditing(true)

//        print("textFieldTextPicker.selectedItem: \(textFieldTextPicker.selectedItem)")
//        print("textFieldOptionalTextPicker.selectedItem: \(textFieldOptionalTextPicker.selectedItem)")
//        print("textFieldDatePicker.selectedItem: \(textFieldDatePicker.selectedItem)")
//        print("textFieldTimePicker.selectedItem: \(textFieldTimePicker.selectedItem)")
//        print("textFieldDateTimePicker.selectedItem: \(textFieldDateTimePicker.selectedItem)")
    }

    @IBAction func isOptionalToggle(_ sender: UIButton) {
        textFieldTextPicker.isOptionalDropDown = !textFieldTextPicker.isOptionalDropDown
        textFieldOptionalTextPicker.isOptionalDropDown = !textFieldOptionalTextPicker.isOptionalDropDown
        textFieldMultiListTextPicker.isOptionalDropDown = !textFieldMultiListTextPicker.isOptionalDropDown
        textFieldDatePicker.isOptionalDropDown = !textFieldDatePicker.isOptionalDropDown
        textFieldTimePicker.isOptionalDropDown = !textFieldTimePicker.isOptionalDropDown
        textFieldDateTimePicker.isOptionalDropDown = !textFieldDateTimePicker.isOptionalDropDown
//        self.dropDown.isOptionalDropDown = !self.dropDown.isOptionalDropDown
    }

    @IBAction func resetAction(_ sender: UIButton) {
        textFieldTextPicker.selectedItem = nil
        textFieldOptionalTextPicker.selectedItem = nil
        textFieldMultiListTextPicker.selectedItem = nil
        textFieldDatePicker.selectedItem = nil
        textFieldTimePicker.date = nil
        textFieldDateTimePicker.selectedItem = nil
//        self.dropDown.selectedItem = nil
    }
}

extension ViewController: IQDropDownTextFieldDelegate, IQDropDownTextFieldDataSource {
    func textField(textField: IQDropDownTextField, didSelectItems items: [String?]) {
    }

    func textField(textField: IQDropDownTextField, didSelectDate date: Date?) {
    }

    func textField(textField: IQDropDownTextField, canSelectItem item: String) -> Bool {
        return true
    }

    func textField(textField: IQDropDownTextField, proposedSelectionModeForItem item: String) -> IQProposedSelection {
        return .both
    }
}
