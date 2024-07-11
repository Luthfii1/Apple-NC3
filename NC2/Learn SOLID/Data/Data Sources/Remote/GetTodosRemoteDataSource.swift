//
//  GetTodosRemoteDataSource.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 11/07/24.
//

import Foundation

class GetTodosRemoteDataSource: GetTodosRemoteProtocol {
    func getTodos() async throws -> [Todo] {
        return dummyRemoteTodos
    }
}
