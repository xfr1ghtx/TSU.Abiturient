//
//  DataRequest+Promise.swift
//  TSUAbiturient
//

import Foundation
import Alamofire

extension DataRequest {
  func responseDataAsync() async -> AFDataResponse<Data> {
    return await withCheckedContinuation { continuation in
      responseData { response in
        continuation.resume(returning: response)
      }
    }
  }
}
