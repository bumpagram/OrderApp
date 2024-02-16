//  OrderConfirmationViewController.swift
//  OrderApp
//  Created by .b[u]mpagram on 15/2/24.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
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
        confirmationLabel.text = "Thank you for your order! Approximately wait time is \(preparationTime) minutes."
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
