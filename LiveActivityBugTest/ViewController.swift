//
//  ViewController.swift
//  LiveActivityBugTest
//
//  Created by James Cash on 2023-07-31.
//

import UIKit
import AVFoundation
import ActivityKit

import LiveActivityShared

class ViewController: UIViewController {

    @IBOutlet weak var currentValueLabel: UILabel!
    
    var player: AVAudioPlayer? = nil
    
    var currentValue: Int = 0
    
    private var liveActivity: Activity<TestingBugAttributes>? = nil
    
    var timer: Timer! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .`default`, options: .mixWithOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let err {
            print("Unable to activate audio session: \(err.localizedDescription)")
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "silence", withExtension: "mp3")!)
            player!.numberOfLoops = -1
            player!.play()
        } catch let err {
            print("Unable to start playing audio \(err.localizedDescription)")
        }

        startLiveActivity()
        
        timer = Timer(timeInterval: 2, repeats: true, block: { _ in
            self.currentValue += 1
            OperationQueue.main.addOperation {
                self.currentValueLabel.text = "Current Value \(self.currentValue)"
            }
            
            Task { await self.updateLiveActivity() }


        })
        
        RunLoop.current.add(timer, forMode: .common)
    }
    
    fileprivate func startLiveActivity() {
        let activityAuth = ActivityAuthorizationInfo()
        print("activity enabled? \(activityAuth.areActivitiesEnabled)")
        let attrs = TestingBugAttributes()
        let content = createLiveActivityUpdateState()
        do {
            liveActivity = try Activity.request(attributes: attrs,
                                                content: ActivityContent(state: content, staleDate: nil))
        } catch let err {
            print("Unable to request activity: \(err.localizedDescription)")
        }
    }
    
    private func createLiveActivityUpdateState() -> Activity<TestingBugAttributes>.ContentState {
        return TestingBugAttributes.ContentState(
            value: currentValue
        )
    }
    
    func updateLiveActivity() async {
        if let activity = liveActivity {
            await activity.update(using: createLiveActivityUpdateState())
        }
    }
}

