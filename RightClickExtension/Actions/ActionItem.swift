//
//  ActionItem.swift
//  RightClickExtension
//
//  Created by Pho Hale on 1/27/21.
//  Copyright © 2021 Antti Tulisalo. All rights reserved.
//

import Foundation
import FinderSync


// MARK: -
// MARK: - struct ActionItem
// Description: Represents an action
struct ActionItem {
	var title: String
	var action: Selector?

	var allowedMenuKinds: Set<FIMenuKind>

	var asMenuItem: NSMenuItem {
		return NSMenuItem(title: self.title, action: self.action, keyEquivalent: "")
	}

}

