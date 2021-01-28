//
//  HelperFunctions.swift
//  RightClickExtension
//
//  Created by Pho Hale on 1/27/21.
//  Copyright © 2021 Antti Tulisalo. All rights reserved.
//

import Foundation
import Cocoa


struct Helpers {

//	static func isGitRepository(url: URL) -> Bool {
//		let command = "[ -d .git ] && echo .git || git rev-parse --git-dir > /dev/null 2>&1"
//		let task = Process()
//		task.executableURL = URL(fileURLWithPath: "/usr/bin/open")
//		task.arguments = arguments
//		do {
//			try task.run()
//		} catch let error as NSError {
//			NSLog("performOpen(programPathString: \(programPathString), additionalArguments: ...): Failed to open the app: %@", error.description as NSString)
//		}
//		
//	}



	static func setClipboard(string: String) {
		 let pasteboard = NSPasteboard.general
		 pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
		 pasteboard.setString(string, forType: NSPasteboard.PasteboardType.string)
	 }


	static func performOpen(programPathString: String, additionalArguments: [String]) {
		// programPathString: "/Applications/Visual Studio Code.app"
		var arguments = ["-a", programPathString]
		arguments.append(contentsOf: additionalArguments)

		let task = Process()
		task.executableURL = URL(fileURLWithPath: "/usr/bin/open")
		task.arguments = arguments
		do {
			try task.run()
		} catch let error as NSError {
			NSLog("performOpen(programPathString: \(programPathString), additionalArguments: ...): Failed to open the app: %@", error.description as NSString)
		}

	}

}
