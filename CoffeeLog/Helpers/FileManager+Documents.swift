//
//  FileManager+Documents.swift
//  CoffeeLog
//
//  Created by Dev on 10/08/25.
//

import Foundation

extension FileManager {
    /// Returns the app's Documents directory URL
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
