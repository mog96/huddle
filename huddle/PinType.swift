//
//  PinType.swift
//  huddle
//
//  Created by Mateo Garcia on 3/27/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit

class PinType: NSObject {
    static var kNumPinTypes: Int {
        get {
            return pinTypeImage.count
        }
    }
    
    enum PinType {
        case art
        case basketball
        case blockupy
        case clownIn
        case copWatch
        case cosplay
        case cycle
        case dance
        case dieIn
        case drift
        case drum
        case film
        case games
        case gardening
        case gaze
        case hugIn
        case imaginarium
        case infoShop
        case jailSolidarity
        case link
        case listen
        case magic
        case meditate
        case monkeyBiz
        case music
        case noise
        case occupy
        case openMic
        case organize
        case parkour
        case party
        case perform
        case play
        case protest
        case readIn
        case sing
        case sitIn
        case skate
        case skillsShare
        case slowJam
        case strike
        case teachIn
        case thinkIn
        case vigil
        case volunteer
        case wildlifeWatch
        case workout
        case yoga
    }
    
    static var pinTypeImage: [PinType: UIImage] = [
        .art: #imageLiteral(resourceName: "art"),
        .basketball: #imageLiteral(resourceName: "basketball"),
        .blockupy: #imageLiteral(resourceName: "blockupy"),
        .clownIn: #imageLiteral(resourceName: "clown-in"),
        .copWatch: #imageLiteral(resourceName: "cop-watch"),
        .cosplay: #imageLiteral(resourceName: "cosplay"),
        .cycle: #imageLiteral(resourceName: "cycle"),
        .dance: #imageLiteral(resourceName: "dance"),
        .dieIn: #imageLiteral(resourceName: "die-in"),
        .drift: #imageLiteral(resourceName: "drift"),
        .drum: #imageLiteral(resourceName: "drum"),
        .film: #imageLiteral(resourceName: "film"),
        .games: #imageLiteral(resourceName: "games"),
        .gardening: #imageLiteral(resourceName: "gardening"),
        .gaze: #imageLiteral(resourceName: "gaze"),
        .hugIn: #imageLiteral(resourceName: "hug-in"),
        .imaginarium: #imageLiteral(resourceName: "imaginarium"),
        .infoShop: #imageLiteral(resourceName: "infoshop"),
        .jailSolidarity: #imageLiteral(resourceName: "jail-solidarity"),
        .link: #imageLiteral(resourceName: "link"),
        .listen: #imageLiteral(resourceName: "listen"),
        .magic: #imageLiteral(resourceName: "magic"),
        .meditate: #imageLiteral(resourceName: "meditate"),
        .monkeyBiz: #imageLiteral(resourceName: "monkey-biz"),
        .music: #imageLiteral(resourceName: "music"),
        .noise: #imageLiteral(resourceName: "noise"),
        .occupy: #imageLiteral(resourceName: "occupy"),
        .openMic: #imageLiteral(resourceName: "openmic"),
        .organize: #imageLiteral(resourceName: "organize"),
        .parkour: #imageLiteral(resourceName: "parkour"),
        .party: #imageLiteral(resourceName: "party"),
        .perform: #imageLiteral(resourceName: "perform"),
        .play: #imageLiteral(resourceName: "play"),
        .protest: #imageLiteral(resourceName: "protest"),
        .readIn: #imageLiteral(resourceName: "read-in"),
        .sing: #imageLiteral(resourceName: "sing"),
        .sitIn: #imageLiteral(resourceName: "sit-in"),
        .skate: #imageLiteral(resourceName: "skate"),
        .skillsShare: #imageLiteral(resourceName: "skills-share"),
        .slowJam: #imageLiteral(resourceName: "slow-jam"),
        .strike: #imageLiteral(resourceName: "strike"),
        .teachIn: #imageLiteral(resourceName: "teach-in"),
        .thinkIn: #imageLiteral(resourceName: "think-in"),
        .vigil: #imageLiteral(resourceName: "vigil"),
        .volunteer: #imageLiteral(resourceName: "volunteer"),
        .wildlifeWatch: #imageLiteral(resourceName: "wildlifewatch"),
        .workout: #imageLiteral(resourceName: "workout"),
        .yoga: #imageLiteral(resourceName: "yoga")
    ]
}
