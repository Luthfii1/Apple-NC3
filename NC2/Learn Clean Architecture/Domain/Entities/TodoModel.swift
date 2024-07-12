//
//  TodoModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 09/07/24.
//

import Foundation
import SwiftData

@Model
class Todo: Identifiable, Equatable, Hashable {
    var id : UUID
    var title: String
    var completed: Bool
    
    init(id: UUID = UUID(), title: String = "", completed: Bool = false) {
        self.id = id
        self.title = title
        self.completed = completed
    }
    
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.completed == rhs.completed
    }
}
