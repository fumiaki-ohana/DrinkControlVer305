//
//  EurekaCustomClass.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2021/05/24.
//  Copyright © 2021 OHANA Inc. All rights reserved.
//
/*
import Foundation
import UIKit
import Eureka

public final class PickerInlineRow<T> : _PickerInlineRow<T>, RowType, InlineRowType where T: Equatable {

    required public init(tag: String?) {
        super.init(tag: tag)
        onExpandInlineRow { cell, row, _ in
            let color = cell.detailTextLabel?.textColor
            row.onCollapseInlineRow { cell, _, _ in
                cell.detailTextLabel?.textColor = color
            }
            cell.detailTextLabel?.textColor = cell.tintColor
        }
    }

    public override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            toggleInlineRow()
        }
    }

    public func setupInlineRow(_ inlineRow: InlineRow) {
        inlineRow.options = self.options
        inlineRow.displayValueFor = self.displayValueFor
        inlineRow.cell.height = { UITableView.automaticDimension }
    }
}
*/
