//
//  ActivityService.swift
//  MedableSandbox
//
//  Created by Rashad Abdul-Salam on 4/27/18.
//  Copyright © 2018 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import CareKit

enum ActivityIdentifier: String {
    case cardio = "Cardio"
    case limberUp = "Limber Up"
    case targetPractice = "Target Practice"
    case pulse
    case temperature
    case painMeds = "ibuprofenMedication"
}

struct IbuprofenActivity {
    
    let identifier = ActivityIdentifier.painMeds.rawValue
    let groupIdentifier = "Pain Medications"
    let title = "Ibuprofen"
    let text = "200mg"
    let tint = UIColor.blue
    let instructions = "Take with food"
    let imageURL = NSURL.fileURL(withPath: "ibuprofen.png")
}

class ActivityService : NSObject {
    
    let carePlanStore: OCKCarePlanStore
    
    init(carePlanStore: OCKCarePlanStore) {
        self.carePlanStore = carePlanStore
        super.init()
        
        self.addIbuprofenActivity()
        self.makeActivities()
        self.makeAssessmentActivities()
    }
    
    class func dailyScheduleRepeating(occurencesPerDay: UInt) -> OCKCareSchedule {
        return OCKCareSchedule.dailySchedule(withStartDate: DateComponents.firstDateOfCurrentWeek,
                                             occurrencesPerDay: occurencesPerDay)
    }
    
    func addIbuprofenActivity() {
        let startDate = DateComponents(year: 2018, month: 04, day: 22)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate, occurrencesOnEachDay: [0, 4, 0, 2, 0, 4, 0])
        
        let ibuprofenActivity = IbuprofenActivity()
        let carePlanActivity = OCKCarePlanActivity.intervention(
            withIdentifier: ibuprofenActivity.identifier,
            groupIdentifier: ibuprofenActivity.groupIdentifier,
            title: ibuprofenActivity.title,
            text: ibuprofenActivity.text,
            tintColor: ibuprofenActivity.tint,
            instructions: ibuprofenActivity.instructions,
            imageURL: ibuprofenActivity.imageURL,
            schedule: schedule,
            userInfo: nil,
            optional: false)
        
        self.carePlanStore.add(carePlanActivity, completion: self.handleError(success:error:))
        
    }
    
    func makeActivities() {
        let cardioActivity = OCKCarePlanActivity(
            identifier: ActivityIdentifier.cardio.rawValue,
            groupIdentifier: nil,
            type: .intervention,
            title: "Cardio",
            text: "60 Minutes",
            tintColor: UIColor.darkOrange(),
            instructions: "Jog at a moderate pace for an hour. If there isn't an actual one, imagine a horde of zombies behind you.",
            imageURL: nil,
            schedule:ActivityService.dailyScheduleRepeating(occurencesPerDay: 2),
            resultResettable: true,
            userInfo: nil)
        
        self.carePlanStore.add(cardioActivity, completion: self.handleError(success:error:))
        
        let limberUpActivity = OCKCarePlanActivity(
            identifier: ActivityIdentifier.limberUp.rawValue,
            groupIdentifier: nil,
            type: .intervention,
            title: "Limber Up",
            text: "Stretch Regularly",
            tintColor: UIColor.darkOrange(),
            instructions: "Stretch and warm up muscles in your arms, legs and back before any expected burst of activity. This is especially important if, for example, you're heading down a hill to inspect a Hostess truck.",
            imageURL: nil,
            schedule: ActivityService.dailyScheduleRepeating(occurencesPerDay: 6),
            resultResettable: true,
            userInfo: nil)
        
        self.carePlanStore.add(limberUpActivity, completion: self.handleError(success:error:))
        
        let targetPracticeActivity = OCKCarePlanActivity(
            identifier: ActivityIdentifier.targetPractice.rawValue,
            groupIdentifier: nil,
            type: .intervention,
            title: "Target Practice",
            text: nil,
            tintColor: UIColor.darkOrange(),
            instructions: "Gather some objects that frustrated you before the apocalypse, like printers and construction barriers. Keep your eyes sharp and your arm steady, and blow as many holes as you can in them for at least five minutes.",
            imageURL: nil,
            schedule: ActivityService.dailyScheduleRepeating(occurencesPerDay: 2),
            resultResettable: true,
            userInfo: nil)
        
        self.carePlanStore.add(targetPracticeActivity, completion: self.handleError(success:error:))
    }
    
    func makeAssessmentActivities() {
        let pulseActivity = OCKCarePlanActivity.assessment(
            withIdentifier: ActivityIdentifier.pulse.rawValue,
            groupIdentifier: nil,
            title: ActivityIdentifier.pulse.rawValue,
            text: "Do you have one?",
            tintColor: UIColor.darkGreen(),
            resultResettable: true,
            schedule: ActivityService.dailyScheduleRepeating(occurencesPerDay: 1),
            userInfo: ["ORKTask": AssessmentTaskFactory.makePulseAssessmentTask()],
            optional: true)
        
        
        let temperatureActivity = OCKCarePlanActivity
            .assessment(withIdentifier: ActivityIdentifier.temperature.rawValue,
                        groupIdentifier: nil,
                        title: "Temperature",
                        text: "Oral",
                        tintColor: UIColor.darkYellow(),
                        resultResettable: true,
                        schedule: ActivityService.dailyScheduleRepeating(occurencesPerDay: 1),
                        userInfo: ["ORKTask": AssessmentTaskFactory.makeTemperatureAssessmentTask()],
                        optional: true)
        
        self.carePlanStore.add(pulseActivity, completion: self.handleError(success:error:))
        self.carePlanStore.add(temperatureActivity, completion: self.handleError(success:error:))
    }
    
}

private extension ActivityService {
    
    func handleError(success: Bool, error: Error?) {
        if let e = error {
            print(e.localizedDescription)
            return
        }
    }
}
