//
//  IQDropDownTextField+Picker.swift
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

// MARK: - UIPickerView data source
@MainActor
extension IQDropDownTextField: UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return multiItemList.count
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let isOptionalDropDown: Bool
        if component < isOptionalDropDowns.count {
            isOptionalDropDown = isOptionalDropDowns[component]
        } else if let last = isOptionalDropDowns.last {
            isOptionalDropDown = last
        } else {
            isOptionalDropDown = true
        }

        return multiItemList[component].count + (isOptionalDropDown ? 1 : 0)
    }
}

// MARK: UIPickerView delegate
@MainActor
extension IQDropDownTextField: UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if let heightsForComponents = heightsForComponents,
           component < heightsForComponents.count,
           0 < heightsForComponents[component] {
            return heightsForComponents[component]
        }

        return 44
    }

    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if let widthsForComponents = widthsForComponents,
           component < widthsForComponents.count,
           0 < widthsForComponents[component] {
            return widthsForComponents[component]
        }

        // else calculating it's size.
        let availableWidth = (pickerView.bounds.width - 20) - 2 * CGFloat(multiItemList.count - 1)
        return availableWidth / CGFloat(multiItemList.count)
    }

    // swiftlint:disable function_body_length
    public func pickerView(_ pickerView: UIPickerView,
                           viewForRow row: Int, forComponent component: Int,
                           reusing view: UIView?) -> UIView {

        let isOptionalDropDown: Bool
        if component < isOptionalDropDowns.count {
            isOptionalDropDown = isOptionalDropDowns[component]
        } else if let last = isOptionalDropDowns.last {
            isOptionalDropDown = last
        } else {
            isOptionalDropDown = true
        }

        let row = row - (isOptionalDropDown ? 1 : 0)

        if row == Self.optionalItemIndex {

            let labelText: UILabel
            if let label = view as? UILabel {
                labelText = label
            } else {
                labelText = UILabel()
                labelText.textAlignment = .center
                labelText.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
                labelText.backgroundColor = UIColor.clear
                labelText.backgroundColor = UIColor.clear
            }

            labelText.font = dropDownFont ?? UIFont.systemFont(ofSize: 18)
            labelText.textColor = dropDownTextColor ?? UIColor.black

            labelText.isEnabled = false
            labelText.text = optionalItemText

            return labelText

        } else {

            let viewToReturn: UIView?

            if component < multiItemListView.count,
               row < multiItemListView[component].count,
               let view = multiItemListView[component][row] {

                // Archiving and Unarchiving is necessary to copy UIView instance.
                let viewData: Data = NSKeyedArchiver.archivedData(withRootObject: view)
                viewToReturn = NSKeyedUnarchiver.unarchiveObject(with: viewData) as? UIView
            } else {
                viewToReturn = nil
            }

            if let viewToReturn = viewToReturn {
                return viewToReturn
            } else {

                let labelText: UILabel
                if let label = view as? UILabel {
                    labelText = label
                } else {
                    labelText = UILabel()
                    labelText.textAlignment = .center
                    labelText.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
                    labelText.backgroundColor = UIColor.clear
                    labelText.backgroundColor = UIColor.clear
                }

                labelText.font = dropDownFont ?? UIFont.systemFont(ofSize: 18)
                labelText.textColor = dropDownTextColor ?? UIColor.black

                let itemList = multiItemList[component]
                let text = itemList[row]
                labelText.text = text
                labelText.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
                labelText.numberOfLines = adjustsFontSizeToFitWidth ? 1 : 0
                let canSelect: Bool
                if let result = dataSource?.textField(textField: self, canSelectItem: text) {
                    canSelect = result
                } else {
                    canSelect = true
                }
                labelText.isEnabled = canSelect

                return labelText
            }
        }
    }
    // swiftlint:enable function_body_length

    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    public func pickerView(_ pickerView: UIPickerView,
                           didSelectRow row: Int, inComponent component: Int) {

        privatePickerSelectedRows[component] = row

        let isOptionalDropDown: Bool
        if component < isOptionalDropDowns.count {
            isOptionalDropDown = isOptionalDropDowns[component]
        } else if let last = isOptionalDropDowns.last {
            isOptionalDropDown = last
        } else {
            isOptionalDropDown = true
        }

        let row = row - (isOptionalDropDown ? 1 : 0)

        if row == Self.optionalItemIndex {
            var selectedItems = selectedItems
            selectedItems[component] = nil
            privateSetSelectedItems(selectedItems: selectedItems, animated: false, shouldNotifyDelegate: true)
        } else if 0 <= row {

            let itemList = multiItemList[component]
            let text: String = itemList[row]

            let canSelect: Bool
            if let result = dataSource?.textField(textField: self, canSelectItem: text) {
                canSelect = result
            } else {
                canSelect = true
            }

            if canSelect {
                var selectedItems = selectedItems
                selectedItems[component] = text
                privateSetSelectedItems(selectedItems: selectedItems, animated: false, shouldNotifyDelegate: true)
            } else {

                let proposedSelection: IQProposedSelection
                if let result = dataSource?.textField(textField: self, proposedSelectionModeForItem: text) {
                    proposedSelection = result
                } else {
                    proposedSelection = .both
                }

                var aboveIndex: Int = row-1
                var belowIndex: Int = row+1

                if proposedSelection == .above {
                    belowIndex = itemList.count
                } else if proposedSelection == .below {
                    aboveIndex = -1
                }

                while 0 <= aboveIndex || belowIndex < itemList.count {
                    if 0 <= aboveIndex {
                        let aboveText: String = itemList[aboveIndex]

                        if let result = dataSource?.textField(textField: self, canSelectItem: aboveText), result {
                            var selectedItems = selectedItems
                            selectedItems[component] = aboveText
                            privateSetSelectedItems(selectedItems: selectedItems,
                                                    animated: true,
                                                    shouldNotifyDelegate: true)
                            return
                        }

                        aboveIndex -= 1
                    }

                    if belowIndex < itemList.count {
                        let belowText: String = itemList[belowIndex]

                        if let result = dataSource?.textField(textField: self, canSelectItem: belowText), result {
                            var selectedItems = selectedItems
                            selectedItems[component] = belowText
                            privateSetSelectedItems(selectedItems: selectedItems,
                                                    animated: true,
                                                    shouldNotifyDelegate: true)
                            return
                        }

                        belowIndex += 1
                    }
                }

                var selectedRows = selectedRows
                selectedRows[component] = 0
                setSelectedRows(rows: selectedRows, animated: true)
            }
        }
    }
    // swiftlint:enable cyclomatic_complexity
    // swiftlint:enable function_body_length
}
