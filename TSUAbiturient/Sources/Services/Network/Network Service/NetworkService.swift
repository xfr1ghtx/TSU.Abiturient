//
//  NetworkService.swift
//  TSUAbiturient
//

import Alamofire
import Foundation

class NetworkService {
  // MARK: - Properties
  
  let authenticationInterceptor: AuthenticationInterceptor<OAuthAuthenticator>
  
  // MARK: - Init
  
  init(authenticationInterceptor: AuthenticationInterceptor<OAuthAuthenticator>) {
    self.authenticationInterceptor = authenticationInterceptor
  }
  
  // MARK: - Make request
  
  func request<T: Decodable>(method: HTTPMethod,
                             url: URLConvertible,
                             authorized: Bool = false,
                             headers: HTTPHeaders? = nil,
                             parameters: Parameters? = nil) async throws -> T {
    let requestResponse = await AF.request(url,
                                           method: method,
                                           parameters: parameters,
                                           encoding: method == .get ?
                                           URLEncoding(arrayEncoding: .noBrackets) : JSONEncoding.default,
                                           headers: headers,
                                           interceptor: authorized ? authenticationInterceptor : nil)
      .responseDataAsync()
    
    return try await handleResponse(requestResponse)
  }
  
  // MARK: - Handle response
  
  private func handleResponse<T: Decodable>(_ response: AFDataResponse<Data>) async throws -> T {
    Task.detached(priority: .utility) { [weak self] in
      await self?.logResponse(response)
    }
    
    if case .failure(let error) = response.result {
      throw error.underlyingError ?? error
    }
    
    let statusCode: HTTPStatusCode
    if let code = response.response?.statusCode {
      statusCode = HTTPStatusCode(rawValue: code) ?? .internalServerError
    } else {
      statusCode = .internalServerError
    }
    
    switch statusCode {
    case .okStatus, .created, .accepted, .noContent:
      if let data = response.data {
        return try await decode(data, ofType: T.self)
      } else if T.self == EmptyResponse.self, let response = EmptyResponse() as? T {
        return response
      } else {
        throw NetworkServiceError.noData
      }
    default:
      throw NetworkServiceError.requestFailed
    }
  }
  
  // MARK: - Decoding data
  
  private func decode<T: Decodable>(_ data: Data, ofType type: T.Type) async throws -> T {
    do {
      let object = try JSONDecoder().decode(type.self, from: data)
      return object
    } catch {
      print(error)
      throw NetworkServiceError.failedToDecodeData
    }
  }
  
  // MARK: - Logging to console
  
  private func logResponse(_ response: AFDataResponse<Data>) async {
    print("----------------------------------------")
    print("\(response.request?.method?.rawValue ?? "") \(response.request?.url?.absoluteString ?? "")")
    print("----------------------------------------")
    switch response.result {
    case .success(let responseData):
      if let object = try? JSONSerialization.jsonObject(with: responseData, options: []),
         let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
         let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
        print(prettyPrintedString)
      }
    case .failure(let error):
      print(error)
    }
    print("----------------------------------------")
  }
}
