//
//  URLFactory.swift
//  TSUAbiturient
//

import Foundation

enum URLFactory {
  private static let baseAbiturientURL = "https://abiturient.tsu.ru/enrollee/api"
  private static let baseLKSURL = "https://lks.tsu.ru/api"
  
  enum News {
    static let news = baseAbiturientURL + "/news"
  }
  
  enum Events {
    static let events = baseLKSURL + "/events"
  }
  
  enum EducationPrograms {
    static let educationPrograms = baseLKSURL + "/lka-account/education-programs/"
    static func priorityPrograms(accountID: String) -> String {
      return baseLKSURL + "/lka-account/\(accountID)/rating"
    }
  }
  enum Auth {
    static let oAuthPage = "https://accounts.tsu.ru/Account/Login2/?applicationId=1053"
    static let loginTsuAccount = baseLKSURL + "/auth/tsu-account"
  }
  
  enum User {
    static let userProfileLKS = baseLKSURL + "/user"
    static func userProfileLKA(accountID: String) -> String {
      return baseLKSURL + "/lka-account/\(accountID)"
    }
    static func educationPrograms(requestID: String) -> String {
      return baseLKSURL + "/lka-account/education-programs/\(requestID)"
    }
  }
  
  enum Directions {
    static let calculatorDirections = baseAbiturientURL + "/calculator"
    static let calculatorDisciplines = baseAbiturientURL + "/calculator/disciplines"
  }
}
