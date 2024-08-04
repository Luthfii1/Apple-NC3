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

extension DAYS{
    var weekday: Int {
        switch self {
        case .Sunday: return 1
        case .Monday: return 2
        case .Tuesday: return 3
        case .Wednesday: return 4
        case .Thursday: return 5
        case .Friday: return 6
        case .Saturday: return 7
        }
    }
    
    static func from(weekday: Int) -> DAYS? {
        return DAYS.allCases.first { $0.weekday == weekday }
    }
}
