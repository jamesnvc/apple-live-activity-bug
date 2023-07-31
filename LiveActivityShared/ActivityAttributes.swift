//
//  ActivityAttributes.swift
//  LiveActivityShared
//
//  Created by James Cash on 2023-07-31.
//

import Foundation
import ActivityKit

public struct TestingBugAttributes: ActivityAttributes {
    public typealias Status = ContentState
    
    public struct ContentState: Codable, Hashable {
        public init(value: Int) {
            self.value = value
        }
        
        public var value: Int
    }
    
    public init() { }
}
