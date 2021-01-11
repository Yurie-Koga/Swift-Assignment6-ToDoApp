//
//  GroupedSection.swift
//  Swift-Assignment6-ToDoApp
//
//  Created by Uji Saori on 2021-01-10.
//

import Foundation

struct GroupedSection<SectionItem : Hashable, RowItem> {

    var sectionItem : SectionItem
    var rows : [RowItem]

    static func group(rows : [RowItem], by criteria : (RowItem) -> SectionItem) -> [GroupedSection<SectionItem, RowItem>] {
        // group rows by sectionItem
        let groups = Dictionary(grouping: rows, by: criteria)
        return groups.map(GroupedSection.init(sectionItem:rows:))
    }

}
