//
//  HapticsManager.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 10/2/24.
//

import Foundation
import UIKit

fileprivate final class HapticsManager {
    // Declare a singleton
    static let shared = HapticsManager()
    
    // Implement Haptics
    private let feedback = UINotificationFeedbackGenerator()
    
    private init() {}
    
    func trigger(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
        feedback.notificationOccurred(notification)
    }
}

// Create a share instance to use in another views
func haptic(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
    // If true then enable the haptics.
    if UserDefaults.standard.bool(forKey: UserDefaultKeys.isHapticsEnabled) {
        HapticsManager.shared.trigger(notification)
    }
}
