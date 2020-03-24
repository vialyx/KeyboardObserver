//
//  ViewController.swift
//  KeyboardObserver
//
//  Created by Maxim Vialyx on 3/24/20.
//  Copyright © 2020 Vialyx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /*
     Current active (firstRespounder) textField
     */
    private weak var activeTextField: UITextField?
    /*
     local intance of KeyboardObserver
     */
    private let keyboard = KeyboardObserver()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Setup `handler` into KeyboardObserver instance
         */
        keyboard.handler = {
            [unowned self] state in
            switch state {
            case .show(let rect):
                /*
                 Check if we already have an reference to textField which is editing
                 */
                guard let `activeTextField` = self.activeTextField else {
                    return
                }
                /*
                 Compute what dif between activeTextField.frame.maxY and keyboard.frame
                 */
                let y = self.view.bounds.height
                    - rect.height
                    - self.view.convert(activeTextField.frame, to: self.view).maxY
                if y > 0 {
                    return
                }
                /*
                 Move view to top on vertical dif
                 */
                self.view.transform = CGAffineTransform.identity.translatedBy(x: 0, y: y)
            default:
                /*
                 Clear view transform
                 */
                self.view.transform = .identity
            }
        }
        
        /*
         Hide keyboard by tap on view
         */
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }


}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        /*
         Store textField reference to get an access later when keyboard is shown
         */
        activeTextField = textField
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /*
         Clear activeTextField as it no need after end editing. Keyboard already hidden
         */
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /*
         Hide keyboard by tap to return button on keyboard
         */
        view.endEditing(true)
        return true
    }
    
}
