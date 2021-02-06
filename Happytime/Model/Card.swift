//
//  Card.swift
//  Happytime
//
//  Created by Shinya on 2021/01/14.
//

import SwiftUI
import RealmSwift

class Card: Object,Identifiable {
    
    @objc dynamic var id:Date = Date()
    @objc dynamic var feeling = ""
    @objc dynamic var detail = ""
    @objc dynamic var targetDate = Date()
}
