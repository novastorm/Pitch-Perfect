//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Adland Lee on 1/26/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation

class RecordedAudio {
    var filePathURL: NSURL!
    var title: String!
    
    init (title: String, filePathURL: NSURL) {
        self.title = title
        self.filePathURL = filePathURL
    }
}