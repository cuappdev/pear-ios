//
//  EditSection.swift
//  Pear
//
//  Created by Lucy Xu on 6/8/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

enum EditSectionType: CaseIterable {
    case yours
    case more
}

/// Section represents each section of the view
class EditSection<T: Topic> {
    let type: EditSectionType
    var items: [T]

    // filteredItems is always the result of items sorted by matching its name with filteredString
    var filteredItems: [T] { get { filteredItemsInternal } }
    private var filteredItemsInternal: [T]
    var filterString: String?

    // How section sorts its content
    private let sortStrategy: ((T, T) -> Bool) = { $0.name < $1.name }

    init(type: EditSectionType, items: [T]) {
        self.type = type
        self.items = items.sorted(by: sortStrategy)
        self.filteredItemsInternal = items
    }

    func addItem(_ item: T) {
        items.append(item)
        items.sort(by: sortStrategy)
        refilter()
    }

    func removeItem(named name: String) -> T? {
        if let loc = items.firstIndex(where: { $0.name == name }) {
            let removed = items.remove(at: loc)
            items.sort(by: sortStrategy)
            refilter()
            return removed
        }
        return nil
    }

    func refilter() {
        if let str = filterString {
            filteredItemsInternal = items.filter { $0.name.localizedCaseInsensitiveContains(str) }
        } else {
            filteredItemsInternal = items
        }
    }

}
