//
//  ActivityService.swift
//  MedableSandbox
//
//  Created by Rashad Abdul-Salam on 4/27/18.
//  Copyright © 2018 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import CareKit

struct IbuprofenActivity {
    
    let identifier = "ibuprofenMedication"
    let groupIdentifier = "painMedications"
    let title = "Ibuprofen"
    let text = "200mg"
    let tint = UIColor.blue
    let instructions = "Take with food"
    let imageURL = NSURL.fileURL(withPath: "ibuprofen.png")
}

class ActivityService : NSObject {
    let carePlanStoreManager = CarePlanStoreManager.sharedManager
    
    func addIbuprofenActivity() {
        let startDate = DateComponents(year: 2018, month: 04, day: 22)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate, occurrencesOnEachDay: [0, 4, 0, 2, 0, 4, 0])
        
        let ibuprofenActivity = IbuprofenActivity()
        let carePlanActivity = OCKCarePlanActivity.intervention(
            withIdentifier: ibuprofenActivity.identifier,
            groupIdentifier: ibuprofenActivity.groupIdentifier,
            title: ibuprofenActivity.title,
            text: ibuprofenActivity.title,
            tintColor: ibuprofenActivity.tint,
            instructions: ibuprofenActivity.instructions,
            imageURL: ibuprofenActivity.imageURL,
            schedule: schedule,
            userInfo: nil,
            optional: false)
        
        self.carePlanStoreManager.store.add(carePlanActivity) { (success, error) in
            // Error checking
        }
        
    }
}
