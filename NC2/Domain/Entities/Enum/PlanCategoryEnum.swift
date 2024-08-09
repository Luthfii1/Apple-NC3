//
//  PlanCategoryEnum.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 15/07/24.
//

import Foundation

enum PLANCATEGORY: String, Codable, CaseIterable {
    case Event
    case Repeat
    
    func localizedString() -> String {
           return NSLocalizedString(self.rawValue, comment: "")
       }
}

