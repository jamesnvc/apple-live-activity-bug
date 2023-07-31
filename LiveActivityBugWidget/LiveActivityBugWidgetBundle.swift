//
//  LiveActivityBugWidgetBundle.swift
//  LiveActivityBugWidget
//
//  Created by James Cash on 2023-07-31.
//

import WidgetKit
import SwiftUI

@main
struct LiveActivityBugWidgetBundle: WidgetBundle {
    var body: some Widget {
        LiveActivityBugWidget()
        LiveActivityBugWidgetLiveActivity()
    }
}
