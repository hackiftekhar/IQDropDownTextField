//
//  IQDropDownTextField+Menu.swift
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

@available(iOS 15.0, *)
@MainActor
extension IQDropDownTextField {

    @objc open var menuButton: UIButton {
        privateMenuButton
    }

    @objc open var showMenuButton: Bool {
        get {
            privateMenuButton.superview != nil
        }
        set {
            if newValue {
                datePicker.preferredDatePickerStyle = .inline
                dateTimePicker.preferredDatePickerStyle = .inline

                self.addSubview(privateMenuButton)
                NSLayoutConstraint.activate([
                    privateMenuButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                    privateMenuButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                    privateMenuButton.topAnchor.constraint(equalTo: topAnchor),
                    privateMenuButton.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
                reconfigureMenu()
            } else {
                datePicker.preferredDatePickerStyle = .wheels
                dateTimePicker.preferredDatePickerStyle = .wheels

                privateMenuButton.removeFromSuperview()
            }
        }
    }

    internal func initializeMenu() {
        privateMenuButton.setImage(UIImage(systemName: "chevron.up.chevron.down"), for: .normal)
        privateMenuButton.contentHorizontalAlignment = .trailing
        privateMenuButton.contentEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 5)
        privateMenuButton.translatesAutoresizingMaskIntoConstraints = false
        privateMenuButton.addTarget(self, action: #selector(menuActionTriggered), for: .menuActionTriggered)
        privateMenuButton.showsMenuAsPrimaryAction = true
    }

    internal func reconfigureMenu() {

        switch dropDownMode {

        case .list, .multiList:
            let deferredMenuElement = UIDeferredMenuElement.uncached({ completion in

                var actions: [UIMenuElement] = []
                if self.multiItemList.count <= 1 {
                    let selectedItem = self.selectedItem
                    actions = self.itemList.map { item in
                        return UIAction(title: item, image: nil,
                                        state: item == selectedItem ? .on : .off) { (_) in
                            self.privateSetSelectedItems(selectedItems: [item], animated: true,
                                                         shouldNotifyDelegate: true)
                        }
                    }
                } else {
                    var selectedItems = self.selectedItems
                    for (index, itemList) in self.multiItemList.enumerated() {
                        let selectedItem = selectedItems[index]
                        let childrens: [UIMenuElement] = itemList.map { item in
                            return UIAction(title: item, image: nil,
                                            state: item == selectedItem ? .on : .off) { (_) in
                                selectedItems[index] = item
                                self.privateSetSelectedItems(selectedItems: selectedItems, animated: true,
                                                             shouldNotifyDelegate: true)
                            }
                        }

                        let title: String
                        if index < self.optionalItemTexts.count {
                            title = self.optionalItemTexts[index] ?? self.optionalItemText ?? ""
                        } else {
                            title = self.optionalItemText ?? ""
                        }
                        let subMenu = UIMenu(title: title, children: childrens)

                        actions.append(subMenu)
                    }
                }
                completion(actions)
            })
            let deferredMenus = UIMenu(title: self.placeholder ?? "", children: [deferredMenuElement])
            privateMenuButton.menu = deferredMenus
            privateMenuButton.isHidden = false
        case .time, .date, .dateTime:
            privateMenuButton.isHidden = false
            privateMenuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
            privateMenuButton.menu = nil
        case .textField:
            privateMenuButton.isHidden = true
            privateMenuButton.menu = nil
        }
    }

    @objc private func menuActionTriggered() {
        containerViewController?.view.endEditing(true)
    }

    @objc private func menuButtonTapped() {
        guard let containerViewController = containerViewController else {
            return
        }
        let popoverViewController = UIViewController()
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.popoverPresentationController?.sourceView = privateMenuButton
        popoverViewController.popoverPresentationController?.sourceRect = privateMenuButton.bounds
        popoverViewController.popoverPresentationController?.delegate = self
        switch dropDownMode {
        case .list, .multiList, .textField:
            break
        case .time:
            popoverViewController.view = timePicker
            timePicker.sizeToFit()
            popoverViewController.preferredContentSize = timePicker.bounds.size
            containerViewController.present(popoverViewController, animated: true, completion: nil)
        case .date:
            popoverViewController.view = datePicker
            datePicker.sizeToFit()
            popoverViewController.preferredContentSize = datePicker.bounds.size
            containerViewController.present(popoverViewController, animated: true, completion: nil)
        case .dateTime:
            popoverViewController.view = dateTimePicker
            dateTimePicker.sizeToFit()
            popoverViewController.preferredContentSize = dateTimePicker.bounds.size
            containerViewController.present(popoverViewController, animated: true, completion: nil)
        }
    }
}

@MainActor
extension IQDropDownTextField {
    private var containerViewController: UIViewController? {
        var next = self.next

        repeat {
            if let next = next as? UIViewController {
                return next
            } else {
                next = next?.next
            }
        } while next != nil
        return nil
    }
}

@MainActor
extension IQDropDownTextField: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force popover style
        return .none
    }

    public func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        containerViewController?.view.endEditing(true)
    }
}
