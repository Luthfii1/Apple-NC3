//
//  DaysEnum.swift
//  NC2
//
//  Created by Felicia Himawan on 15/07/24.
//

//import Foundation
//
//enum DAYS: String, Codable, CaseIterable {
//    case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
//}

import Foundation

enum DAYS: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }
    case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
}
