//
//  LogManager.swift
//
//  Created by Apple on 14/02/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

/*class LogManager {
    
    static let shared = LogManager()
    
    let log = SwiftyBeaver.self
    var console : ConsoleDestination!
    var file : FileDestination!
    var file2 : FileDestination!
    
    func initialize(){
        initSwiftyBeaver()
    }
    
    func initSwiftyBeaver() {
        let logFormat = "$Dyyyy-MM-dd'T'HH:mm:ss.SSS'Z'$d $L $N.$F:$l $M"
        #if PROD
        //Skip logs for Prod mode.
        #else
        console = ConsoleDestination()  // log to Xcode Console
        console.format = logFormat
        log.addDestination(console)
        #endif
        
        file = FileDestination()  //default logs1.txt file
        file.format = logFormat
        
        file2 = FileDestination()  // log to default log.txt file
        file2.format = logFormat
        let newFilePath = file.baseURL!.appendingPathComponent("TMLlogs2.txt", isDirectory: false)
        file2.logFileURL = newFilePath
        log.addDestination(file2)
        
    }
    
    func getLogFileURL() -> URL? {
        let fileURL = file2.logFileURL
        let manager = FileManager.default
        if manager.fileExists(atPath: fileURL?.path ?? "") {
            return fileURL
        }
        return nil
    }
    
    func getUploadLogFileURL() -> URL? {
        let fileURL = file.logFileURL
        let manager = FileManager.default
        if manager.fileExists(atPath: fileURL?.path ?? "") {
            return fileURL
        }
        return nil
    }
    
    func getUploadLogFileContent() -> String? {
        let filePath = file.logFileURL
        //reading
        do {
            let fileContent = try String.init(contentsOf: filePath!, encoding: .utf8)
            return fileContent
        } catch {
            
        }
        return nil
    }
    
    func deleteUploadLogFile() -> Bool {
        let status = file.deleteLogFile()
        updateLogFilePath()
        return status
    }
    
    func deleteOldLogFile() -> Bool {
        let status = file2.deleteLogFile()
        return status
    }
    
    
    func updateLogFilePath() {
        let oldLogFilePath = file2.logFileURL!
        let newLogFilePath = file.logFileURL!
        file2.renameLogFile(oldFilePathURL: oldLogFilePath, newFilePathURL:newLogFilePath)
        let status = file2.deleteFileFromURL(newURL: oldLogFilePath)
        print("old log file deleted : \(status)")
        log.addDestination(file2)
    }
    
}*/
