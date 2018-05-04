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
    
    fileprivate let activityService: ActivityService
    fileprivate let carePlanStoreManager = CarePlanStoreManager.sharedManager
    fileprivate var symptomTrackerViewController: OCKSymptomTrackerViewController? = nil
    fileprivate var insightsViewController: OCKInsightsViewController? = nil
  
    required init?(coder aDecoder: NSCoder) {
        self.activityService = ActivityService(carePlanStore: carePlanStoreManager.store)
        super.init(coder: aDecoder)
        
        carePlanStoreManager.delegate = self
        carePlanStoreManager.updateInsights()
        
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
        let viewController = OCKSymptomTrackerViewController(carePlanStore: carePlanStoreManager.store)
//        viewController.progressRingTintColor = UIColor.darkGreen()
        symptomTrackerViewController = viewController

        viewController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: "symptoms"), selectedImage: UIImage.init(named: "symptoms-filled"))
        viewController.title = title
        viewController.delegate = self

        return UINavigationController(rootViewController: viewController)
    }

    fileprivate func createInsightsStack() -> UINavigationController {
        let title = TabTitles.insights.rawValue
        let viewController = OCKInsightsViewController(insightItems: [OCKInsightItem.emptyInsightsMessage()])
        insightsViewController = viewController
        insightsViewController = viewController

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

// MARK: - OCKSymptomTrackerViewControllerDelegate
extension TabBarViewController: OCKSymptomTrackerViewControllerDelegate {
    func symptomTrackerViewController(_ viewController: OCKSymptomTrackerViewController,
                                      didSelectRowWithAssessmentEvent assessmentEvent: OCKCarePlanEvent) {
        guard let userInfo = assessmentEvent.activity.userInfo,
            let task: ORKTask = userInfo["ORKTask"] as? ORKTask else { return }
        
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        taskViewController.delegate = self
        
        present(taskViewController, animated: true, completion: nil)
    }
}

// MARK: - ORKTaskViewControllerDelegate
extension TabBarViewController: ORKTaskViewControllerDelegate {
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith
        reason: ORKTaskViewControllerFinishReason, error: Error?) {
        // 1
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        // 2
        guard reason == .completed else { return }
        guard let symptomTrackerViewController = symptomTrackerViewController,
            let event = symptomTrackerViewController.lastSelectedAssessmentEvent else { return }
        
        let carePlanResult = carePlanStoreManager.buildCarePlanResultFrom(taskResult: taskViewController.result)
        carePlanStoreManager.store.update(event, with: carePlanResult, state: .completed) {
            success, _, error in
            if !success {
                print(error?.localizedDescription)
            }
        }
    }
}

// MARK: - CarePlanStoreManagerDelegate
extension TabBarViewController: CarePlanStoreManagerDelegate {
    func carePlanStore(_ store: OCKCarePlanStore, didUpdateInsights insights: [OCKInsightItem]) {
        insightsViewController?.items = insights
    }
}
