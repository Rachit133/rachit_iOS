//
//  TMLLog.swift
//  TMLBaseTemplateMVVM
//
//  Created by Apple on 14/02/19.
//  Copyright © 2019 Apple. All rights reserved.
//
/*
import Foundation

class TMLLog{
    
    static let log = LogManager.shared.log
    
    class func verbose(_ message: @autoclosure () -> Any, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil){
        log.verbose(message(), file, function, line: line, context: context)
    }
    
    class func info(_ message: @autoclosure () -> Any, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil){
        log.info(message(), file, function, line: line, context: context)
    }
    
    class func debug(_ message: @autoclosure () -> Any, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil){
        log.debug(message(), file, function, line: line, context: context)
    }
    
    class func warning(_ message: @autoclosure () -> Any, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil){
        log.warning(message(), file, function, line: line, context: context)
    }
    
    class func error(_ message: @autoclosure () -> Any, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil){
        log.error(message(), file, function, line: line, context: context)
    }
    
    class func pushLogs(fileName:String, bucketName:String) {
        let logFileUrl = LogManager.shared.getUploadLogFileURL()
        if logFileUrl != nil {
            print("log File URL \(String(describing: logFileUrl?.absoluteString))")
        } else {
            LogManager.shared.updateLogFilePath()
        }
    }
    
    class func deleteLogFile() {
        let status = LogManager.shared.deleteUploadLogFile()
        print("Log File Deleted : \(status)")
    }
}*/
