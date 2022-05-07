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

public protocol IQDropDownTextFieldDelegate : UITextFieldDelegate {

    //Called when textField changes it's selected item. Supported for IQDropDownModeTextPicker
    func textField(textField:IQDropDownTextField, didSelectItem item: String?)

    //Called when textField changes it's selected item. Supported for IQDropDownModeTimePicker, IQDropDownModeDatePicker, IQDropDownModeDateTimePicker
    func textField(textField:IQDropDownTextField, didSelectDate date:Date?)

}

public protocol IQDropDownTextFieldDataSource : AnyObject {

    //Check if an item can be selected by dropdown texField.
    func textField(textField:IQDropDownTextField, canSelectItem item:String) -> Bool

    //If canSelectItem return NO, then textField:proposedSelectionModeForItem: asked for propsed selection mode.
//IQProposedSelectionAbove: pickerView find the nearest items above the deselected item that can be selected and then selecting that row.
//IQProposedSelectionBelow: pickerView find the nearest items below the deselected item that can be selected and then selecting that row.
//IQProposedSelectionBoth: pickerView find the nearest items that can be selected above or below the deselected item and then selecting that row.
    func textField(textField:IQDropDownTextField, proposedSelectionModeForItem item:String) -> IQProposedSelection
}

extension IQDropDownTextFieldDataSource {

    func textField(textField: IQDropDownTextField, didSelectDate date: Date?) { }
    func textField(textField: IQDropDownTextField, canSelectItem item: String) -> Bool { return true }
    func textField(textField: IQDropDownTextField, proposedSelectionModeForItem item: String) -> IQProposedSelection { return .both }
}

open class IQDropDownTextField: UITextField {

    public static let optionalTextFieldIndex: Int = -1

    private lazy var _pickerView: UIPickerView = {
        let _pickerView = UIPickerView()
        _pickerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _pickerView.showsSelectionIndicator = true
        _pickerView.delegate = self
        _pickerView.dataSource = self
        return _pickerView
    }()

