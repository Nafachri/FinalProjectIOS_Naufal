//
//  Greetings.swift
//  Utils
//
//  Created by Naufal Al-Fachri on 27/08/24.
//
import Foundation
import UIKit

public extension UILabel {
    func setGreeting() {
        let currentHour = Calendar.current.component(.hour, from: Date())
        let greeting: String
        
        switch currentHour {
        case 0..<12:
            greeting = "good morning"
        case 12..<17:
            greeting = "good afternoon"
        case 17..<24:
            greeting = "good evening"
        default:
            greeting = "hello"
        }
        
        self.text = greeting
    }
}
