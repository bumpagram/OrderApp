//  MenuController.swift
//  OrderApp
//  Created by .b[u]mpagram on 10/2/24.

import Foundation
import UIKit

class MenuController {
    
    typealias MinutesToPrepare = Int
    let baseURL = URL(string: "http://localhost:8080/")!

    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
            // “When should you send this notification? The easiest solution is to observe changes to the order property. That way, whenever it's modified, all observers will have a chance to react. Sending a notification is as simple as specifying a name and an object. The object parameter is a way for observers to filter notifications if they arrive in different contexts or from different sources. But since this is a simple implementation, you can set the object parameter to nil.
            userActivity.order = order
        }
    }

    var userActivity = NSUserActivity(activityType: "com.example.OrderApp.order")  // “The activity type parameter is a String in a reverse-DNS format that should be unique to your identity and app. Typically this will include your company's website domain, the app name, and any further information to distinguish what the activity is for.
 
    static let shared = MenuController() // синглтон, единая точка входа. Положили класс сам в себя, инициализировали. Можно вызыать через MenuController.shared для сетевых запросов
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")  // NotificationCenter that defines the name of the order-change notification
    
    
    func fetchCategories() async throws -> [String] { // get
        let categoriesURL = baseURL.appendingPathComponent("categories")
        let (data, response) = try await URLSession.shared.data(from: categoriesURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MenuControllerError.categoriesNotFound
        }
        // “The /categories endpoint will need to be decoded into a CategoriesResponse object, and for that you'll need to create a JSONDecoder. If the data is successfully decoded, return the categories from the CategoriesResponse object.
        
        let jsondecoder = JSONDecoder()
        let categoriesResponse = try jsondecoder.decode(CategoriesResponse.self, from: data)
        
        return categoriesResponse.categories
    }
    
    
    func fetchMenuItems(for inputcategory: String) async throws -> [MenuItem] { // GET from /menu
        
        let baseMenuURL = baseURL.appendingPathComponent("menu")
        // нужен дополнительный query paramenter
        var urlComponents = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = [ URLQueryItem(name: "category", value: inputcategory) ]
        let menuURL = urlComponents.url!
        
        let (data, response) = try await URLSession.shared.data(from: menuURL)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MenuControllerError.menuItemsNotFound
        }
        let jsondecoder = JSONDecoder()
        let menuResponse = try jsondecoder.decode(MenuResponse.self, from: data)
        
        return menuResponse.items
    }
    
    
    func sumbitOrder(for menuIds: [Int] ) async throws -> MinutesToPrepare {   // POST to /order
        
        let orderURL = baseURL.appendingPathComponent("order")
        // “However, the POST request for placing the order is different. First, you'll create a URLRequest to specify the details of the request rather than directly submitting the request with a URL. You'll need to modify the request's type, which defaults to GET, to a POST. Then, you'll tell the server you'll be sending JSON data.
        
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // “Next, you'll store the array of menu IDs in JSON under the key menuIds. To do this, create a dictionary of type [String: [Int]], a type that can be converted to or from JSON by an instance of JSONEncoder”
        let menuIDsDictionary = ["menuIds" : menuIds ]
        let jsonencoder = JSONEncoder()
        let jsondata = try jsonencoder.encode(menuIDsDictionary)
        request.httpBody = jsondata
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MenuControllerError.orderRequestFailed
        }
        let jsondecoder = JSONDecoder()
        let orderResponse = try jsondecoder.decode(OrderResponse.self, from: data)
        
        return orderResponse.preparaionTime
    }
    
    
    func fetchImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpresponse = response as? HTTPURLResponse, httpresponse.statusCode == 200 else {
            throw MenuControllerError.imageDataMissing
        }
        guard let image = UIImage(data: data) else {
            throw MenuControllerError.imageDataMissing
        }
        return image
    }
    
    func updateUserActivity(with controller: StateRestorationController) {
        switch controller {
        case .menu(category: let somecategory): userActivity.menuCategory = somecategory
        case .itemDetail(let someitem): userActivity.menuItem = someitem
        case .order : break
        case .categories : break
        }
        userActivity.controllerIdentifier = controller.identifier
    }
    
    
} // MenuControler end



enum MenuControllerError: Error, LocalizedError {
    case categoriesNotFound
    case menuItemsNotFound
    case orderRequestFailed
    case imageDataMissing
}
