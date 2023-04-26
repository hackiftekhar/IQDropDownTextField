//
//  IQDropDownTextField.swift
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

// swiftlint:disable type_body_length
// swiftlint:disable file_length
open class IQDropDownTextField: UITextField {

    public static let optionalItemIndex: Int = -1

    open lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.showsSelectionIndicator = true
        view.delegate = self
        view.dataSource = self
        return view
    }()

    open lazy var timePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.datePickerMode = .time
        if #available(iOS 13.4, *) {
            view.preferredDatePickerStyle = .wheels
        }
        view.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
        return view
    }()

    open lazy var dateTimePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            view.preferredDatePickerStyle = .wheels
        }
        view.addTarget(self, action: #selector(dateTimeChanged(_:)), for: .valueChanged)
        return view
    }()

    open lazy var datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.datePickerMode = .date
        if #available(iOS 13.4, *) {
            view.preferredDatePickerStyle = .wheels
        }
        view.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return view
    }()

    private lazy var dismissToolbar: UIToolbar = {
        let view = UIToolbar()
        view.isTranslucent = true
        view.sizeToFit()
        let buttonflexible: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                              target: nil, action: nil)
        let buttonDone: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                                          action: #selector(resignFirstResponder))
        view.items = [buttonflexible, buttonDone]
        return view
    }()

    open var showDismissToolbar: Bool {
        get {
            return (inputAccessoryView == dismissToolbar)
        }

        set {
            inputAccessoryView = (newValue ? dismissToolbar : nil)
        }
    }

    // Sets a custom font for the IQDropdownTextField items. Default is boldSystemFontOfSize:18.0.
    open var dropDownFont: UIFont?

    // Sets a custom color for the IQDropdownTextField items. Default is blackColor.
    open var dropDownTextColor: UIColor?

    // Width and height to adopt for each section.
    // If you don't want to specify a row width then use 0 to calculate row width automatically.
    open var widthsForComponents: [CGFloat]?
    open var heightsForComponents: [CGFloat]?

    open var dateFormatter: DateFormatter = DateFormatter() {
        didSet {
            datePicker.locale = dateFormatter.locale
        }
    }

    open var timeFormatter: DateFormatter = DateFormatter() {
        didSet {
            timePicker.locale = timeFormatter.locale
        }
    }

    open var dateTimeFormatter: DateFormatter = DateFormatter() {
        didSet {
            dateTimePicker.locale = dateTimeFormatter.locale
        }
    }

    weak open var dropDownDelegate: IQDropDownTextFieldDelegate?
    weak open override var delegate: UITextFieldDelegate? {
        didSet {
            dropDownDelegate = delegate as? IQDropDownTextFieldDelegate
        }
    }

    open var dataSource: IQDropDownTextFieldDataSource?

    open var dropDownMode: IQDropDownMode = .list {
        didSet {
            switch dropDownMode {
            case .list, .multiList:
                inputView = pickerView
                setSelectedRows(rows: selectedRows, animated: true)
            case .date:

                inputView = datePicker

                if !isOptionalDropDown {
                    date = datePicker.date
                }
            case .time:

                inputView = timePicker

                if !isOptionalDropDown {
                    date = timePicker.date
                }
            case .dateTime:

                inputView = dateTimePicker

                if !isOptionalDropDown {
                    date = dateTimePicker.date
                }
            case .textField:
                inputView = nil
            }
        }
    }

    private var privateOptionalItemText: String?
    @IBInspectable open var optionalItemText: String? {
        get {
            if let privateOptionalItemText = privateOptionalItemText, !privateOptionalItemText.isEmpty {
                return privateOptionalItemText
            } else {
                return NSLocalizedString("Select", comment: "")
            }
        }
        set {
            privateOptionalItemText = newValue
            privateUpdateOptionsList()
        }
    }

    private var privateOptionalItemTexts: [String?] = []
    open var optionalItemTexts: [String?] {
        get {
            return privateOptionalItemTexts
        }
        set {
            privateOptionalItemTexts = newValue
            privateUpdateOptionsList()
        }
    }

    @IBInspectable open var isOptionalDropDown: Bool {
        get { return privateIsOptionalDropDowns.first ?? true }
        set {
            isOptionalDropDowns = [newValue]
        }
    }

    private var privateIsOptionalDropDowns: [Bool] = [true]
    open var isOptionalDropDowns: [Bool] {
        get { return privateIsOptionalDropDowns }
        set {
            if !hasSetInitialIsOptional || privateIsOptionalDropDowns != newValue {

                let previousSelectedRows: [Int] = selectedRows

                privateIsOptionalDropDowns = newValue
                hasSetInitialIsOptional = true

                if dropDownMode == .list || dropDownMode == .multiList {
                    pickerView.reloadAllComponents()
                    selectedRows = previousSelectedRows
                }
            }
        }
    }

    open var multilistSelectionFormatHandler: ((_ selectedItems: [String?], _ selectedIndexes: [Int]) -> String)? {
        didSet {
            if let handler = multilistSelectionFormatHandler {
                super.text = handler(selectedItems, selectedRows)
            } else {
                super.text = selectedItems.compactMap({ $0 }).joined(separator: ", ")
            }
        }
    }

    open var selectionFormatHandler: ((_ selectedItem: String?, _ selectedIndex: Int) -> String)? {
        didSet {
            if let handler = selectionFormatHandler {
                super.text = handler(selectedItem, selectedRow)
            } else {
                super.text = selectedItems.compactMap({ $0 }).joined(separator: ", ")
            }
        }
    }

    @available(*, deprecated, message: "use 'selectedItem' instead")
    open override var text: String? {
        didSet {
        }
    }

    @available(*, deprecated, message: "use 'selectedItem' instead")
    open override var attributedText: NSAttributedString? {
        didSet {
        }
    }

    open var itemList: [String] {
        get {
            multiItemList.first ?? []
        }
        set {
            multiItemList = [newValue]
        }
    }

    open var itemListView: [UIView?] {
        get {
            multiItemListView.first ?? []
        }
        set {
            multiItemListView = [newValue]
        }
    }

    open var multiItemList: [[String]] = [[]] {
        didSet {
            //Refreshing pickerView
            isOptionalDropDowns = privateIsOptionalDropDowns
            let selectedRows = selectedRows
            self.selectedRows = selectedRows
        }
    }

    open var multiItemListView: [[UIView?]] = [[]] {
        didSet {
            //Refreshing pickerView
            isOptionalDropDowns = privateIsOptionalDropDowns
            let selectedRows = selectedRows
            self.selectedRows = selectedRows
        }
    }

    open override var adjustsFontSizeToFitWidth: Bool {
        didSet {
            privateUpdateOptionsList()
        }
    }

    private var hasSetInitialIsOptional: Bool = false

    func dealloc() {
        pickerView.delegate = nil
        pickerView.dataSource = nil
        self.delegate = nil
        dataSource = nil
        privateOptionalItemText = nil
    }

    // MARK: - Initialization

    func initialize() {
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center

        // These will update the UI and other components,
        // all the validation added if awakeFromNib for textField is called after custom UIView awakeFromNib call
        do {
            let mode = dropDownMode
            dropDownMode = mode

            isOptionalDropDown = hasSetInitialIsOptional ? isOptionalDropDown : true
        }

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short

        dateTimeFormatter.dateStyle = .medium
        dateTimeFormatter.timeStyle = .short
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    // MARK: - UIView overrides
    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()

        for (index, selectdRow) in privatePickerSelectedRows where 0 <= selectdRow {
            pickerView.selectRow(selectdRow, inComponent: index, animated: false)
        }
        return result
    }

    // MARK: - UITextField overrides
    open override func caretRect(for position: UITextPosition) -> CGRect {
        if dropDownMode == .textField {
            return super.caretRect(for: position)
        } else {
            return .zero
        }
    }

    // MARK: - Selected Row

    open var selectedRow: Int {
        get {
            var pickerViewSelectedRow: Int = selectedRows.first /*It may return -1*/ ?? 0
            pickerViewSelectedRow = max(pickerViewSelectedRow, 0)
            return pickerViewSelectedRow - (isOptionalDropDown ? 1 : 0)
        }
        set {
            selectedRows = [newValue]
        }
    }

    // Key represents section index and value represents selection
    internal var privatePickerSelectedRows: [Int: Int] = [:]

    open var selectedRows: [Int] {
        get {
            var selection: [Int] = []
            for index in multiItemList.indices {

                let isOptionalDropDown: Bool
                if index < isOptionalDropDowns.count {
                    isOptionalDropDown = isOptionalDropDowns[index]
                } else if let last = isOptionalDropDowns.last {
                    isOptionalDropDown = last
                } else {
                    isOptionalDropDown = true
                }

                var pickerViewSelectedRow: Int = privatePickerSelectedRows[index] ?? -1   /*It may return -1*/
                pickerViewSelectedRow = max(pickerViewSelectedRow, 0)

                let finalSelection = pickerViewSelectedRow - (isOptionalDropDown ? 1 : 0)
                selection.append(finalSelection)
            }
            return selection
        }
        set {
            setSelectedRows(rows: newValue, animated: false)
        }
    }

    open func selectedRow(inSection section: Int) -> Int {
        privatePickerSelectedRows[section] ?? Self.optionalItemIndex
    }
    //    open func rowSize(forComponent component: Int) -> CGSize

    open func setSelectedRow(row: Int, animated: Bool) {
        setSelectedRows(rows: [row], animated: animated)
    }

    open func setSelectedRow(row: Int, inSection section: Int, animated: Bool) {
        var selectedRows = selectedRows
        selectedRows[section] = row
        setSelectedRows(rows: selectedRows, animated: animated)
    }

    open func setSelectedRows(rows: [Int], animated: Bool) {

        var finalResults: [String?] = []
        for (index, row) in rows.enumerated() {

            let itemList: [String]

            if index < multiItemList.count {
                itemList = multiItemList[index]
            } else {
                itemList = []
            }

            let isOptionalDropDown: Bool
            if index < isOptionalDropDowns.count {
                isOptionalDropDown = isOptionalDropDowns[index]
            } else if let last = isOptionalDropDowns.last {
                isOptionalDropDown = last
            } else {
                isOptionalDropDown = true
            }

            if row == Self.optionalItemIndex {

                if !isOptionalDropDown, !itemList.isEmpty {
                    finalResults.append(itemList[0])
                } else {
                    finalResults.append(nil)
                }
            } else {
                if row < itemList.count {
                    finalResults.append(itemList[row])
                } else {
                    finalResults.append(nil)
                }
            }

            let pickerViewRow: Int = row + (isOptionalDropDown ? 1 : 0)
            privatePickerSelectedRows[index] = pickerViewRow
            pickerView.selectRow(pickerViewRow, inComponent: index, animated: animated)
        }

        if let multilistSelectionFormatHandler = multilistSelectionFormatHandler {
            super.text = multilistSelectionFormatHandler(finalResults, rows)
        } else if let selectionFormatHandler = selectionFormatHandler,
                  let selectedItem = finalResults.first,
                  let selectedRow = rows.first {
            super.text = selectionFormatHandler(selectedItem, selectedRow)
        } else {
            super.text = finalResults.compactMap({ $0 }).joined(separator: ", ")
        }
    }

    // MARK: - Setters
    // `setDropDownMode:` has moved as a setter.

    // `setItemList:` has moved as a setter.

    open var selectedItem: String? {
        get {
            return selectedItems.first ?? nil
        }
        set {
            switch dropDownMode {
            case .multiList:
                if let newValue = newValue {
                    selectedItems = [newValue]
                } else {
                    selectedItems = multiItemList.map({ _ in nil }) // Resetting every section
                }
            case .list, .date, .time, .dateTime, .textField:
                selectedItems = [newValue]
            }
        }
    }

    open var selectedItems: [String?] {
        get {
            switch dropDownMode {
            case .list, .multiList:
                var finalSelection: [String?] = []
                for (index, selectedRow) in selectedRows.enumerated() {
                    if 0 <= selectedRow, index < multiItemList.count {
                        finalSelection.append(multiItemList[index][selectedRow])
                    } else {
                        finalSelection.append(nil)
                    }
                }
                return finalSelection
            case .date:
                return  (super.text?.isEmpty ?? true)  ?  [nil] : [dateFormatter.string(from: datePicker.date)]
            case .time:
                return  (super.text?.isEmpty ?? true)  ?  [nil] : [timeFormatter.string(from: timePicker.date)]
            case .dateTime:
                return  (super.text?.isEmpty ?? true)  ?  [nil] : [dateTimeFormatter.string(from: dateTimePicker.date)]
            case .textField:
                return [super.text]
            }
        }

        set {
            privateSetSelectedItems(selectedItems: newValue, animated: false, shouldNotifyDelegate: false)
        }
    }

    open func setSelectedItem(selectedItem: String?, animated: Bool) {
        privateSetSelectedItems(selectedItems: [selectedItem], animated: animated, shouldNotifyDelegate: false)
    }

    open func setSelectedItems(selectedItems: [String?], animated: Bool) {
        privateSetSelectedItems(selectedItems: selectedItems, animated: animated, shouldNotifyDelegate: false)
    }

    open func privateUpdateOptionsList() {

        switch dropDownMode {
        case .date:
            if !isOptionalDropDown {
                date = datePicker.date
            }
        case .time:
            if !isOptionalDropDown {
                date = timePicker.date
            }
        case .dateTime:

            if !isOptionalDropDown {
                date = dateTimePicker.date
            }
        case .list, .multiList:
            pickerView.reloadAllComponents()
        case .textField:
            break
        }
    }

    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(cut(_:)) || action == #selector(paste(_:)) {
            return false
        } else {
            return super.canPerformAction(action, withSender: sender)
        }
    }
}

