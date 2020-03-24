//
//  KeyboardObserver.swift
//  KeyboardObserver
//
//  Created by Maxim Vialyx on 3/24/20.
//  Copyright © 2020 Vialyx. All rights reserved.
//

import UIKit

class KeyboardObserver {
    
    /*
     KeyboardState provides two states
     - hide when kyboard is hidden
     - show(let kyboardHeight) when keyboard is shown
     */
    enum KeyboardState {
        case hide, show(CGRect)
        
        var height: CGFloat {
            switch self {
            case .hide:
                return 0
            case .show(let rect):
                return rect.height
            }
        }
        
    }
    
    /*
     `state` store keyboard state to compure dif
     */
    var state: KeyboardState = .hide {
        didSet {
            switch state {
            case .hide:
                rect = .zero
            case .show(let frame):
                rect = frame
            }
        }
    }
    
    typealias KeyboardHandler = ((KeyboardState) -> Void)
    
    /*
     `handler` provides updates out of self class intance
     */
    var handler: KeyboardHandler?
    
    private var rect = CGRect.zero
    private let center = NotificationCenter.default
    
    /*
     Create default initializer with configuration
     */
    init(handler: KeyboardHandler? = nil) {
        self.handler = handler
        configure()
    }
    
    private func configure() {
        /*
         Subscribe for `UIResponder.keyboardWillShowNotification` notification to get visible frame of keyboard
         */
        center.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) {
            [weak self] (n) in
            guard let keyboardFrame = n.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            let state: KeyboardState = .show(keyboardFrame.cgRectValue)
            self?.state = state
            self?.handler?(state)
        }
        /*
        Subscribe for `UIResponder.keyboardWillHideNotification` notification to get updates when keyboard is hidden
        */
        center.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) {
            [weak self] (_) in
            let state: KeyboardState = .hide
            self?.state = state
            self?.handler?(state)
        }
    }
    
}
