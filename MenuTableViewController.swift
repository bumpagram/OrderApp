//  MenuTableViewController.swift
//  OrderApp
//  Created by .b[u]mpagram on 9/2/24.

import UIKit

class MenuTableViewController: UITableViewController {
    
    let category: String
    var menuItems = [MenuItem]()  // вернется ответ от сервера и назначим сюда в проперти
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]  // “ keep track of any image loading task for an IndexPath and cancel that Task if the cell is scrolled off the screen.
    
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
            do {
                let fetchedMenuItems = try await MenuController.shared.fetchMenuItems(for: category)
                updateUI(with: fetchedMenuItems)
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
    
    func configure(_ cell: UITableViewCell, forItemAt indexpath: IndexPath) {
        guard let cell = cell as? MenuItemCell else { return }
        let item = menuItems[indexpath.row]
        cell.itemName = item.name
        cell.price = item.price
        cell.image = nil
        
        imageLoadTasks[indexpath] = Task {
            // “While the image is nice to have, it's not worth alerting the user if it fails to load, so you'll ignore any errors that are thrown by using an optional try statement-try?-rather than a do/catch statement. In a real-world situation, you might choose to log the error somewhere. “But wait: For table view cells, you'll need to make an additional check. Recall that, in longer lists of data, cells will be recycled and reused as you scroll up and down the table. Since you don't want to put the wrong image into a recycled cell, check the index path where the cell is now located. If it's changed, you can skip setting the image view. The final step in the process is to update the cell's image property, which will cause the cell to update its layout to accommodate the new image.
         
            if let fetchedImage = try? await MenuController.shared.fetchImage(from: item.imageURL) {
                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath == indexpath {
                    cell.image = fetchedImage  // изобржения большие, ресайзят таблицу, верстка плывет. чтобы такого не было не забываем ставить в Storyboard - tableView- max how height и estimatedRowHeight
                    }
                }
            imageLoadTasks[indexpath] = nil  // обнуляем реестр отрабатыаюших сейчас тасков по загрузке картинок
            }
        
    }
    
    @IBSegueAction func showItemDetail(_ coder: NSCoder, sender: Any?) -> ItemDetailViewController? {
        
        guard let cell = sender as? UITableViewCell, let indexpath = tableView.indexPath(for: cell) else { return nil }
        let tappedElement = menuItems[indexpath.row]
        return ItemDetailViewController(coder: coder, menuItem: tappedElement)  // использую свой кастомный инициализатор, чтобы создать новый контроллер с уже заданным проперти и данными в нем
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
        configure(cell, forItemAt: indexPath)
            return cell
        }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Delegate методы:
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // cancel the image fetching task if its no longer needed
        imageLoadTasks[indexPath]?.cancel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // “The entire view can also disappear before all the tasks finish loading the images. You should cancel any outstanding image loading tasks in the viewDidDisappear(:) method”
        super.viewDidDisappear(true)
        imageLoadTasks.forEach { key, value in
            value.cancel()   // cancel image fetching tasks that are no longer needed
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // “for preserving view controller state is to call this method within each view controller at the appropriate time. The best time is when viewDidAppear(_:) is called. Add the following methods to each corresponding controller.
        super.viewDidAppear(animated)
        MenuController.shared.updateUserActivity(with: .menu(category: category))
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