    public lazy var timePicker: UIDatePicker = {
        let _timePicker = UIDatePicker()
        _timePicker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _timePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            _timePicker.preferredDatePickerStyle = .wheels
        }
        _timePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
        return _timePicker
    }()

    public lazy var dateTimePicker: UIDatePicker = {
        let _dateTimePicker = UIDatePicker()
        _dateTimePicker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _dateTimePicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            _dateTimePicker.preferredDatePickerStyle = .wheels
        }
        _dateTimePicker.addTarget(self, action: #selector(dateTimeChanged(_:)), for: .valueChanged)
        return _dateTimePicker
    }()

    public lazy var datePicker: UIDatePicker = {
        let _datePicker = UIDatePicker()
        _datePicker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            _datePicker.preferredDatePickerStyle = .wheels
        }
        _datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return _datePicker
    }()

    public var datePickerMode: UIDatePicker.Mode {
        get {
            return self.datePicker.datePickerMode
        }
        set {
            if self.dropDownMode == .date {
                self.datePicker.datePickerMode = newValue

                switch (newValue) {
                case .countDownTimer:
                    self.dateFormatter.dateStyle = .none
                    self.dateFormatter.timeStyle = .none
                case .date:
                    self.dateFormatter.dateStyle = .short
                    self.dateFormatter.timeStyle = .none
                case .time:
                    self.timeFormatter.dateStyle = .none
                    self.timeFormatter.timeStyle = .short
                case .dateAndTime:
                    self.dateTimeFormatter.dateStyle = .short
                    self.dateTimeFormatter.timeStyle = .short
                @unknown default:
                    break
                }
            }
        }
    }

    /**
     Sets a custom font for the IQDropdownTextField items. Default is boldSystemFontOfSize:18.0.
     */
    public var dropDownFont: UIFont?

    /**
     Sets a custom color for the IQDropdownTextField items. Default is blackColor.
     */
    public var dropDownTextColor: UIColor?

    public var dateFormatter: DateFormatter = DateFormatter() {
        didSet {
            self.datePicker.locale = dateFormatter.locale
        }
    }

    public var timeFormatter: DateFormatter = DateFormatter() {
        didSet {
            self.timePicker.locale = timeFormatter.locale
        }
    }

    public var dateTimeFormatter: DateFormatter = DateFormatter() {
        didSet {
            self.dateTimePicker.locale = dateTimeFormatter.locale
        }
    }

    open var _delegate:IQDropDownTextFieldDelegate?
    open override var delegate: UITextFieldDelegate? {
        didSet {
            _delegate = delegate as? IQDropDownTextFieldDelegate
        }
    }

    public var dataSource: IQDropDownTextFieldDataSource?

    public var dropDownMode:IQDropDownMode = .list {
        didSet {
            switch (dropDownMode)  {
            case .list:

                self.inputView = _pickerView
                self.setSelectedRow(row: self.selectedRow, animated:true)

                break
            case .date:

                self.inputView = self.datePicker

                if self.isOptionalDropDown == false {
                    self.date = self.datePicker.date
                }

                break
            case .time:

                self.inputView = self.timePicker

                if self.isOptionalDropDown == false {
                    self.date = self.timePicker.date
                }

                break
            case .dateTime:

                self.inputView = self.dateTimePicker

                if self.isOptionalDropDown == false {
                    self.date = self.dateTimePicker.date
                }

                break
            case .textField:
                self.inputView = nil
                break
            }
        }
    }


    private var _optionalItemText: String?
    @IBInspectable public var optionalItemText: String? {
        get {
            if let _optionalItemText = _optionalItemText, !_optionalItemText.isEmpty {
                return _optionalItemText
            }
            else
            {
                return NSLocalizedString("Select", comment: "")
            }
        }
        set {
            _optionalItemText = newValue
            self._updateOptionsList()
        }
    }

    private var _hasSetInitialIsOptional: Bool = false
    private var _isOptionalDropDown: Bool = false
    @IBInspectable public var isOptionalDropDown: Bool {
        get { return _isOptionalDropDown }
        set(newValue) {
            if _hasSetInitialIsOptional == false || _isOptionalDropDown != newValue {

                let previousSelectedRow:Int = self.selectedRow

                _isOptionalDropDown = newValue
                _hasSetInitialIsOptional = true

                if self.dropDownMode == .list {
                    self._pickerView.reloadAllComponents()
                    self.selectedRow = previousSelectedRow
                }
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

    public var itemList:[String] = [] {
        didSet {
            //Refreshing pickerView
            self.isOptionalDropDown = _isOptionalDropDown
            let selectedRow = self.selectedRow
            self.selectedRow = selectedRow
        }
    }
    
    public var itemListView:[Any] = [] {
        didSet {
            //Refreshing pickerView
            self.isOptionalDropDown = _isOptionalDropDown
            let selectedRow = self.selectedRow
            self.selectedRow = selectedRow
        }
    }
    public var itemListUI:[String]? {
        didSet {
            //Refreshing pickerView
            self.isOptionalDropDown = _isOptionalDropDown
            let selectedRow = self.selectedRow
            self.selectedRow = selectedRow
        }
    }

    open override var adjustsFontSizeToFitWidth: Bool {
        didSet {
            self._updateOptionsList()
        }
    }

    private var hasSetInitialIsOptional:Bool = false

    func dealloc() {
        _pickerView.delegate = nil
        _pickerView.dataSource = nil
        self.delegate = nil
        dataSource = nil
        _optionalItemText = nil
    }

    // MARK: - Initialization

    func initialize() {
        self.contentVerticalAlignment = .center
        self.contentHorizontalAlignment = .center

        //These will update the UI and other components, all the validation added if awakeFromNib for textField is called after custom UIView awakeFromNib call
        do {
            let mode = self.dropDownMode
            self.dropDownMode = mode

            self.isOptionalDropDown = self.hasSetInitialIsOptional ? self.isOptionalDropDown : true
        }

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short

        dateTimeFormatter.dateStyle = .medium
        dateTimeFormatter.timeStyle = .short
    }

    override init(frame:CGRect) {
        super.init(frame:frame)
        self.initialize()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }

    // MARK: - UIView overrides
    open override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        _pickerView.selectRow(_pickerSelectedRow, inComponent:0, animated:false)
        return result
    }

    // MARK: - UITextField overrides
    open override func caretRect(for position: UITextPosition) -> CGRect {
        if self.dropDownMode == .textField {
            return super.caretRect(for: position)
        } else {
            return .zero
        }
    }


    // MARK: - Selected Row

    private var _pickerSelectedRow = -1
    public var selectedRow: Int {
        get {
            var pickerViewSelectedRow:Int = _pickerSelectedRow   //It may return -1
            pickerViewSelectedRow = max(pickerViewSelectedRow, 0)

            return pickerViewSelectedRow - (self.isOptionalDropDown ? 1 : 0)
        }
        set {
            self.setSelectedRow(row: newValue, animated:false)
        }
    }

    public func setSelectedRow(row:Int, animated:Bool) {
        if row == Self.optionalTextFieldIndex {
            if self.isOptionalDropDown {
                super.text = ""
            } else if itemList.count > 0 {
                let list: [String] = itemListUI ?? itemList
                super.text = list[0]
            } else {
                super.text = ""
            }
        } else {
            let list: [String] = itemListUI ?? itemList

            if list.count > row {
                super.text = list[row]
            } else {
                super.text = ""
            }
        }

        let pickerViewRow:Int = row + (self.isOptionalDropDown ? 1 : 0)
        _pickerSelectedRow = pickerViewRow
        _pickerView.selectRow(pickerViewRow, inComponent:0, animated:animated)
    }

    // MARK: - Toolbar
    public var showDismissToolbar:Bool {
        get {
            return (self.inputAccessoryView == dismissToolbar)
        }

        set {
            self.inputAccessoryView = (newValue ? self.dismissToolbar : nil)
        }
    }

    private lazy var dismissToolbar: UIToolbar = {
        let _dismissToolbar = UIToolbar()
        _dismissToolbar.isTranslucent = true
        _dismissToolbar.sizeToFit()
        let buttonflexible:UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target:nil, action:nil)
        let buttonDone:UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: .done, target:self, action: #selector(resignFirstResponder))
        _dismissToolbar.items = [buttonflexible,buttonDone]
        return _dismissToolbar
    }()

    // MARK: - Setters
    // `setDropDownMode:` has moved as a setter.

    // `setItemList:` has moved as a setter.

    public var selectedItem: String? {
        get {
            switch (dropDownMode) {
                case .list:
                    let selectedRow:Int = self.selectedRow
                    if selectedRow >= 0 {
                        return itemList[selectedRow]
                    } else {
                        return nil
                    }
                case .date:
                    return  (super.text?.isEmpty ?? true)  ?  nil : self.dateFormatter.string(from: self.datePicker.date)
                case .time:
                    return  (super.text?.isEmpty ?? true)  ?  nil : self.timeFormatter.string(from: self.timePicker.date)
                case .dateTime:
                    return  (super.text?.isEmpty ?? true)  ?  nil : self.dateTimeFormatter.string(from: self.dateTimePicker.date)
                case .textField:
                    return super.text
            }
        }

        set {
            self._setSelectedItem(selectedItem: newValue, animated:false, shouldNotifyDelegate:false)
        }
    }

    public func setSelectedItem(selectedItem:String?, animated:Bool) {
        self._setSelectedItem(selectedItem: selectedItem, animated:animated, shouldNotifyDelegate:false)
    }

    func _updateOptionsList() {

        switch (dropDownMode) {
        case .date:
            if self.isOptionalDropDown == false {
                self.date = self.datePicker.date
            }
        case .time:
            if self.isOptionalDropDown == false {
                self.date = self.timePicker.date
            }
        case .dateTime:

            if self.isOptionalDropDown == false {
                self.date = self.dateTimePicker.date
            }
        case .list:
            _pickerView.reloadAllComponents()
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


// MARK: - UIPickerView data source
extension IQDropDownTextField: UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.itemList.count + (self.isOptionalDropDown ? 1 : 0)
    }
}

// MARK: UIPickerView delegate
extension IQDropDownTextField: UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let row = row - (self.isOptionalDropDown ? 1 : 0)

        if row == Self.optionalTextFieldIndex {

            let labelText: UILabel
            if let label = view as? UILabel {
                labelText = label
            } else {
                labelText = UILabel()
                labelText.textAlignment = .center
                labelText.adjustsFontSizeToFitWidth = true
                labelText.backgroundColor = UIColor.clear
                labelText.backgroundColor = UIColor.clear
            }

            labelText.font = self.dropDownFont ?? UIFont.systemFont(ofSize: 18)
            labelText.textColor = self.dropDownTextColor ?? UIColor.black

            labelText.isEnabled = false
            labelText.text = self.optionalItemText

            return labelText

        } else {

            let viewToReturn: UIView?

            if itemListView.count > row, let view = itemListView[row] as? UIView {
                //Archiving and Unarchiving is necessary to copy UIView instance.
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
                    labelText.adjustsFontSizeToFitWidth = true
                    labelText.backgroundColor = UIColor.clear
                    labelText.backgroundColor = UIColor.clear
                }

                labelText.font = self.dropDownFont ?? UIFont.systemFont(ofSize: 18)
                labelText.textColor = self.dropDownTextColor ?? UIColor.black

                let text = self.itemList[row]
                labelText.text = text
                labelText.adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth

                let canSelect:Bool
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

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        _pickerSelectedRow = row

        let row = row - (self.isOptionalDropDown ? 1 : 0)

        if row == Self.optionalTextFieldIndex {
            self._setSelectedItem(selectedItem: nil, animated:false, shouldNotifyDelegate:true)
        } else if row >= 0 {

            let text:String = self.itemList[row]

            let canSelect:Bool
            if let result = dataSource?.textField(textField: self, canSelectItem: text) {
                canSelect = result
            } else {
                canSelect = true
            }

            if canSelect {
                self._setSelectedItem(selectedItem: text, animated:false, shouldNotifyDelegate:true)
            } else {

                let proposedSelection:IQProposedSelection
                if let result = dataSource?.textField(textField: self, proposedSelectionModeForItem: text) {
                    proposedSelection = result
                } else {
                    proposedSelection = .both
                }

                var aboveIndex:Int = row-1
                var belowIndex:Int = row+1

                if proposedSelection == .above {
                    belowIndex = self.itemList.count
                } else if proposedSelection == .below {
                    aboveIndex = -1
                }


                while aboveIndex >= 0 || belowIndex < self.itemList.count {
                    if aboveIndex >= 0 {
                        let aboveText:String = self.itemList[aboveIndex]

                        if let result = dataSource?.textField(textField: self, canSelectItem: aboveText), result == true {
                            self._setSelectedItem(selectedItem: aboveText, animated:true, shouldNotifyDelegate:true)
                            return
                        }

                        aboveIndex -= 1
                    }

                    if belowIndex < self.itemList.count {
                        let belowText:String = self.itemList[belowIndex]

                        if let result = dataSource?.textField(textField: self, canSelectItem: belowText), result == true {
                            self._setSelectedItem(selectedItem: belowText, animated:true, shouldNotifyDelegate:true)
                            return
                        }

                        belowIndex += 1
                    }
                }

                return self.setSelectedRow(row: 0, animated:true)
            }
        }
    }
}

