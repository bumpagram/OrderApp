//  MenuTableViewController.swift
//  OrderApp
//  Created by .b[u]mpagram on 9/2/24.

import UIKit

class MenuTableViewController: UITableViewController {
    
    let category: String
    var menuItems = [MenuItem]()  // вернется ответ от сервера и назначим сюда в проперти
    let menuController = MenuController() // для сетевых запросов
    
    init?(coder: NSCoder, category: String) {
        self.category = category
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")  // требование компилятора
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.capitalized
        
        Task {
            print("start task")
            do {
                print("start do")
                let fetchedMenuItems = try await menuController.fetchMenuItems(for: category)     // НЕ РАБОТАЕТ
               // let fetchedcategoriesTest = try await menuController.fetchCategories()    // РАБОТАЕТ
                //updateUI(with: fetchedMenuItems)
                print("after FUNC")
            } catch {
                displayError(error, with: "Failed to fetch MenuItems")
                print(error.localizedDescription)
            }
        }
    } // viewDidLoad end
    
    
    func updateUI(with newdata: [MenuItem]) {
        menuItems = newdata
        tableView.reloadData()
    }
    
    func displayError(_ error: Error, with title: String) {
        guard let _ = viewIfLoaded?.window else { return }
        
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
         1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath)
        // Configure the cell...
        var content = cell.defaultContentConfiguration()
        let item = menuItems[indexPath.row]
        content.text = item.name
        content.secondaryText = "$ \(item.price)"
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
