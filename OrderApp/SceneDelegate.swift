//  SceneDelegate.swift
//  OrderApp
//  Created by .b[u]mpagram on 9/2/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var orderTabBarItem : UITabBarItem!  // будет нужен для Badge с цифрой в заказе
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrderBadge), name: MenuController.orderUpdatedNotification, object: nil)    // to set the property when the app first launches and observe the orderUpdateNotification
        orderTabBarItem = (window?.rootViewController as? UITabBarController)?.viewControllers?[1].tabBarItem   // опциональная цепочка.  даункаст, потом свойство-массив всех таббар контроллеров по горизонтали, и его бейджик item.
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
    @objc func updateOrderBadge() {
        // “To use updateOrderBadge() as a selector in your call to addObserver(_:selector:name:object:), you'll need to annotate the function with @objc.
        switch MenuController.shared.order.userSelected.count {
        case 0 : orderTabBarItem.badgeValue = nil
        case let others: orderTabBarItem.badgeValue = String(others)
        }
    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        // “is called when your scene enters the background; it is invoked by UIKit, which is requesting an NSUserActivity to pass back to you when your scene reconnects. ”
        // “Note: If you do not first go to the Home screen, the stateRestorationActivity(for:) method will not be called, and you won't see proper state restoration. Keep this in mind while debugging your app's state restoration feature. Also, if your app crashes, the state restoration information may be thrown away; this helps ensure that the app does not continue crashing on re-launch due to a bad state.”
        
        return MenuController.shared.userActivity
    }
    
    func scene(_ scene: UIScene, restoreInteractionStateWith stateRestorationActivity: NSUserActivity) {
        // “is called after your scene connects and the storyboard and views are loaded, but before the first transition to the foreground. ”
        // “check the provided NSUserActivity for an order. If an order is present, assign it to the MenuController's shared instance.
    
        if let restoredOrder = stateRestorationActivity.order {
            MenuController.shared.order = restoredOrder
        }
    }
    

}

