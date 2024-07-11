//
//  GetTodosRemoteProtocol.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 11/07/24.
//

import Foundation

protocol GetTodosRemoteProtocol {
    func getTodos() async throws -> [Todo]
}
