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
    
    enum PinType: String {
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
    
    static var pinTypeName: [PinType: String] = [
        .art: "art",
        .basketball: "basketball",
        .blockupy: "blockupy",
        .clownIn: "clownIn",
        .copWatch: "copWatch",
        .cosplay: "cosplay",
        .cycle: "cycle",
        .dance: "dance",
        .dieIn: "dieIn",
        .drift: "drift",
        .drum: "drum",
        .film: "film",
        .games: "games",
        .gardening: "gardening",
        .gaze: "gaze",
        .hugIn: "hugIn",
        .imaginarium: "imaginarium",
        .infoShop: "infoShop",
        .jailSolidarity: "jailSolidarity",
        .link: "link",
        .listen: "listen",
        .magic: "magic",
        .meditate: "meditate",
        .monkeyBiz: "monkeyBiz",
        .music: "music",
        .noise: "noise",
        .occupy: "occupy",
        .openMic: "openMic",
        .organize: "organize",
        .parkour: "parkour",
        .party: "party",
        .perform: "perform",
        .play: "play",
        .protest: "protest",
        .readIn: "readIn",
        .sing: "sing",
        .sitIn: "sitIn",
        .skate: "skate",
        .skillsShare: "skillsShare",
        .slowJam: "slowJam",
        .strike: "strike",
        .teachIn: "teachIn",
        .thinkIn: "thinkIn",
        .vigil: "vigil",
        .volunteer: "volunteer",
        .wildlifeWatch: "wildlifeWatch",
        .workout: "workout",
        .yoga: "yoga"
    ]
    
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
    
    static var pinTypePinImage: [PinType: UIImage] = [
        .art: #imageLiteral(resourceName: "art-pin"),
        .basketball: #imageLiteral(resourceName: "basketball-pin"),
        .blockupy: #imageLiteral(resourceName: "blockupy-pin"),
        .clownIn: #imageLiteral(resourceName: "clown-in-pin"),
        .copWatch: #imageLiteral(resourceName: "cop-watch-pin"),
        .cosplay: #imageLiteral(resourceName: "cosplay-pin"),
        .cycle: #imageLiteral(resourceName: "cycle-pin"),
        .dance: #imageLiteral(resourceName: "dance-pin"),
        .dieIn: #imageLiteral(resourceName: "die-in-pin"),
        .drift: #imageLiteral(resourceName: "drift-pin"),
        .drum: #imageLiteral(resourceName: "drum-pin"),
        .film: #imageLiteral(resourceName: "film-pin"),
        .games: #imageLiteral(resourceName: "games-pin"),
        .gardening: #imageLiteral(resourceName: "gardening-pin"),
        .gaze: #imageLiteral(resourceName: "gaze-pin"),
        .hugIn: #imageLiteral(resourceName: "hug-in-pin"),
        .imaginarium: #imageLiteral(resourceName: "imaginarium-pin"),
        .infoShop: #imageLiteral(resourceName: "infoshop-pin"),
        .jailSolidarity: #imageLiteral(resourceName: "jail-solidarity-pin"),
        .link: #imageLiteral(resourceName: "link-pin"),
        .listen: #imageLiteral(resourceName: "link-pin"),                                 // TODO: Missing
        .magic: #imageLiteral(resourceName: "magic-pin"),
        .meditate: #imageLiteral(resourceName: "meditate-pin"),
        .monkeyBiz: #imageLiteral(resourceName: "monkey-biz-pin"),
        .music: #imageLiteral(resourceName: "music-pin"),
        .noise: #imageLiteral(resourceName: "noise-pin"),
        .occupy: #imageLiteral(resourceName: "occupy-pin"),
        .openMic: #imageLiteral(resourceName: "openmic-pin"),
        .organize: #imageLiteral(resourceName: "organize-pin"),
        .parkour: #imageLiteral(resourceName: "parkour-pin"),
        .party: #imageLiteral(resourceName: "party-pin"),
        .perform: #imageLiteral(resourceName: "perform-pin"),
        .play: #imageLiteral(resourceName: "play-pin"),
        .protest: #imageLiteral(resourceName: "protest-pin"),
        .readIn: #imageLiteral(resourceName: "read-in-pin"),
        .sing: #imageLiteral(resourceName: "sing-pin"),
        .sitIn: #imageLiteral(resourceName: "sit-in-pin"),
        .skate: #imageLiteral(resourceName: "skate-pin"),
        .skillsShare: #imageLiteral(resourceName: "skills-share-pin"),
        .slowJam: #imageLiteral(resourceName: "slow-jam-pin"),
        .strike: #imageLiteral(resourceName: "strike-pin"),
        .teachIn: #imageLiteral(resourceName: "teach-in-pin"),
        .thinkIn: #imageLiteral(resourceName: "think-in-pin"),
        .vigil: #imageLiteral(resourceName: "vigil-pin"),
        .volunteer: #imageLiteral(resourceName: "volunteer-pin"),
        .wildlifeWatch: #imageLiteral(resourceName: "wildlifewatch-pin"),
        .workout: #imageLiteral(resourceName: "workout-pin"),
        .yoga: #imageLiteral(resourceName: "yoga-pin")
    ]
}
