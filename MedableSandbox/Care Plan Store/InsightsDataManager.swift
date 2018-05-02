//
//  InsightsDataManager.swift
//  MedableSandbox
//
//  Created by Rashad Abdul-Salam on 4/30/18.
//  Copyright © 2018 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import CareKit

class InsightsDataManager {
    let store = CarePlanStoreManager.sharedManager.store
    var completionData = [(dateComponent: DateComponents, value: Double)]()
    let gatherDataGroup = DispatchGroup()
    
    
    func fetchDailyCompletion(startDate: DateComponents, endDate: DateComponents)  {
        // 1
        gatherDataGroup.enter()
        // 2
        store.dailyCompletionStatus(
        with: .intervention,
        startDate: startDate,
        endDate: endDate,
        // 3
        handler: { (dateComponents, completed, total) in
        let percentComplete = Double(completed) / Double(total)
        self.completionData.append((dateComponents, percentComplete))
        },
        // 4
        completion: { (success, error) in
        guard success else { fatalError(error!.localizedDescription) }
        self.gatherDataGroup.leave()
        })
    }
    
    func updateInsights(_ completion: ((Bool, [OCKInsightItem]?) -> Void)?) {
        guard let completion = completion else { return }
        
        // 1
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            // 2
            let startDateComponents = DateComponents.firstDateOfCurrentWeek
            let endDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: Date())
            
            //TODO: fetch assessment data
            self.fetchDailyCompletion(startDate: startDateComponents, endDate: endDateComponents)
            
            // 3
            self.gatherDataGroup.notify(queue: DispatchQueue.main, execute: {
                print("completion data: \(self.completionData)")
                completion(false, nil)
            })
        }
    }
}
