//
//  FIMenuKind+URL.swift
//  RightClickExtension
//
//  Created by Pho Hale on 1/28/21.
//  Copyright © 2021 Antti Tulisalo. All rights reserved.
//

import Foundation
import FinderSync


extension FIMenuKind {

	func getAssociatedUrls() -> [URL]? {
		switch self {
		case .toolbarItemMenu, .contextualMenuForContainer:

			guard let target = FIFinderSyncController.default().targetedURL() else {
				NSLog("getAssociatedUrls(): Failed to obtain selected URLs: %@")
				return []
			}
			return [target]

		case .contextualMenuForItems:
			// Called when the context menu is summed with items selected:
			guard let target = FIFinderSyncController.default().selectedItemURLs() else {
				NSLog("getAssociatedUrls(): Failed to obtain selected URLs: %@")
				return []
			}
			return target

		default:
			return nil
		}
	}

}
