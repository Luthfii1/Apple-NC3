//
//  StateView.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 14/07/24.
//

import Foundation

struct StateView {
    var isLoading: Bool = false
    var showAlert: Bool = false
    var isCreateSheetPresented: Bool = false
    var isEditSheetPresented: Bool = false
    var isSheetPresented: Bool = false
    var showDiscardChangesDialog: Bool = false
    var showDeleteAlert: Bool = false
    var resetSwipeOffset: Bool = false
}
