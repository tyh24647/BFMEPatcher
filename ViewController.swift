//
//  ViewController.swift
//  BFMEPatcher
//
//  Created by Tyler hostager on 3/31/18.
//  Copyright © 2018 Tyler hostager. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSComboBoxDelegate, NSComboBoxDataSource, NSTextFieldDelegate, NSOpenSavePanelDelegate {
    let kBFME1_iniPath = "/Applications/Battle for Middle-Earth/Battle for Middle-Earth.app/Contents/Resources/drive_c/users/Wineskin/Application Data/My Battle for Middle-earth Files/options.ini"
    let kBFME2_iniPath = "/Applications/Battle for Middle-Earth II/Rise of the Witch King.app/Contents/Resources/drive_c/users/Wineskin/Application Data/My Battle for Middle-earth(tm) II Files/Options.ini"
    let kROTWK_iniPath = "/Applications/Battle for Middle-Earth II/Rise of the Witch King.app/Contents/Resources/drive_c/users/Wineskin/Application Data/My The Lord of the Rings, The Rise of the Witch-king Files/Options.ini"
    let kBFME1_plistPath = "/Applications/Battle for Middle-Earth/Battle for Middle-Earth.app/Contents/Info.plist"
    let kBFME2_plistPath = "/Applications/Battle for Middle-Earth II/Rise of the Witch King.app/Contents/Info.plist"
    let kROTWK_plistPath = "/Applications/Battle for Middle-Earth II/Rise of the Witch King.app/Contents/Info.plist"
    let kBFME1_exePath = "/Applications/Battle for Middle-Earth/Battle for Middle-Earth.app/Contents/Resources/drive_c/Program Files/EA GAMES/The Battle for Middle-earth (tm)/lotrbfme.exe"
    let kBFME2_exePath = "/Applications/Battle for Middle-Earth II/Rise of the Witch King.app/Contents/Resources/drive_c/Program Files/Electronic Arts/The Battle for Middle-earth (tm) II/lotrbfme2.exe"
    let kROTWK_exePath = "/Applications/Battle for Middle-Earth II/Rise of the Witch King.app/Contents/Resources/drive_c/Program Files/Electronic Arts/The Battle for Middle-earth (tm) II/lotrbfme2.exe"
    let defaultAppName = "Battle for Middle-Earth"
    
    var standardResolutions = [
        "800 x 600",
        "1024 x 768",
        "1280 x 1024",
        "1440 x 900",
        "1680 x 1050",
        "1920 x 1080",
        "1920 x 1200"
    ]
    
    let gameOptions = [
        "BFME",
        "BFME2",
        "ROTWK"
    ]
    
    @IBOutlet var gamePicker: NSComboBox!
    @IBOutlet var browseFinderBtn: NSButton!
    @IBOutlet var resChooser: NSComboBox!
    @IBOutlet var cResCheckbox: NSButton!
    @IBOutlet var gameSelectTitle: NSTextFieldCell!
    @IBOutlet var xResTF: NSTextField!
    @IBOutlet var yResTF: NSTextField!
    @IBOutlet var mainTitle: NSTextFieldCell!
    @IBOutlet var applyBtn: NSButton!
    @IBOutlet var cancelBtn: NSButton!
    @IBOutlet var resetBtn: NSButton!
    @IBOutlet var filePathTF: NSTextField!
    @IBOutlet var showAdvancedBtn: NSButton!
    @IBOutlet var useXQuartzCheckbox: NSButton!
    @IBOutlet var forceUseWrapperQuartzWM: NSButton!
    
    var selectedResIndex: Int?
    var plistPath: String!
    var iniPath: String!
    var isCustomRes: Bool?
    var useXQuartz: Bool?
    var forceWineskinWM: Bool?
    var resX = 1280
    var resY = 800
    var gamePath: String!
    var game: String!
    var selectedRes = [1280:800]
    var recommendedIndex: Int?
    
    var resArr: [[Int:Int]] = [
        [800:600],
        [1024:768],
        [1280:800],
        [1440:900],
        [1680:1050],
        [1920:1080],
        [1920:1200]
    ]
    
    var plistPaths: [String]! = [
    
    ]
    
    var exePaths: [String]! = [
        
    ]
    
    override func viewWillAppear() {
        self.plistPath = self.kBFME1_plistPath
        self.gamePath = self.kBFME1_exePath
        self.game = self.gameOptions[0]
        self.isCustomRes = false
        self.useXQuartz = true
        self.forceWineskinWM = false
        
        self.plistPaths.append(self.kBFME1_plistPath)
        self.plistPaths.append(self.kBFME2_plistPath)
        self.plistPaths.append(self.kROTWK_plistPath)
        
        self.exePaths.append(self.kBFME1_exePath)
        self.exePaths.append(self.kBFME2_exePath)
        self.exePaths.append(self.kROTWK_exePath)
        
        self.forceUseWrapperQuartzWM.isHidden = true
        
        let formattedStr = self.detectCurrentResolution()! as String
        
        var index: Int = 0
        for str in self.standardResolutions {
            if str == formattedStr || str == Display.mode?.resolution {
                self.recommendedIndex = index
                self.standardResolutions[index].append(" (Recommended)")
                break
            }
            
            index += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tmpFrame = CGRect(x: 0, y: 0, width: 400, height: 250)
        self.view.frame = tmpFrame

        // Do any additional setup after loading the view.
        self.mainTitle.title = "BFME Resolution Switcher"
        self.useXQuartzCheckbox.isHidden = true
        
        self.gamePicker.delegate = self
        self.resChooser.delegate = self
        self.filePathTF.delegate = self
        self.xResTF.delegate = self
        self.yResTF.delegate = self
        
        self.gamePicker.dataSource = self
        self.resChooser.dataSource = self
        
        if self.xResTF != nil && self.yResTF != nil {
            self.xResTF.formatter = NumberFormatter() as Formatter
            self.yResTF.formatter = NumberFormatter() as Formatter
        }
        
        let formattedStr = self.detectCurrentResolution()! as String
        
        var index: Int = 0
        for str in self.standardResolutions {
            if str == formattedStr || str == Display.mode?.resolution {
                print("\(self.standardResolutions[index]) (Recommended)")
                self.selectedResIndex = index
                break
            }
            
            print(self.standardResolutions[index])
            index += 1
        }
        
        var plistPath: String!
        let selectedCellTitle: String! = self.gamePicker.selectedCell()?.title
        
        print("Configuring property list file...")
        if selectedCellTitle != nil && !selectedCellTitle.isEmpty {
            if selectedCellTitle == "BFME2" || selectedCellTitle == "ROTWK" {
                plistPath = "/Applications/Battle for Middle-Earth II/Rise of the Witch King.app/Contents/Info.plist"
            } else if selectedCellTitle == "BFME" {
                plistPath = "/Applications/Battle for Middle-Earth/Battle for Middle-Earth.app/Contents/Info.plist"
            }
        }
        
        self.filePathTF.isEditable = false
        self.filePathTF.isSelectable = true
        self.filePathTF.backgroundColor = .clear
        self.filePathTF.isBordered = false
        //self.filePathTF.autoscroll(with: NSEvent.ButtonMask)
    }
    
    
    /// Grab the user's screen resolution
    ///
    /// - Returns: The resolution as a String object
    @discardableResult
    func detectCurrentResolution() -> String? {
        var currentResolution: String!
        
        if let scrn: NSScreen = NSScreen.main {
            let rect: NSRect = scrn.frame
            let height = rect.size.height
            let width = rect.size.width
            
            self.resX = Int(width)
            self.resY = Int(height)
            
            let formattedStr = "\(width) x \(height)"
            currentResolution = formattedStr
        }
        
        return currentResolution
    }
    
    @discardableResult
    func detectCurrentResolution() -> [Int:Int]? {
        var currentResolution: [Int:Int]!
        
        if let scrn: NSScreen = NSScreen.main {
            let rect: NSRect = scrn.frame
            let height = rect.size.height
            let width = rect.size.width
            
            currentResolution = [Int(width): Int(height)]
        }
        
        return currentResolution
    }
    
    @discardableResult
    func detectGameResolution() -> [Int:Int]? {
        var res: [Int:Int]!
        
        //if self.ini
        
        return res
    }
    
    @IBAction func browseFileBtnPressed(_ sender: Any) {
        let diaprint = NSOpenPanel()
        diaprint.title = "Choose a valid .exe/.msi file"
        diaprint.showsResizeIndicator = true
        diaprint.showsHiddenFiles = true
        diaprint.canCreateDirectories = true
        diaprint.allowsMultipleSelection = false
        diaprint.allowedFileTypes  = ["exe", "msi"]
        diaprint.hasShadow = true
        diaprint.canChooseDirectories = false
        diaprint.resolvesAliases = true
        diaprint.treatsFilePackagesAsDirectories = true
        
        if diaprint.runModal() == .OK {
            let result = diaprint.url // Pathname of the file
            
            if result != nil {
                let path = result?.path
                if sender as? NSButton == self.browseFinderBtn {
                    self.filePathTF.stringValue = path!
                }
            }
        } else {
            print("User canceled NSOpenSavePanel instance")
            // User clicked on "Cancel"
            return
        }
    }
    @IBAction func comboBoxClicked(_ sender: Any) {
        //
    }
    
    @IBAction func advancedBtnPressed(_ sender: NSButton) {
        self.useXQuartzCheckbox.isHidden = !self.useXQuartzCheckbox.isHidden
        self.forceUseWrapperQuartzWM.isHidden = !self.forceUseWrapperQuartzWM.isHidden
    }
    
    @IBAction func gamePicked(_ sender: Any) {
        if self.gamePicker.indexOfSelectedItem != -1 {
            self.plistPath = self.plistPaths[self.gamePicker.indexOfSelectedItem]
        }
    }
    
    @IBAction func customResCheckboxToggled(_ sender: Any) {
        self.xResTF.isEditable = !self.xResTF.isEditable
        self.yResTF.isEditable = !self.yResTF.isEditable
    }
    
    @IBAction func resolutionPicked(_ sender: Any) {
        self.selectedRes = self.resArr[self.resChooser.indexOfSelectedItem]
    }
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        self.resX = 1280
        self.resY = 800
        self.gamePicker.selectItem(at: 0)
        self.game = self.gameOptions[0]
        self.gamePath = self.kBFME1_exePath
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.view.window!.close()
    }
    
    @IBAction func applyBtnPressed(_ sender: Any) {
        self.applyChangesToPLIST(atPath: self.plistPath)
    }
    
    func applyChangesToPLIST(atPath plistPath: String!, _ newProperties: NSMutableDictionary? = ["Program Flags":"-xres 1680 -yres 1050"]) -> Void {
        
        if plistPath != nil && !plistPath.isEmpty {
            if FileManager.default.fileExists(atPath: plistPath) {
                print("Property list file found successfully")
                let plistDict = NSMutableDictionary(contentsOfFile: plistPath)
                self.plistPath = plistPath
                print("Setting plist values...")
                plistDict?.setValue(self.filePathTF.stringValue as AnyObject, forKey: "Program Name and Path")
                
                self.useXQuartz = self.useXQuartzCheckbox.state == .on
                plistDict?.setValue(self.useXQuartz!.description, forKey: "Use XQuartz")
                
                var forceWrapperQuartzWM = self.forceUseWrapperQuartzWM!.state == .on
                plistDict?.setValue(true, forKey: "force wrapper quartz-wm")
                
                var iniFilePath = ""
                print("Launching application saved in the property list...")
                let selectedCellTitle: String! = self.gamePicker.selectedCell()?.title
                if selectedCellTitle != nil && !selectedCellTitle.isEmpty {
                    if selectedCellTitle == "BFME2" || selectedCellTitle == "ROTWK" {
                        iniFilePath = { () -> String in
                            self.iniPath = kBFME2_iniPath
                            return self.iniPath
                        }()
                    } else if selectedCellTitle == "BFME" {
                        iniFilePath = { () -> String in
                            self.iniPath = kBFME1_iniPath
                            return self.iniPath
                        }()
                    } else {
                        // TODO: add other mac ports
                    }
                }
                
                var formattedOptions = [String]()
                var i = 0
                for var item in self.standardResolutions as [String] {
                    if item.contains(" (Recommended)") {
                        item = String(item.components(separatedBy: " (")[0])
                    }
                    
                    formattedOptions.append(item)
                    i += 1
                }
                
                self.useXQuartz = self.useXQuartzCheckbox.state == .on
                plistDict?.setValue(self.useXQuartz, forKey: "Use XQuartz")
                
                self.forceWineskinWM = self.forceUseWrapperQuartzWM!.state == .on
                plistDict?.setValue(true, forKey: "force wrapper quartz-wm")
                
                var splitStr = formattedOptions[self.resChooser.indexOfSelectedItem].components(separatedBy: " x ")
                
                let xVal = splitStr[0]
                let yVal = splitStr[1]
                
                print("Setting plist values...")
                plistDict?.setValue("-xres \(xVal) -yres \(yVal)" as AnyObject, forKey: "Program Flags")
                if plistDict != nil {
                    print("Value set successfully")
                }
                
                NSLog("Parsing and editing \"options.ini\" file at path: \"%@\"", iniFilePath)
                
                
                self.parseAndEditIniFile(
                    with: FileManager.default,
                    withXValue: xVal,
                    withYValue: yVal,
                    atPath: iniFilePath
                )
                
                print("\"options.ini\" file configured successfully")
                print("Applying property list file changes...")
                
                do {
                    if #available(macOS 10.13, *) {
                        try plistDict?.write(
                            to: URL(
                                fileURLWithPath: plistPath,
                                isDirectory: false
                            )
                        )
                    } else {
                        plistDict!.write(
                            toFile: plistPath,
                            atomically: true
                        )
                        
                        print("Replacement property list saved successfully")
                    }
                } catch {
                    
                }
                
                
                var gameToLaunch = ""
                
                print("Launching application saved in the property list...")
                
                // custom/mods exe
                if !self.filePathTF.stringValue.isEmpty {
                    self.gamePath = self.filePathTF.stringValue
                    print("Creating launcher command to send to the environment...")
                    
                    // Create a Task instance
                    let task = Process()
                    task.launchPath = "/usr/bin/env"
                    task.arguments = []
                    
                    // Create a Pipe and make the task put all the output there
                    let pipe = Pipe()
                    task.standardOutput = pipe
                    task.launch()
                    
                    // Get the data
                    let data = pipe.fileHandleForReading.readDataToEndOfFile()
                    let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    
                    print(output! as String)
                    
                    if !self.gamePath.contains(self.game) {
                        print("Bash shell script executed: %@", ShellScriptExecutionTask.bash(
                            command: "osascript",
                            arguments: [
                                //self.gamePath,
                                "-e",
                                "do shell script",
                                "'sudo open -a 'Battle for Middle-Earth';'",
                                "with administrator privileges"
                            ])
                        )
                        //print("Bash shell script executed: %@", ShellScriptExecutionTask.bash(command: "open", arguments: [self.gamePath, "-a", "Battle for Middle-Earth"]))
                        print("Launched successfully")
                    } else if self.gamePath.contains("2") || self.gamePath.lowercased().contains("rise") || self.gamePath.contains("ROTWK") {
                        print("Bash shell script executed: %@", (ShellScriptExecutionTask.bash(command: "open", arguments: [ "-a", "BFME2" ])))
                    } else {
                        print("Bash shell script executed: %@", (ShellScriptExecutionTask.bash(command: "open", arguments: [ "-a", "Battle for Middle-Earth", self.gamePath ])))
                    }
                } else {
                    let selectedCellTitle: String! = self.gamePicker.selectedCell()?.title
                    if selectedCellTitle != nil && !selectedCellTitle.isEmpty {
                        if selectedCellTitle == "BFME2" {
                            gameToLaunch = "BFME2"
                        } else if selectedCellTitle == "BFME" {
                            gameToLaunch = "Battle for Middle-Earth"
                        } else if selectedCellTitle == "ROTWK" {
                            gameToLaunch = "Rise of the Witch King"
                        }
                    }
                    
                    self.gamePath = self.filePathTF.stringValue.isEmpty ?
                        gameToLaunch.isEmpty ? self.defaultAppName : gameToLaunch : self.filePathTF.stringValue
                }
                
                print("Launching application \"%\"", self.gamePath)
                if NSWorkspace.shared.launchApplication("/Applications/Battle for Middle-Earth/Battle for Middle-Earth.app") {
                    print("Application launched successfully")
                } else {
                    print("Manually launching application...")
                    
                    do {
                        
                        try NSWorkspace.shared.launchApplication(
                            at: URL(fileURLWithPath: "/Applications/Battle for Middle-Earth/Battle for Middle-Earth.app"),
                            options: NSWorkspace.LaunchOptions.async,
                            configuration: [
                                NSWorkspace.LaunchConfigurationKey.arguments: [
                                
                                ]
                            ]
                        )
                        
                    } catch {
                        print(error)
                    }
                    
                    print("couldn't launched from shared application space...")
                    print("launching from shell command...")
                    
                    print(
                        ShellScriptExecutionTask.bash(
                            command: "osascript",
                            arguments: [
                            /*
                            command: "open",
                            arguments: [
                                "-a",
                                "\"Battle for Middle-Earth\""
                            ]
 */
                                
                                "-e",
                                "do shell script",
                                "'sudo open -a 'sBattle for Middle-Earth';'",
                                "with administrator privileges"
                            ]
                        )
                    )
                    
                    let errMsg = "Unable to launch application \"%@\""
                    print("ERROR: %@", errMsg)
                }
            }
        }
        
        /*
         @available(macOS, deprecated: 10.10)
         @IBAction func applyBtnPressed(_ sender: Any) {
         let fileManager = FileManager.default
         if resCB.indexOfSelectedItem == -1 {
         resCB.selectItem(at: 0)
         
         }
         
         let selectedCellTitle: String! = !self.fNInputField.stringValue.isEmpty ? self.gamesChooserCB.selectedCell()?.title : self.fNInputField.stringValue
         var plistPath: String!
         
         print("Configuring property list file...")
         if selectedCellTitle != nil && !selectedCellTitle.isEmpty {
         if selectedCellTitle == "BFME2" || selectedCellTitle == "ROTWK" {
         plistPath = "/Applications/Battle for Middle-Earth II/Rise of the Witch King.app/Contents/Info.plist"
         } else if selectedCellTitle == "BFME" {
         plistPath = "/Applications/Battle for Middle-Earth/Battle for Middle-Earth.app/Contents/Info.plist"
         } else {
         
         }
         } else {
         plistPath = FilePaths.defaultGamePath
         }
         
         self.p_selectedFilePath = plistPath!
         
         print("Searching for file at path: \(plistPath)")
         if fileManager.fileExists(atPath:  plistPath) {
         print("Property list file found successfully")
         let plistDict = NSMutableDictionary(contentsOfFile: plistPath)
         
            var formattedOptions = [String]()
            for item in self.resolutionOptions {
                if !item.contains("...") {
                    formattedOptions.append(item)
                }
            }
     
            var splitStr = formattedOptions[resCB.indexOfSelectedItem].components(separatedBy: " x ")
     
            let xVal = splitStr[0]
            let yVal = splitStr[1]
     
            // SET RESOLUTION
            print("Setting plist values...")
            plistDict?.setValue("-xres \(xVal) -yres \(yVal)" as AnyObject, forKey: "Program Flags")
            if plistDict != nil {
                print("Value set successfully")
            }
     
            // USE XQUARTZ
            self.p_useXQuartz = self.useXQuartzChkBx.state == .on
            plistDict?.setValue(self.p_useXQuartz, forKey: "Use XQuartz")
     
            self.p_force_wrapper_use_quartz_wm = self.forceUseWrapperQuartzWM!.state == .on
            plistDict?.setValue(true, forKey: "force wrapper quartz-wm")
     
            self.p_isThreadedLoad = self.multithreadingBtn.state == .on
            plistDict?.setValue(self.p_isThreadedLoad , forKey: "IsThreadedLoad")
     
            var iniFilePath = ""
            print("Launching application saved in the property list...")
            let selectedCellTitle: String! = self.gamesChooserCB.selectedCell()?.title
            if selectedCellTitle != nil && !selectedCellTitle.isEmpty {
                if selectedCellTitle == "BFME2" || selectedCellTitle == "ROTWK" {
                    iniFilePath = "/Applications/Battle for Middle-Earth II/Rise of the Witch King.app/Contents/Resources/drive_c/users/Wineskin/AppData/Roaming/My Battle for Middle-earth(tm) II Files/Options.ini"
                } else if selectedCellTitle == "BFME" {
                    iniFilePath = FilePaths.optionsIniFilePath
                } else {
                    // TODO: add other mac ports
                }
            }
     
            print("Parsing and editing \"options.ini\" file at path: \"%@\"", iniFilePath)
            self.parseAndEditIniFile(
                with: fileManager,
                withXValue: xVal,
                withYValue: yVal,
                atPath: iniFilePath
            )
     
            print("\"options.ini\" file configured successfully")
            print("Applying property list file changes...")
     
            var plistPath: String!
            print("Configuring property list file...")
            if selectedCellTitle != nil && !selectedCellTitle.isEmpty {
                if selectedCellTitle == "BFME2" || selectedCellTitle == "ROTWK" {
                    plistPath = "/Applications/Battle for Middle-Earth II/Rise of the Witch King.app/Contents/Info.plist"
                } else if selectedCellTitle == "BFME" {
                    plistPath = "/Applications/Battle for Middle-Earth/Battle for Middle-Earth.app/Contents/Info.plist"
                } else{
                    // TODO: Future ports paths here
                }
            }
     
            // ensure property list path has been assigned properly
            plistPath = { () -> String in
                return plistPath != nil && !plistPath.isEmpty ? plistPath : FilePaths.kBFME2_defaultPLISTLocalPath
            }()
     
            do {
                if #available(macOS 10.13, *) {
                    try plistDict?.write(
                        to: URL(
                            fileURLWithPath: plistPath,
                            isDirectory: false
                        )
                    )
                } else {
                    plistDict!.write(
                        toFile: plistPath,
                        atomically: true
                    )
     
                    print("Replacement property list saved successfully")
                }
            } catch {
                errStr = "ERROR: Unable to write to file at path \(plistPath)\n\nSkipping procedure"
            }
        } else {
            errStr = "ERROR: File not found\nSkipping procedure."
        }
     
        if errStr != nil && !errStr.isEmpty {
            resultDiaprintue(prompt: "An error occurred while changing the resolution values.", description: errStr)
        } else {
            resultDiaprintue(prompt: "Settings changes applied successfully!", description: "The changes will be applied the next time the application is launched.")
        }
     
        self.launchApplicationInPLIST()
    }
 */
    }
        
    /// Parses the windows "options.ini" file (not supported by mac computers so we have to do it manually),
    /// and re-writes the value for the resolution so the changes are saved in the AppData folder and will remain
    /// the same until the user decides to change it again.
    ///
    /// - Parameters:
    ///   - fileManager: The file manager shared in this instance to handle file parsing, reading, and writing
    ///   - xVal: The value in which the width of the resolution should be set
    ///   - yVal: The value in which the height of the resolution should be set
    func parseAndEditIniFile(with fileManager: FileManager, withXValue xVal: String!, withYValue yVal: String!, atPath iniFilePath: String!) -> Void {
            if fileManager.fileExists(atPath: iniFilePath) {
                do {
                    var fileContents = try String(contentsOfFile: iniFilePath)
                    let resHeaderSubStr = "Resolution = "
                    if fileContents.contains(resHeaderSubStr) {
                        let substringVal = fileContents.slice(from: resHeaderSubStr, to: "\n")
                        let newResVal = "\(xVal!) \(yVal!)"
                        
                        
                        // Replace the value at the corresponding "Resolution" header with the string containing the new values
                        print("Replacing options.ini value: \"\(resHeaderSubStr.appending(substringVal!))\" --> \"\(resHeaderSubStr.appending(newResVal))\"")
                        fileContents = fileContents.replacingOccurrences(of: substringVal!, with: newResVal)
                        print("Replacement successful")
                        
                        
                        // Delete old file with the incorrect value, and replace it with the file whose value
                        // was changed. This is only necessary because macOS doesn't support writing *.ini files
                        print("Removing old file...")
                        try fileManager.removeItem(atPath: iniFilePath)
                        print("File removed successfully")
                        print("Creating and replacing the ini file with one containing the requested changes...")
                        
                        // behaves similarly to JSON in the file writer
                        fileManager.createFile(
                            atPath: iniFilePath,
                            contents: fileContents.data(using: .utf8),
                            attributes: [
                                FileAttributeKey.type: "ini",
                                FileAttributeKey.extensionHidden: false,
                                FileAttributeKey.groupOwnerAccountName: "wheel"
                            ]
                        )
                        
                        print("File replaced successfully")
                    }
                } catch {
                    print("ERROR: Unable to write to \"options.ini\".\nSkipping procedure")
                }
            }
        }
    
    @IBAction func chooseFileBtn(_ sender: Any) {
        
    }
    
    @IBAction func customResChkBtnChecked(_ sender: Any) {
        self.xResTF.isEditable = !self.xResTF.isEditable
        self.yResTF.isEditable = !self.yResTF.isEditable
    }
    
    
    func control(_ control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
        return fieldEditor.isEditable && fieldEditor.isSelectable && self.cResCheckbox.state == .on
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        switch comboBox {
        case self.gamePicker:
            self.gameSelectTitle.title = gameOptions[index]
            self.game = self.gameOptions[index]
            self.filePathTF.stringValue = self.exePaths[index]
            return gameOptions[index]
        case self.resChooser:
            return standardResolutions[index]
        default:
            return ""
        }
        
    }
    
    func comboBox(_ comboBox: NSComboBox, completedString string: String) -> String? {
        return string.contains(".") ? String(string.split(separator: ".")[0]) as String : string
        
        // TODO add more
    }
    
    
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        switch comboBox {
        case self.gamePicker:
            return self.gameOptions.count
        case self.resChooser:
            return standardResolutions.count
        default:
            return 0
        }
    }
    
    func comboBoxWillDismiss(_ notification: Notification) {
        if self.gamePicker.indexOfSelectedItem != -1 {
            self.mainTitle.title = self.gameOptions[self.gamePicker.indexOfSelectedItem] + " Resolution Switcher"
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    func comboBoxWillPopUp(_ notification: Notification) {
        //
    }
    
    
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        
    }
    
    func comboBoxSelectionIsChanging(_ notification: Notification) {
        
    }
    
    
//    func textField(_ textField: NSTextField, textView: NSTextView, shouldSelectCandidateAt index: Int) -> Bool {
//        var shouldSelect = false
//
//        return shouldSelect
//    }
    
//    func comboBox(_ comboBox: NSComboBox, indexOfItemWithStringValue string: String) -> Int {
//        return string
//    }
}

extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

