//
//  ProfileViewModel.swift
//  TSUAbiturient
//

import Foundation

protocol ProfileViewModelDelegate: AnyObject {
  func profileViewModelDidRequestToShowAuth(_ profileViewModel: ProfileViewModel)
}

final class ProfileViewModel: DataLoadingViewModel, DataStoreSubscriber {
  typealias Dependencies = HasDataStore & HasOAuthService & HasEducationProgramsService
  // MARK: - Properties
  
  weak var delegate: ProfileViewModelDelegate?
  
  var onDidStartRequest: (() -> Void)?
  var onDidFinishRequest: (() -> Void)?
  var onDidLoadData: (() -> Void)?
  var onDidReceiveError: ((Error) -> Void)?
  
  var onDidUpdateProfile: ((ProfileViewState) -> Void)?
  // MARK: - Init
  
  private let dependencies: Dependencies
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    dependencies.dataStore.observer.subscribe(self)
  }
  
  deinit {
    dependencies.dataStore.observer.unsubscribe(self)
  }
  
  // MARK: - Public methods
  
  func update(event: DataStoreEvent) {
    switch event {
    case .userProfileUpdated:
      loadData()
    }
  }
  
  func loadData() {
    onDidStartRequest?()
    
    if dependencies.oAuthService.isAuthorized, let userProfile = dependencies.dataStore.userProfile {
      onDidUpdateProfile?(.haveName(userProfile.firstName))
      guard let requestID = userProfile.requestID else {
        onDidUpdateProfile?(.noPriorities)
        onDidLoadData?()
        onDidFinishRequest?()
        return
      }
      getUserSpecializations(requestID: requestID, accoundID: userProfile.tsuAccountID)
    } else {
      onDidUpdateProfile?(.unauthorized)
      onDidLoadData?()
      onDidFinishRequest?()
    }
  }
  
  func tapOnLogin() {
    delegate?.profileViewModelDidRequestToShowAuth(self)
  }
  
  // MARK: - Private methods
  
  private func getUserSpecializations(requestID: String, accoundID: String) {
    Task {
      do {
        let programs = try await dependencies.educationProgramsService.getEducationPrograms(for: requestID)
        let rating = try await dependencies.educationProgramsService.getPriorityPrograms(accountID: accoundID)
        await MainActor.run {
          handleRatings(rating.data, with: programs.data)
        }
      } catch {
        await MainActor.run {
          dependencies.oAuthService.logoutFromTSUAccount()
        }
        
      }
    }
  }
  
  private func handleRatings(_ ratings: [RatingProgram], with programs: [EducationProgram]) {
    var newPrograms = programs.compactMap { program in
      if let rating = ratings.first(where: { rating in
        rating.curriculumID == program.educationProgram.curriculumID &&
        rating.budgetType.rawValue == program.educationBase.rawValue
      }) {
        return RatingDirection(type: rating.budgetType,
                               name: program.educationProgram.speciality.name,
                               faculty: program.educationProgram.faculty.name,
                               priority: program.priority,
                               place: rating.place,
                               color: rating.color)
      } else {
        return nil
      }
    }
    
    newPrograms = newPrograms
      .sorted { $0.priority < $1.priority }
      .sorted { $0.type.priorityForSort < $1.type.priorityForSort }
    
    let result = Array(newPrograms.prefix(5))
    
    if result.isEmpty {
      onDidUpdateProfile?(.noPriorities)
      onDidLoadData?()
      onDidFinishRequest?()
      return
    }
                                                 
    onDidUpdateProfile?(.authorized(result))
    onDidLoadData?()
    onDidFinishRequest?()
  }
}
