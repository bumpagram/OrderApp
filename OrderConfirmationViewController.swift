//  OrderConfirmationViewController.swift
//  OrderApp
//  Created by .b[u]mpagram on 15/2/24.
//

import UIKit

class OrderConfirmationViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    // UIAdaptivePresentationControllerDelegate протокол содержит методы, которые определяют как реагировать на закрытие окна свайпом
    
    typealias MinutesToPrepare = Int
    var preparationTime: MinutesToPrepare
    
    init?(coder: NSCoder, preparationTime: MinutesToPrepare) {
        // custom initializer on OrderConfirmationViewController that accepts the preparation time parameter and sets it on a new property”
        self.preparationTime = preparationTime
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet var confirmationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        confirmationLabel.text = "Thank you for your order! Approximately wait time is \(preparationTime) minutes."
    }
    
    
    // IBAction для кнопки отсутствует, тк в Storyboad Main сделал ctrl-drag -> exit на unwindToOrderList
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        // не будет вызван, если мы просто закроем окно свайпом вниз. Вызов данного метода происходит только в том случае, когда свойство isModalInPresentation класса UIViewController имеет значение true. Данное свойство указывает, применяет ли вью контроллер модальное поведение или нет. Если да, то закрыть окно свайпом вниз не получится
        // пробовал добавлять сюда код, почему то не исполняется, но само наличие метода работает - модальное окно не смахнуть вниз
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
