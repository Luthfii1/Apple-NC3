//
//  DaysEnum.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 15/07/24.
//

import Foundation

enum DAYS: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }
    case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