extension IQDropDownTextField {

    func _setSelectedItem(selectedItem: String?, animated:Bool, shouldNotifyDelegate:Bool) {
        switch (self.dropDownMode) {
            case .list:

                if let selectedItem = selectedItem, let index = self.itemList.firstIndex(of: selectedItem) {
                    self.setSelectedRow(row: index, animated:animated)

                    if shouldNotifyDelegate {
                        _delegate?.textField(textField: self, didSelectItem: selectedItem)
                    }
                } else {
                    let selectedIndex = self.isOptionalDropDown ? Self.optionalTextFieldIndex : 0
                    self.setSelectedRow(row: selectedIndex, animated:animated)

                    if shouldNotifyDelegate {
                        _delegate?.textField(textField: self, didSelectItem: nil)
                    }
                }
            case .date:

                if let selectedItem = selectedItem, let date = self.dateFormatter.date(from: selectedItem) {
                    super.text = selectedItem
                    self.datePicker.setDate(date, animated:animated)

                    if shouldNotifyDelegate {
                        _delegate?.textField(textField: self, didSelectDate: date)
                    }
                } else if self.isOptionalDropDown, (selectedItem?.isEmpty ?? true) {
                    super.text = ""

                    self.datePicker.setDate(Date(), animated:animated)

                    if shouldNotifyDelegate {
                        _delegate?.textField(textField: self, didSelectDate: nil)
                    }
                }
            case .time:

                if let selectedItem = selectedItem, let time = self.timeFormatter.date(from: selectedItem) {
                    let day:Date = Date(timeIntervalSinceReferenceDate: 0)
                    var componentsDay:DateComponents = Calendar.current.dateComponents([.era, .year, .month,.day], from: day)
                    let componentsTime:DateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: time)
                    componentsDay.hour = componentsTime.hour
                    componentsDay.minute = componentsTime.minute
                    componentsDay.second = componentsTime.second

                    if let date = Calendar.current.date(from: componentsDay) {
                        super.text = selectedItem
                        self.timePicker.setDate(date, animated:animated)

                        if shouldNotifyDelegate {
                            _delegate?.textField(textField: self, didSelectDate: date)
                        }
                    }
                } else if self.isOptionalDropDown, (selectedItem?.isEmpty ?? true) {
                    super.text = ""
                    self.timePicker.setDate(Date(), animated:animated)

                    if shouldNotifyDelegate {
                        _delegate?.textField(textField: self, didSelectDate: nil)
                    }
                }

            case .dateTime:

                if let selectedItem = selectedItem, let date: Date = self.dateTimeFormatter.date(from: selectedItem) {
                    super.text = selectedItem
                    self.dateTimePicker.setDate(date, animated:animated)

                    if shouldNotifyDelegate {
                        _delegate?.textField(textField: self, didSelectDate: date)
                    }
                } else if self.isOptionalDropDown, (selectedItem?.isEmpty ?? true) {

                    super.text = ""
                    self.dateTimePicker.setDate(Date(), animated:animated)

                    if shouldNotifyDelegate {
                        _delegate?.textField(textField: self, didSelectDate: nil)
                    }
                }
                break

            case .textField:
                super.text = selectedItem

                break
        }
    }
}
