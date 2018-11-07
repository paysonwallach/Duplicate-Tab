//
//  Logs.swift
//  Duplicate Tab
//
//  Created by Payson Wallach on 10/22/18.
//  Copyright © 2018 Payson Wallach. All rights reserved.
//

import Stenographer

struct Logs {
    static let shared = SXLogger(endpoints: [SXConsoleEndpoint()])
}