internal extension IQDropDownTextField {

    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    func privateSetSelectedItems(selectedItems: [String?],
                                 animated: Bool, shouldNotifyDelegate: Bool) {
        switch dropDownMode {
        case .list, .multiList:

            var finalIndexes: [Int] = []
            var finalSelection: [String?] = []

            for (index, selectedItem) in selectedItems.enumerated() {

                if let selectedItem = selectedItem,
                   index < multiItemList.count,
                   let index = multiItemList[index].firstIndex(of: selectedItem) {
                    finalIndexes.append(index)
                    finalSelection.append(selectedItem)

                } else {

                    let isOptionalDropDown: Bool
                    if index < isOptionalDropDowns.count {
                        isOptionalDropDown = isOptionalDropDowns[index]
                    } else if let last = isOptionalDropDowns.last {
                        isOptionalDropDown = last
                    } else {
                        isOptionalDropDown = true
                    }

                    let selectedIndex = isOptionalDropDown ? Self.optionalItemIndex : 0
                    finalIndexes.append(selectedIndex)
                    finalSelection.append(nil)
                }
            }

            setSelectedRows(rows: finalIndexes, animated: animated)

            if shouldNotifyDelegate {
                if dropDownMode == .multiList {
                    dropDownDelegate?.textField(textField: self, didSelectItems: finalSelection)
                } else if let selectedItem = finalSelection.first {
                    dropDownDelegate?.textField(textField: self, didSelectItem: selectedItem)
                }
            }

        case .date:

            if let selectedItem = selectedItems.first,
               let selectedItem = selectedItem,
               let date = dateFormatter.date(from: selectedItem) {
                super.text = selectedItem
                datePicker.setDate(date, animated: animated)

                if shouldNotifyDelegate {
                    dropDownDelegate?.textField(textField: self, didSelectDate: date)
                }
            } else if isOptionalDropDown,
                      let selectedItem = selectedItems.first,
                      (selectedItem?.isEmpty ?? true) {
                super.text = ""

                datePicker.setDate(Date(), animated: animated)

                if shouldNotifyDelegate {
                    dropDownDelegate?.textField(textField: self, didSelectDate: nil)
                }
            }
        case .time:

            if let selectedItem = selectedItems.first,
               let selectedItem = selectedItem,
               let time = timeFormatter.date(from: selectedItem) {
                let day: Date = Date(timeIntervalSinceReferenceDate: 0)
                let componentsForDay: Set<Calendar.Component> = [.era, .year, .month, .day]
                let componentsForTime: Set<Calendar.Component> = [.hour, .minute, .second]
                var componentsDay: DateComponents = Calendar.current.dateComponents(componentsForDay, from: day)
                let componentsTime: DateComponents = Calendar.current.dateComponents(componentsForTime, from: time)
                componentsDay.hour = componentsTime.hour
                componentsDay.minute = componentsTime.minute
                componentsDay.second = componentsTime.second

                if let date = Calendar.current.date(from: componentsDay) {
                    super.text = selectedItem
                    timePicker.setDate(date, animated: animated)

                    if shouldNotifyDelegate {
                        dropDownDelegate?.textField(textField: self, didSelectDate: date)
                    }
                }
            } else if isOptionalDropDown,
                      let selectedItem = selectedItems.first,
                      (selectedItem?.isEmpty ?? true) {
                super.text = ""
                timePicker.setDate(Date(), animated: animated)

                if shouldNotifyDelegate {
                    dropDownDelegate?.textField(textField: self, didSelectDate: nil)
                }
            }

        case .dateTime:

            if let selectedItem = selectedItems.first,
               let selectedItem = selectedItem,
               let date: Date = dateTimeFormatter.date(from: selectedItem) {
                super.text = selectedItem
                dateTimePicker.setDate(date, animated: animated)

                if shouldNotifyDelegate {
                    dropDownDelegate?.textField(textField: self, didSelectDate: date)
                }
            } else if isOptionalDropDown,
                      let selectedItem = selectedItems.first,
                      (selectedItem?.isEmpty ?? true) {

                super.text = ""
                dateTimePicker.setDate(Date(), animated: animated)

                if shouldNotifyDelegate {
                    dropDownDelegate?.textField(textField: self, didSelectDate: nil)
                }
            }
        case .textField:
            super.text = selectedItems.compactMap({ $0 }).joined(separator: ", ")
        }
    }
    // swiftlint:enable cyclomatic_complexity
    // swiftlint:enable function_body_length
}
