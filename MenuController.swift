//  MenuController.swift
//  OrderApp
//  Created by .b[u]mpagram on 10/2/24.

import Foundation

class MenuController {
    
    typealias MinutesToPrepare = Int
    
    static let shared = MenuController() // синглтон, единая точка входа. Положили класс сам в себя, инициализировали. Можно вызыать через MenuController.shared для сетевых запросов
    
    let baseURL = URL(string: "http://localhost:8080/")!
    
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
    
    
    func sumbitOrder(for menuIDs: [Int] ) async throws -> MinutesToPrepare {   // POST to /order
        
        let orderURL = baseURL.appendingPathComponent("order")
        // “However, the POST request for placing the order is different. First, you'll create a URLRequest to specify the details of the request rather than directly submitting the request with a URL. You'll need to modify the request's type, which defaults to GET, to a POST. Then, you'll tell the server you'll be sending JSON data.
        
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // “Next, you'll store the array of menu IDs in JSON under the key menuIds. To do this, create a dictionary of type [String: [Int]], a type that can be converted to or from JSON by an instance of JSONEncoder”
        let menuIDsDictionary = ["menuIDs" : menuIDs ]
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
    
} // MenuControler end



enum MenuControllerError: Error, LocalizedError {
    case categoriesNotFound
    case menuItemsNotFound
    case orderRequestFailed
}
