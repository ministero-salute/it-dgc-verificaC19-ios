//
//  CRLDataStorage.swift
//  Verifier
//
//  Created by Andrea Prosseda on 25/08/21.
//

import Foundation
import RealmSwift

struct CRLDataStorage {

    private static var realm: Realm { try! Realm() }
    
    public static func store(crl: CRL) {
        let startTime = Log.start(key: "[CRL] [STORAGE]")
        if (crl.isSnapshot) { storeSnapshot(crl) }
        if (crl.isDelta)    { storeDelta(crl) }
        Log.end(key: "[CRL] [STORAGE]", startTime: startTime)
    }
    
    private static func storeSnapshot(_ crl: CRL) {
        clear()
        addAll(hashes: crl.revokedUcvi)
    }
    
    private static func storeDelta(_ crl: CRL) {
        addAll(hashes: crl.delta?.insertions)
        removeAll(hashes: crl.delta?.deletions)
    }
    
    public static func addAll(hashes: [String]?) {
        let storage = realm
        let dcc = hashes?.map { RevokedDCC(hash: $0) } ?? []
        guard !dcc.isEmpty else { return }
        try! storage.write { storage.add(dcc) }
    }
    
    public static func removeAll(hashes: [String]?) {
        let storage = realm
        let dcc = hashes?.map { RevokedDCC(hash: $0) } ?? []
        guard !dcc.isEmpty else { return }
        try! storage.write { storage.delete(dcc) }
    }
    
    public static func contains(hash: String) -> Bool {
        let storage = realm
        return storage
            .objects(RevokedDCC.self)
            .filter("hashedUVCI == %@", hash)
            .first != nil
    }
    
    public static func clear() {
        let storage = realm
        try! storage.write { storage.deleteAll() }
    }
    
    public static func add(hash: String, on storage: Realm) {
        let dcc = RevokedDCC(hash: hash)
        try! storage.write { storage.add(dcc) }
    }
    
    public static func remove(hash: String, on storage: Realm) {
        let dcc = RevokedDCC(hash: hash)
        try! storage.write { storage.delete(dcc) }
    }
    
}