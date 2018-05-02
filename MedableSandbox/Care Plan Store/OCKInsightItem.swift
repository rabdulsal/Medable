//
//  OCKInsightItem.swift
//  MedableSandbox
//
//  Created by Rashad Abdul-Salam on 4/30/18.
//  Copyright © 2018 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import CareKit

extension OCKInsightItem {
    static func emptyInsightsMessage() -> OCKInsightItem {
        let text = "You haven't entered any data, or reports are in process. (Or you're a zombie?)"
        return OCKMessageItem(
            title: "No Insights",
            text: text,
            tintColor: UIColor.darkOrange(), messageType: .tip)
    }
}
