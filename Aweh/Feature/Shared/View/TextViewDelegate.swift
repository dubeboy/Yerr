//
//  TextViewDelegate.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/20.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

protocol TextViewTextUpdatedDelegate {
    var placeHolderText: String { get }
    var sendButton: UIButton { get }
    func numberOfCharectorsDidChange(current length: Int)
}

class TextViewDelegateImplementation: NSObject, UITextViewDelegate {
    
    var delegate: TextViewTextUpdatedDelegate
    
    init(delegate: TextViewTextUpdatedDelegate) {
        self.delegate = delegate
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == delegate.placeHolderText {
            moveCursorToFront(textView)
        }
        return true
    }
    
    // TODO: - 1 fix the fact that the text is highlightable replace with a UIlabel
    // listen to end editing to get the final text and send to presenter
    // https://grokswift.com/uitextview-placeholder/
    // https://tij.me/blog/adding-placeholders-to-uitextviews-in-swift/
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 {
            if newLength > Const.maximumTextLength {
                return false
            } else if textView.text == delegate.placeHolderText {
                if text.count == 0 {
                    delegate.sendButton.isEnabled = false
                    return false
                }
                applyNonPlaceholderStyle(textView)
                textView.text = ""
            }
            delegate.sendButton.isEnabled = true
            updateCharactorCount(length: newLength)
        } else {
            applyPlaceholderStyle(textView, placeholderText: delegate.placeHolderText)
            moveCursorToFront(textView)
            delegate.sendButton.isEnabled = false
            updateCharactorCount(length: 0)
            return false
        }
        
        delegate.sendButton.isEnabled = true
        return true
    }
    
    private func applyPlaceholderStyle(_ textView: UITextView, placeholderText: String) {
        textView.text = placeholderText
        textView.textColor = Const.Color.labelColor
    }
    
    private func applyNonPlaceholderStyle(_ textView: UITextView) {
        textView.textColor = UIColor(named: "textViewInputTextColor")
        textView.isSelectable = true
    }
    
    
    private func moveCursorToFront(_ textView: UITextView) {
        textView.selectedRange = NSRange(location: 0, length: 0)
        
    }
    
    private func updateCharactorCount(length: Int) {
        delegate.numberOfCharectorsDidChange(current: length)
    }
}
