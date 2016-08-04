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
    
    /*
     MISSION REPORT:
    1) Get 7 flames
     2) Get 7 lanterns
     3) Deploy 1 mega lantern
     4) Deploy 5 mega Lantern
     5) Cross distance of 150
     6) Collect 25 flames
     7) Slide under 15 trees
     8) Jump 200 times
     9) Slide 100 times
     10) Buy powerup from pack
    */
    func getMission(number : Int) -> String
    {
        switch number {
        case 1:
            print("Get 7 flames")
            return "Get 7 flames"
        case 2:
            print("Get 7 lanterns")
            return "Get 7 lanterns"
        case 3:
            print("Deploy 1 mega lantern")
            return "Deploy 1 mega lantern"
        case 4:
            print("Deploy 5 mega Lantern")
            return "Deploy 5 mega Lantern"
        case 5:
            print("Cross distance of 150")
            return "Cross distance of 150"
        case 6:
            print("Collect 25 flames")
            return "Collect 25 flames"
        case 7:
            print("Slide under 15 trees")
            return "Slide under 15 trees"
        case 8:
            print("Jump 200 times")
            return "Jump 200 times"
        case 9:
            print("Slide 100 times")
            return "Slide 100 times"
        case 10:
            print("Buy powerup from pack")
            return "Buy powerup from pack"
        default:
            return " "
        }
    }
    
    func missionCheck(missionNumber: Int, value: Int) -> Bool
    {
        //var checkInt = missionNumber % 4
        switch missionNumber {
        case 1:
            if value >= 7
            {
                return true
            }
            else
            {
                return false
            }
        case 2:
            if value >= 7
            {
                return true
            }
            else{
                return false
            }
        case 3:
            if value >= 1
            {
                return true
            }
            else
            {
                return false
            }
        case 4:
            if value >= 5
            {
                return true
            }
            else
            {
                return false
            }
        case 5:
            if value >= 150
            {
                return true
            }
            else{
                return false
            }
        case 6:
            if value >= 25
            {
                return true
            }
            else
            {
            return false
            }
        case 7:
            if value >= 15
            {
                return true
            }
            else
            {
                return false
            }
        case 8:
            if value >= 200
            {
                return true
            }
            else
            {
                return false
            }
        case 9:
            if value >= 100
            {
                return true
            }
            else
            {
                return false
            }
        default:
            if value == 1   //pack bought
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