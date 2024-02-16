//  OrderTableViewController.swift
//  OrderApp
//  Created by .b[u]mpagram on 9/2/24.

import UIKit

class OrderTableViewController: UITableViewController {
    //  свойство инициализировано нулевое, но получим ответ от сервера и обновим значение. Затем передадим в инициализатор OrderConfirmation VC
    var preparationTime = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdatedNotification, object: nil)
        //  “Now you'll create an observer for your new notification in OrderTableViewController. Add the notification observation code to your viewDidLoad() method. When the order is updated, you'll reload the table view, so the observer will be the view controller's tableView property. Specify the reloadData() method of UITableView as the selector, and set the last argument to nil again.
    }
    
    
    @IBSegueAction func confirmOrder(_ coder: NSCoder, sender: Any?) -> OrderConfirmationViewController? {  // вызываем вручную по идентификатору "confirmOrder"
        return OrderConfirmationViewController(coder: coder, preparationTime: preparationTime)
    }
    
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        // “First, you'll need to define a method in OrderTableViewController that will be called when the unwind is triggered.” “Control-drag from the Dismiss button to the Exit button at the top of OrderConfirmationViewController and select the name of the method you just created. This will create an unwind segue. Using the Attributes inspector, give the segue an identifier of “dismissConfirmation.”
        
        
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        // “The action will alert the user that their order will be submitted if they continue. 
        let orderTotal = MenuController.shared.order.userSelected.reduce(0.0) { partialResult, menuitem in
           partialResult + menuitem.price // считаем сумму цен элементов из корзины
       }
        let formattedTotal = orderTotal.formatted(.currency(code: "usd"))
        let alert = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of \(formattedTotal)", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            self.uploadOrder()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alert, animated: true)
    }
    
    
    func uploadOrder() { // сетевой запрос
       let selectedMenuIDs = MenuController.shared.order.userSelected.map { menuitem in
            menuitem.id
        }
        Task {
            do {
                let minutesToPrepare = try await MenuController.shared.sumbitOrder(for: selectedMenuIDs)
                preparationTime = minutesToPrepare // полученный ответ от сервера назначаем в проперти
                performSegue(withIdentifier: "confirmOrder", sender: nil)  // триггерит IBSegueAction func confirmOrder
                
            } catch {
                displayError(error, with: "Order Submission Failed")
                print(error.localizedDescription)
            }
        }
    }
    
    
    func displayError(_ error: Error, with title: String) {
        guard let _ = viewIfLoaded?.window else { return }
        
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    /*
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // determines whether the segue with the specified identifier should be performed
        // true if the segue should be performed or false if it should be ignored.    хз нужно ли переопределять, но вызов SegueAction будет через него
    }
    */
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MenuController.shared.order.userSelected.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        // Configure the cell...
        var content = cell.defaultContentConfiguration()
        let item = MenuController.shared.order.userSelected[indexPath.row]
        content.text = item.name
        content.secondaryText = item.price.formatted(.currency(code: "usd"))
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Override to support conditional editing of the table view.  Return false if you do not want the specified item to be editable.
        // “To add swipe-to-delete functionality to your order table view controller's cells, you'll need to override the tableView(_:canEditRowAt:) method. You could use the indexPath property to choose which cells are editable-but since all cells in this app can be selected, simply return true.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Override to support editing the table view.
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            MenuController.shared.order.userSelected.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
