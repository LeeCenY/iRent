//
//  DBBackup.swift
//  iRent
//
//  Created by TTLGZMAC6 on 2018/8/3.
//

import Foundation
import PerfectZip
import PerfectQiniu
import PerfectLib
import PerfectHTTP

public struct DBBackup {
    
    func start() {

        let date = Date().iso8601()
        let zipName = "\(date).zip"
        let thisZipFile = "压缩文件之后的位置/\(zipName)"
        let sourceDir = "数据库文件位置"
        let password = ""
        
        let zipResult = Zip().zipFiles(
            paths: [sourceDir],
            zipFilePath: thisZipFile,
            overwrite: true, password: password
        )
        
        if zipResult.description == ZipStatus.ZipSuccess.description {
            do {
                let config = QiniuConfig().DBBackupScope()
                _ = try Qiniu.upload(fileName: zipName, file: thisZipFile, config: config)
                File(thisZipFile).delete()
            } catch {
                
            }
        }
    }
}

