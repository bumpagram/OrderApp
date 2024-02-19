//  ItemDetailViewController.swift
//  OrderApp
//  Created by .b[u]mpagram on 9/2/24.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var addToOrderButton: UIButton!
    
    var menuItem : MenuItem  // в это свойство пробросится элемент при переходе из MenuTVC по IBSegueAction
    
    init?(coder: NSCoder, menuItem: MenuItem) {
        self.menuItem = menuItem
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // “for preserving view controller state is to call this method within each view controller at the appropriate time. The best time is when viewDidAppear(_:) is called. Add the following methods to each corresponding controller.
        super.viewDidAppear(animated)
        MenuController.shared.updateUserActivity(with: .itemDetail(menuItem))
    }
    
    
    @IBAction func orderButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1) {
            // обратная связь для пользователя на CoreAnimation (to see it bounce a little)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        MenuController.shared.order.userSelected.append(menuItem)  // добавляем в корзину при нажатии кнопки, захват свойства
    }
    
    func updateUI() {
        nameLabel.text = menuItem.name
        priceLabel.text = menuItem.price.formatted(.currency(code: "usd"))
        detailLabel.text = menuItem.detailText
        Task {
            if let fetchedImage = try? await MenuController.shared.fetchImage(from: menuItem.imageURL) {
                imageView.image = fetchedImage
            }
        }
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
