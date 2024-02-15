//  OrderTableViewController.swift
//  OrderApp
//  Created by .b[u]mpagram on 9/2/24.

import UIKit

class OrderTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdatedNotification, object: nil)
        //  “Now you'll create an observer for your new notification in OrderTableViewController. Add the notification observation code to your viewDidLoad() method. When the order is updated, you'll reload the table view, so the observer will be the view controller's tableView property. Specify the reloadData() method of UITableView as the selector, and set the last argument to nil again.
    }
    
    
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
