//
//  MissionReport.swift
//  RunAway
//
//  Created by Nityam Shrestha on 8/2/16.
//  Copyright © 2016 nityamshrestha.com. All rights reserved.
//

import Foundation

class MissionReport{
    
//    var name = ""
//    init(name: String)
//    {
//        self.name = name;
//    }
    func getMission(number : Int) -> String
    {
        switch number {
        case 1:
            print("Collect 20 flames in one game")
            return "Collect 20 flames in one game "
            break
        case 2:
            print("Collect  10 regular lantern in one game")
            return "Collect  10 regular lantern in one game"
        case 3:
            print("Activate 3 ruper lantern in one game")
            return "Activate 3 ruper lantern in one game"
        case 4:
            print("Slide for 20 points in one game")
            return "Slide for 20 points in one game"
        default:
            return "Invalid mission number"
        }
    }
    
    func missionCheck(missionNumber: Int, value: Int) -> Bool
    {
        //var checkInt = missionNumber % 4
        switch missionNumber {
        case 1:
            if value == 20
            {
                return true
            }
            else
            {
                return false
            }
        case 2:
            if value == 10
            {
                return true
            }
            else{
                return false
            }
        case 3:
            if value == 3
            {
                return true
            }
            else
            {
                return false
            }
        default:
            if value == 20
            {
                return true
            }
            else
            {
                return false
            }
        }
    }
}