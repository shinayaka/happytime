//
//  DBViewModel.swift
//  Happytime
//
//  Created by Shinya on 2021/01/14.
//

import SwiftUI
import RealmSwift

class DBViewModel: ObservableObject {
    
    // Data
    @Published var feeling = ""
    @Published var detail = ""
    @Published var targetDate = Date()
    
    @Published var openNewPage = false
    
    @Published var displayedDate = Date()
    
    // Fetched Data
    @Published var cards: [Card] = []
    
    @Published var targetDates: [Date] = []
    
    @Published var updateObject: Card?
    
    init() {
        // Realm Migration
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        fetchData()
        print(targetDates)
    }
    
    func fetchData() {
        
        guard let dbRef = try? Realm() else {return}
        
        let results = dbRef.objects(Card.self)
            .filter("targetDate >= %@ and targetDate <= %@", displayedDate.startOfMonth, displayedDate.endOfMonth)
            .sorted(byKeyPath: "targetDate")
        self.cards = results.compactMap({ (card) -> Card? in
            return card
        })
        
//        let results2 = dbRef.objects(Card.self).value(forKey: "targetDate") as! [Date]
//        self.targetDates = results2
        
    }
    
    func addData(presentation: Binding<PresentationMode>) {
        let card = Card()
        card.feeling = feeling
        card.detail = detail
        card.targetDate = targetDate
        
        // Getting Reference
        guard let dbRef = try? Realm() else {return}
        
        try? dbRef.write{
            guard let availableObject = updateObject else {
                
                dbRef.add(card)
                return
            }
            availableObject.feeling = feeling
            availableObject.detail = detail
            availableObject.targetDate = targetDate
        }
        displayedDate = targetDate
        // Updating UI
        fetchData()
        
        
        // Closing View
        presentation.wrappedValue.dismiss()
        
    }
    
    func deleteData(card: Card) {
        
        // Getting Reference
        guard let dbRef = try? Realm() else {return}
        
        try? dbRef.write{
            dbRef.delete(card)
            
            // Updating UI
            fetchData()
        }

    }
    
    func setUpInitialData() {
        guard let updateData = updateObject else{return}
        
        feeling = updateData.feeling
        detail = updateData.detail
        targetDate = updateData.targetDate
    }
    
    func deInitData() {
        updateObject = nil
        feeling = ""
        detail = ""
        targetDate = Date()
    }
    
    func fetchPrevMonth() {
        self.displayedDate = Calendar.current.date(byAdding: .month, value: -1, to: displayedDate)!
        
        fetchData()
    }
    
    func fetchNextMonth() {
        self.displayedDate = Calendar.current.date(byAdding: .month, value: 1, to: displayedDate)!
        
        fetchData()
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }

    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
}
