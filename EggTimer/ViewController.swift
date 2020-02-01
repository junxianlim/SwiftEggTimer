//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    let defaultTitle = "How do you like your eggs?"
    var player: AVAudioPlayer!
    var currentTimer: Timer?
    let boilTimers: [String:Int] = [
        "Soft": 5,
        "Medium": 7,
        "Hard": 12,
    ]
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBAction func hardnessSelected(_ sender: UIButton) {
        // Invalid exiting timer
        currentTimer?.invalidate()
        
        // Reset progress bar
        progressBar.progress = 0
        
        // Set total seconds required to boil egg
        let secondsToBoil = self.boilTimers[sender.currentTitle!]! * 60
        
        // Reset seconds in progress
        var secondsInProgress = 0
        
        // Set title to inform user of type of egg being boiled
        self.timerLabel.text = "Currently boiling for \(sender.currentTitle!) eggs"
        
        // Initialize new timer
        self.currentTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            secondsInProgress += 1
            
            // Update progress bar
            self.progressBar.setProgress(Float(secondsInProgress) / Float(secondsToBoil), animated: true)
            
            // Completion
            if (self.progressBar.progress >= 1.0) {
                self.playSound(soundName: "alarm_sound")
                timer.invalidate()
                self.timerLabel.text = "All done!"
                // Reset title to question after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.timerLabel.text = self.defaultTitle
                }
            }
        }
    }
    
    func playSound(soundName: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
}
