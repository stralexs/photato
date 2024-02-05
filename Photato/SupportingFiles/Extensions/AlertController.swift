//
//  AlertController.swift
//  Photato
//
//  Created by Alexander Sivko on 2.02.24.
//

import UIKit

struct CustomAlertAction: Equatable {
    let title: String
    let style: UIAlertAction.Style
    
    static let okAction: CustomAlertAction = .init(title: "Ok")
    static let cancelAction: CustomAlertAction = .init(title: "Cancel", style: .cancel)
    static let doneAction: CustomAlertAction = .init(title: "Done")
    
    init(title: String, style: UIAlertAction.Style = .default) {
        self.title = title
        self.style = style
    }
}

extension UIViewController {
    func presentBasicAlert(title: String?, message: String?, alertStyle: UIAlertController.Style = .alert, actions: [CustomAlertAction], completionHandler: ((_ action: CustomAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                guard let completionHandler = completionHandler else { return }
                completionHandler(action)
            }
            alertController.addAction(alertAction)
        }
        
        self.present(alertController, animated: true)
    }
}
