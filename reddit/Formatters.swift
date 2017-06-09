//
//  Formatters.swift
//  reddit
//
//  Created by Jonathan Tran on 3/19/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import Foundation

func convertToScoreStringFrom(_ int: Int) -> String
{
    var score: String
    if (int >= 10000 && int <= 100000) {
        let tempString = String(int)
        let character = tempString[tempString.characters.startIndex]
        let index = tempString.index(tempString.characters.startIndex, offsetBy: 1)
        let secondCharacter = tempString[index]
        
        score = String()
        score.append(character)
        score.append(secondCharacter)
        score.append("k")
        
        
    } else if (int >= 1000) {
        
        let tempString = String(int)
        let character = tempString[tempString.characters.startIndex]
        
        score = String()
        score.append(character)
        score.append("k")
        
    } else {
        score = String(int)
    }
    
    return score
}

func convertToTimeStringFrom(_ seconds: Double) -> String {
    var timeString: String
    
    let minutes: Double = seconds / 60
    let hours: Double = minutes / 60
    let days: Double = hours / 24
    let months: Double = days / 30
    let years: Double = months / 12
    
    if (floor(years) >= 1) {
        timeString = String(Int(floor(years))) + "yr"
    } else if (ceil(minutes) < 60) {
        timeString = String(Int(ceil(minutes))) + "min"
    } else if (floor(hours) <= 24) {
        timeString = String(Int(floor(hours))) + "h"
    } else if (floor(days) <= 32) {
        timeString = String(Int(floor(days))) + "d"
    } else if (floor(months) <= 12) {
        timeString = String(Int(floor(months))) + "m"
    } else {
        timeString = "???"
    }
    return timeString
}
