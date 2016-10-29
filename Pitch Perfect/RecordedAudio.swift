//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Adland Lee on 1/26/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation

class RecordedAudio {
    var filePathURL: URL!
    var title: String!
    
    init (title: String, filePathURL: URL) {
        self.title = title
        self.filePathURL = filePathURL
    }
}
