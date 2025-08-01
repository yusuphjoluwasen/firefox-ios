// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

protocol LoggerFileManager: Sendable {
    /// Get the URL of a new log file
    func getLogDestination() -> URL?

    /// Copy logs files from the cache to the documents folder so the user can access them
    func copyLogsToDocuments()

    /// Deletes cached log files.
    func deleteCachedLogFiles()
}

final class DefaultLoggerFileManager: LoggerFileManager {
    private static let TwoMBsInBytes: Int64 = 2 * 100000
    private let fileManager: FileManagerProtocol
    private let fileNameRoot: String
    private let sizeLimit: Int64

    private let logDirectoryPath: String?

    init(fileNameRoot: String = "Firefox",
         fileManager: FileManagerProtocol = FileManager.default,
         sizeLimit: Int64 = TwoMBsInBytes) {
        self.fileNameRoot = fileNameRoot
        self.fileManager = fileManager
        self.sizeLimit = sizeLimit
        self.logDirectoryPath = Self.logFileDirectoryPath(inDocuments: false, withFileManager: fileManager)
    }

    func getLogDestination() -> URL? {
        guard let path = Self.logFileDirectoryPath(inDocuments: false, withFileManager: fileManager) else { return nil }

        let pathComponent = "\(fileNameRoot).log"
        return URL(fileURLWithPath: path, isDirectory: true).appendingPathComponent(pathComponent)
    }

    func copyLogsToDocuments() {
        deleteOldDocumentDirectoryLogs()
        copyLogs()
    }

    // MARK: - Private

    /// Deletes all log files in Caches (and Documents) directory.
    func deleteCachedLogFiles() {
        deleteOldLogs(inDocuments: false)
        deleteOldLogs(inDocuments: true)
    }

    /// Delete logs in Documents folder to make sure we can copy in the latest version of the logs file
    private func deleteOldDocumentDirectoryLogs() {
        deleteOldLogs(inDocuments: true)
    }

    private func deleteOldLogs(inDocuments: Bool) {
        guard let logDirectoryPath = Self.logFileDirectoryPath(inDocuments: inDocuments, withFileManager: fileManager),
              let logFiles = try? fileManager.contentsOfDirectoryAtPath(logDirectoryPath,
                                                                        withFilenamePrefix: fileNameRoot)
        else { return }

        for logFile in logFiles {
            try? fileManager.removeItem(atPath: "\(logDirectoryPath)/\(logFile)")
        }
    }

    /// Copy logs file from the cache to the documents folder
    private func copyLogs() {
        guard let defaultLogDirectoryPath = Self.logFileDirectoryPath(inDocuments: false, withFileManager: fileManager),
              let documentsLogDirectoryPath = Self.logFileDirectoryPath(inDocuments: true, withFileManager: fileManager),
              let previousLogFiles = try? fileManager.contentsOfDirectory(atPath: defaultLogDirectoryPath)
        else { return }

        let defaultLogDirectoryURL = URL(fileURLWithPath: defaultLogDirectoryPath, isDirectory: true)
        let documentsLogDirectoryURL = URL(fileURLWithPath: documentsLogDirectoryPath, isDirectory: true)
        for previousLogFile in previousLogFiles {
            let previousLogFileURL = defaultLogDirectoryURL.appendingPathComponent(previousLogFile)
            let targetLogFileURL = documentsLogDirectoryURL.appendingPathComponent(previousLogFile)
            try? fileManager.copyItem(at: previousLogFileURL, to: targetLogFileURL)
        }
    }

    /// Get the logs file either from documents or cache folder. If the Logs folder doesn't
    /// exist in that folder it will be created.
    ///
    /// - Parameter inDocuments: If `true` then we get the document logs path, if `false` we get the cache logs path
    /// - Returns: The path for logs in the directory we asked for
    private static func logFileDirectoryPath(
        inDocuments: Bool,
        withFileManager fileManager: FileManagerProtocol
    ) -> String? {
        let searchPathDirectory: FileManager.SearchPathDirectory = inDocuments ? .documentDirectory : .cachesDirectory
        guard let targetDirectory = NSSearchPathForDirectoriesInDomains(searchPathDirectory,
                                                                        .userDomainMask,
                                                                        true).first
        else { return nil }

        let logsDirectory = "\(targetDirectory)/Logs"
        if !fileManager.fileExists(atPath: logsDirectory) {
            try? fileManager.createDirectory(atPath: logsDirectory,
                                             withIntermediateDirectories: true,
                                             attributes: nil)
        }

        return logsDirectory
    }
}
