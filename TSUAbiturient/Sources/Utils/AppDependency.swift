//
//  AppDependency.swift
//  TSUAbiturient
//

import Foundation
import Alamofire

protocol HasNewsService {
  var newsService: NewsNetworkProtocol { get }
}

protocol HasEventsService {
  var eventsService: EventsNetworkProtocol { get }
}

protocol HasFacultiesService {
  var facultiesService: FacultiesRemoteDataProtocol { get }
}

protocol HasBuildingsService {
  var buildingsService: BuildingsRemoteDataProtocol { get }
}

protocol HasEducationProgramsService {
  var educationProgramsService: EducationProgramsProtocol { get }
}

protocol HasUserService {
  var userService: UserNetworkProtocol { get }
}

protocol HasOAuthService {
  var oAuthService: OAuthServiceProtocol & OAuthAuthenticatorDelegate { get }
}

protocol HasDataStore {
  var dataStore: DataStoreProtocol { get }
}

protocol DirectionsService {
  var directionsService: EducationDirectionsProtocol { get }
}

protocol DisciplinesService {
  var disciplinesService: DisciplinesProtocol { get }
}
class AppDependency: HasOAuthService {
  let oAuthService: OAuthAuthenticatorDelegate & OAuthServiceProtocol
  let dataStoreService: DataStoreService
  
  private let networkService: NetworkService
  private let storageService: StorageService
  private let remoteDataService: RemoteDataService
  private let oAuthAuthenticator: OAuthAuthenticator
  private let authenticationInterceptor: AuthenticationInterceptor<OAuthAuthenticator>
  private let keyChainService: KeyChainServiceProtocol
  
  init() {
    keyChainService = KeyChainService()
    dataStoreService = DataStoreService()
    oAuthAuthenticator = OAuthAuthenticator()
    authenticationInterceptor = AuthenticationInterceptor(authenticator: oAuthAuthenticator,
                                                          credential: nil,
                                                          refreshWindow: nil)
    networkService = NetworkService(authenticationInterceptor: authenticationInterceptor)
    oAuthService = OAuthService(authNetworkProtocol: networkService,
                                userNetworkProtocol: networkService,
                                keyChainService: keyChainService,
                                dataStoreService: dataStoreService)
    oAuthAuthenticator.delegate = oAuthService
    storageService = StorageService()
    remoteDataService = RemoteDataService()
  }
}

// MARK: - HasUserService

extension AppDependency: HasUserService {
  var userService: UserNetworkProtocol {
    networkService
  }
}

// MARK: - HasNewsService

extension AppDependency: HasNewsService {
  var newsService: NewsNetworkProtocol {
    networkService
  }
}

// MARK: - HasFacultiesService

extension AppDependency: HasFacultiesService {
  var facultiesService: FacultiesRemoteDataProtocol {
    remoteDataService
  }
}

// MARK: - HasBuildingsService

extension AppDependency: HasBuildingsService {

  var buildingsService: BuildingsRemoteDataProtocol {
    remoteDataService
  }
}

// MARK: - HasEventsService

extension AppDependency: HasEventsService {
  var eventsService: EventsNetworkProtocol {
	networkService
  }
}

// MARK: - DirectionsService

extension AppDependency: DirectionsService {
  var directionsService: EducationDirectionsProtocol {
    networkService
  }
}

// MARK: - HasEducationProgramsService

extension AppDependency: HasEducationProgramsService {
  var educationProgramsService: EducationProgramsProtocol {
    networkService
  }
}

// MARK: - HasDataStore

extension AppDependency: HasDataStore {
  var dataStore: DataStoreProtocol {
    dataStoreService
  }
}

// MARK: - DisciplinesService

extension AppDependency: DisciplinesService {
  var disciplinesService: DisciplinesProtocol {
    networkService
  }
}
