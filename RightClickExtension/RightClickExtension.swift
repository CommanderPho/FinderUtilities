//
//  RightClickExtension.swift
//  RightClickExtension
//
//  Created by Antti Tulisalo on 27/08/2019.
//  Copyright © 2019 Antti Tulisalo. All rights reserved.
//

import Cocoa
import FinderSync

extension FIMenuKind {
//	public typealias AllCases = UInt

	public static var allCases: [FIMenuKind] =  [FIMenuKind.toolbarItemMenu, FIMenuKind.contextualMenuForContainer, .contextualMenuForItems, .contextualMenuForSidebar]
//	public typealias AllCases = [FIMenuKind.toolbarItemMenu, FIMenuKind.contextualMenuForContainer]
}

class FinderSync: FIFinderSync {

	override var toolbarItemName: String { return "Pho Finder Sync" }
	override var toolbarItemImage: NSImage { return NSImage(named: "single")! }
	override var toolbarItemToolTip: String { return "Pho Finder Sync Extension" }

	lazy var actionItems: [ActionItem] = {
		return [
			ActionItem(title: "Open Terminal Here...", action: #selector(openTerminalClicked(_:)), allowedMenuKinds: [.toolbarItemMenu, .contextualMenuForContainer]),
			ActionItem(title: "Open Fork Here...", action: #selector(openForkGitClientHereClicked(_:)), allowedMenuKinds: [.toolbarItemMenu, .contextualMenuForContainer]),
			ActionItem(title: "Open VS Code Here...", action: #selector(openMicrosoftVisualStudioCodeHereClicked(_:)), allowedMenuKinds: [.toolbarItemMenu, .contextualMenuForContainer]),
			ActionItem(title: "Copy directory path", action: #selector(copyPathToClipboard), allowedMenuKinds: [.toolbarItemMenu, .contextualMenuForContainer]),
			ActionItem(title: "Create empty.txt Here", action: #selector(createEmptyFileClicked(_:)), allowedMenuKinds: [.toolbarItemMenu]),
			ActionItem(title: "Copy selected item(s) paths", action: #selector(copySelectedPathsToClipboard), allowedMenuKinds: [.contextualMenuForItems]),
		]
	}()


	var menusDict: [FIMenuKind:NSMenu] = [:]

//	lazy var menusDict: [FIMenuKind:NSMenu] = {
//
//
//	}()

	func buildMenus() -> [FIMenuKind:NSMenu] {
		let actions = self.actionItems
		var outMenusDict: [FIMenuKind:NSMenu] = [:]

		for menuType in FIMenuKind.allCases {
			let outMenu: NSMenu = NSMenu(title: "")

			for anAction in actions {
				if (anAction.allowedMenuKinds.contains(menuType)) {
					// Add to this menu
					outMenu.addItem(anAction.asMenuItem)
				}
			}

			outMenusDict[menuType] = outMenu
		}
		return outMenusDict
	}

    override init() {
        super.init()

		// Build the menus
		self.menusDict = self.buildMenus()

		NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)
        
        // Set up the directory we are syncing
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: "/")]
    }




    override func menu(for menuKind: FIMenuKind) -> NSMenu {

		guard let validMenu = self.menusDict[menuKind] else {
			fatalError()
		}
		return validMenu

//		let menu = NSMenu(title: "")
//		switch menuKind {
//		case .toolbarItemMenu:
//			menu.addItem(withTitle: "Open Terminal Here...", action: #selector(openTerminalClicked(_:)), keyEquivalent: "")
//			menu.addItem(withTitle: "Open Fork Here...", action: #selector(openForkGitClientHereClicked(_:)), keyEquivalent: "")
//			menu.addItem(withTitle: "Open VS Code Here...", action: #selector(openMicrosoftVisualStudioCodeHereClicked(_:)), keyEquivalent: "")
//			menu.addItem(withTitle: "Copy directory path", action: #selector(copyPathToClipboard), keyEquivalent: "")
//			menu.addItem(withTitle: "Create empty.txt Here", action: #selector(createEmptyFileClicked(_:)), keyEquivalent: "")
//
//			//menu.addItem(withTitle: "Create empty.txt", action: #selector(createEmptyFileClicked(_:)), keyEquivalent: "")
////			menu.addItem(withTitle: "Copy selected paths...", action: #selector(copyPathToClipboard), keyEquivalent: "")
//
//		case .contextualMenuForContainer:
//			// Called when the background is clicked with no items selected.
//			menu.addItem(withTitle: "Open Terminal Here...", action: #selector(openTerminalClicked(_:)), keyEquivalent: "")
//			menu.addItem(withTitle: "Open Fork Here...", action: #selector(openForkGitClientHereClicked(_:)), keyEquivalent: "")
//			menu.addItem(withTitle: "Open VS Code Here...", action: #selector(openMicrosoftVisualStudioCodeHereClicked(_:)), keyEquivalent: "")
//			menu.addItem(withTitle: "Copy directory path", action: #selector(copyPathToClipboard), keyEquivalent: "")
//
//		case .contextualMenuForItems:
//			// Called when the context menu is summed with items selected:
//			menu.addItem(withTitle: "Copy selected item(s) paths", action: #selector(copySelectedPathsToClipboard), keyEquivalent: "")
//
//		case .contextualMenuForSidebar:
//			NSLog("menu(for menuKind: .contextualMenuForSidebar): Sidebar not allowed!")
//			fatalError("Don't allow sidebars!")
//
//		default:
////			menu.addItem(withTitle: "Open Terminal", action: #selector(openTerminalClicked(_:)), keyEquivalent: "")
//			NSLog("menu(for menuKind: .default): Unknown menu type!")
//			fatalError("Don't allow unknown menu types!!")
//		}
//        // Produce a menu for the extension (to be shown when right clicking a folder in Finder)
//        return menu
    }

	////////////////////////////////////////////////////////////////////
	//MARK: -
	//MARK: - Main Menu Actions:

    /// Copies the selected file and/or directory paths to pasteboard
	@IBAction func copySelectedPathsToClipboard(_ sender: AnyObject?) {

		guard let target = FIFinderSyncController.default().selectedItemURLs() else {
			NSLog("copySelectedPathsToClipboard(...): Failed to obtain selected URLs: %@")
			return
		}

		let pasteboard = NSPasteboard.general
		pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
		var result = ""

		// Loop through all selected paths
		for path in target {
			result.append(contentsOf: path.relativePath)
			result.append("\n")
		}
		result.removeLast() // Remove trailing \n

		pasteboard.setString(result, forType: NSPasteboard.PasteboardType.string)
	}


    @IBAction func copyPathToClipboard(_ sender: AnyObject?) {
        
        guard let target = FIFinderSyncController.default().targetedURL() else {
			NSLog("copyPathToClipboard(...): Failed to obtain targeted URLs: %@")
            return
        }
        
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        var result = target.relativePath
        pasteboard.setString(result, forType: NSPasteboard.PasteboardType.string)
    }





    /// Creates an empty file with name "untitled" under the user-chosen Finder folder.
    /// If file already exists, append it with a counter.
    @IBAction func createEmptyFileClicked(_ sender: AnyObject?) {
        
        guard let target = FIFinderSyncController.default().targetedURL() else {
            
            NSLog("Failed to obtain targeted URL: %@")
            
            return
        }

        var originalPath = target
        let originalFilename = "newfile"
        var filename = "newfile.txt"
        let fileType = ".txt"
        var counter = 1
        
        while FileManager.default.fileExists(atPath: originalPath.appendingPathComponent(filename).path) {
            filename = "\(originalFilename)\(counter)\(fileType)"
            counter+=1
            originalPath = target
        }
        
        do {
            try "".write(to: target.appendingPathComponent(filename), atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            
            NSLog("Failed to create file: %@", error.description as NSString)
        }
    }
}


////////////////////////////////////////////////////////////////////
//MARK: -
//MARK: - Open in *
extension FinderSync {

	/// Opens a macOS Terminal.app window in the user-chosen folder
	@IBAction func openTerminalClicked(_ sender: AnyObject?) {

		guard let target = FIFinderSyncController.default().targetedURL() else {

			NSLog("openTerminalClicked(...): Failed to obtain targeted URL: %@")

			return
		}

		let task = Process()
		task.executableURL = URL(fileURLWithPath: "/usr/bin/open")
		task.arguments = ["-a", "terminal", "\(target)"]

		do {

			try task.run()

		} catch let error as NSError {

			NSLog("openTerminalClicked(...): Failed to open Terminal.app: %@", error.description as NSString)
		}
	}



	@IBAction func openMicrosoftVisualStudioCodeHereClicked(_ sender: AnyObject?) {

		guard let target = FIFinderSyncController.default().targetedURL() else {
			NSLog("openMicrosoftVisualStudioCodeHereClicked(...): Failed to obtain targeted URL: %@")
			return
		}

		let vsCodeAppExecutionPath: String = "/Applications/Visual Studio Code.app"

		let task = Process()
		task.executableURL = URL(fileURLWithPath: "/usr/bin/open")
		task.arguments = ["-a", vsCodeAppExecutionPath, "\(target)"]

		do {
			try task.run()
		} catch let error as NSError {
			NSLog("openMicrosoftVisualStudioCodeHereClicked(...): Failed to open Visual Studio Code.app: %@", error.description as NSString)
		}
	}


}


////////////////////////////////////////////////////////////////////
//MARK: -
//MARK: - GIT

extension FinderSync {

	@IBAction func openForkGitClientHereClicked(_ sender: AnyObject?) {

		guard let target = FIFinderSyncController.default().targetedURL() else {
			NSLog("openForkGitClientHereClicked(...): Failed to obtain targeted URL: %@")
			return
		}

		let forkAppExecutionPath: String = "/Applications/Fork.app"

		let task = Process()
		task.executableURL = URL(fileURLWithPath: "/usr/bin/open")
		task.arguments = ["-a", forkAppExecutionPath, "\(target)"]

		do {
			try task.run()
		} catch let error as NSError {
			NSLog("openForkGitClientHereClicked(...): Failed to open Fork.app: %@", error.description as NSString)
		}
	}


	@IBAction func openRepoInGithubClicked(_ sender: AnyObject?) {

		guard let target = FIFinderSyncController.default().targetedURL() else {
			NSLog("openForkGitClientHereClicked(...): Failed to obtain targeted URL: %@")
			return
		}

		let forkAppExecutionPath: String = "/Applications/Fork.app"

		let task = Process()
		task.executableURL = URL(fileURLWithPath: "/usr/bin/open")
		task.arguments = ["-a", forkAppExecutionPath, "\(target)"]

		do {
			try task.run()
		} catch let error as NSError {
			NSLog("openForkGitClientHereClicked(...): Failed to open Fork.app: %@", error.description as NSString)
		}
	}


}
