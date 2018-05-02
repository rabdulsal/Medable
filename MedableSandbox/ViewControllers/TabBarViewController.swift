/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import ResearchKit
import CareKit

class TabBarViewController: UITabBarController {
    
    enum TabTitles : String {
        case activities = "Activities"
        case symptomTracker = "Symptom Tracker"
        case insights = "Insights"
        case connect = "Connect"
    }
    
    fileprivate let carePlanStoreManager = CarePlanStoreManager.sharedManager
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let careCardStack = createCareCardStack()
        let symptomTrackerStack = createSymptomTrackerStack()
        let insightsStack = createInsightsStack()
        let connectStack = createConnectStack()

        self.viewControllers = [careCardStack,
                                symptomTrackerStack,
                                insightsStack,
                                connectStack]

        tabBar.tintColor = UIColor.darkOrange()
        tabBar.barTintColor = UIColor.lightGreen()
    }

    fileprivate func createCareCardStack() -> UINavigationController {
        let title = TabTitles.activities.rawValue
        let viewController = OCKCareCardViewController(carePlanStore: carePlanStoreManager.store)
        viewController.customGlyphImageName = "heart"
//        viewController.smallMaskImage = UIImage(named: "small-heart")
        viewController.glyphTintColor = UIColor.darkGreen()

        viewController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: "carecard"), selectedImage: UIImage(named: "carecard-filled"))
        viewController.title = title
        return UINavigationController(rootViewController: viewController)
    }

    fileprivate func createSymptomTrackerStack() -> UINavigationController {
        let title = TabTitles.symptomTracker.rawValue
        let viewController = UIViewController()

        viewController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: "symptoms"), selectedImage: UIImage.init(named: "symptoms-filled"))
        viewController.title = title

        return UINavigationController(rootViewController: viewController)
    }

    fileprivate func createInsightsStack() -> UINavigationController {
        let title = TabTitles.insights.rawValue
        let viewController = UIViewController()

        viewController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: "insights"), selectedImage: UIImage.init(named: "insights-filled"))
        viewController.title = title
        return UINavigationController(rootViewController: viewController)
    }

    fileprivate func createConnectStack() -> UINavigationController {
        let title = TabTitles.connect.rawValue
        let viewController = UIViewController()

        viewController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: "connect"), selectedImage: UIImage.init(named: "connect-filled"))
        viewController.title = title
        return UINavigationController(rootViewController: viewController)
    }
}
