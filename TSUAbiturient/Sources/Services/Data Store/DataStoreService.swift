//
//  DataStoreService.swift
//  TSUAbiturient
//

import Foundation

class DataStoreService: DataStoreProtocol {
  private struct UserDefaultsKeys {
    static let userProfile = "userProfile"
  }
  
  let observer = DataStoreObserver()
  
  private let userDefaults = UserDefaults.standard
  
  // MARK: - UserDefaults
  
  var userProfile: UserProfile? {
    get {
      guard let data = userDefaults.data(forKey: UserDefaultsKeys.userProfile) else { return nil }
      return try? JSONDecoder().decode(UserProfile.self, from: data)
    }
    set {
      let data = (try? JSONEncoder().encode(newValue)) ?? Data()
      userDefaults.set(data, forKey: UserDefaultsKeys.userProfile)
      observer.notify(event: .userProfileUpdated)
    }
  }
  
  // MARK: - Public methods
  
  func clearAllData() {
    userProfile = nil
  }
}
