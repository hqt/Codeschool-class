//
//  DataBaseUtils.swift
//  TwitterClient
//
//  Created by Huynh Quang Thao on 3/27/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit
import Realm

class DataBaseUtils: NSObject {
    
    static func saveUser(user: User) {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        realm.addOrUpdateObject(user)
        try! realm.commitWriteTransaction()
    }
    
    static func removeUser(user: User) {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        realm.deleteObject(user)
        try! realm.commitWriteTransaction()
    }
    
    static func getSignedInUser() -> User? {
        return User.allObjects().firstObject() as? User

    }
}
