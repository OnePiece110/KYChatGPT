//
//  KYOpenAISwift.swift
//  KYChatGPT
//
//  Created by Keyon on 2023/2/15.
//

import Foundation

public enum KYOpenAIError: Error {
    case genericError(error: Error)
    case decodingError(error: Error)
}

public class KYOpenAISwift {
    fileprivate(set) var token: String?
    
    public init(authToken: String) {
        self.token = authToken
    }
}

extension KYOpenAISwift {
    
    public func sendCompletion(with prompt: String, model: KYOpenAIModelType = .gpt3(.davinci), maxTokens: Int = 16, completionHandler: @escaping (Result<KYOpenAIChatModel, KYOpenAIError>) -> Void) {
        let endpoint = KYEndpoint.completions
        let body = KYCommand(prompt: prompt, model: model.modelName, maxTokens: maxTokens)
        let request = prepareRequest(endpoint, body: body)
        
        makeRequest(request: request) { result in
            switch result {
            case .success(let success):
                do {
                    let res = try JSONDecoder().decode(KYOpenAIChatModel.self, from: success)
                    completionHandler(.success(res))
                } catch {
                    completionHandler(.failure(.decodingError(error: error)))
                }
            case .failure(let failure):
                completionHandler(.failure(.genericError(error: failure)))
            }
        }
    }
    
    public func sendEdits(with instruction: String, model: KYOpenAIModelType = .feature(.davinci), input: String = "", completionHandler: @escaping (Result<KYOpenAIChatModel, KYOpenAIError>) -> Void) {
        let endpoint = KYEndpoint.edits
        let body = KYInstruction(instruction: instruction, model: model.modelName, input: input)
        let request = prepareRequest(endpoint, body: body)
        
        makeRequest(request: request) { result in
            switch result {
            case .success(let success):
                do {
                    let res = try JSONDecoder().decode(KYOpenAIChatModel.self, from: success)
                    completionHandler(.success(res))
                } catch {
                    completionHandler(.failure(.decodingError(error: error)))
                }
            case .failure(let failure):
                completionHandler(.failure(.genericError(error: failure)))
            }
        }
    }
    
    private func makeRequest(request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                completionHandler(.success(data))
            }
        }
        
        task.resume()
    }
    
    private func prepareRequest<BodyType: Encodable>(_ endpoint: KYEndpoint, body: BodyType) -> URLRequest {
        var urlComponents = URLComponents(url: URL(string: endpoint.baseURL())!, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpoint.path
        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = endpoint.method
        request.timeoutInterval = 60
        
        if let token = self.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(body) {
            request.httpBody = encoded
        }
        
        return request
    }
}

extension KYOpenAISwift {
    public func sendCompletion(with prompt: String, model: KYOpenAIModelType = .gpt3(.davinci), maxTokens: Int = 16) async throws -> KYOpenAIChatModel {
        return try await withCheckedThrowingContinuation { continuation in
            sendCompletion(with: prompt, model: model, maxTokens: maxTokens) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    public func sendEdits(with instruction: String, model: KYOpenAIModelType = .feature(.davinci), input: String = "", completionHandler: @escaping (Result<KYOpenAIChatModel, KYOpenAIError>) -> Void) async throws -> KYOpenAIChatModel {
        return try await withCheckedThrowingContinuation { continuation in
            sendEdits(with: instruction, model: model, input: input) { result in
                continuation.resume(with: result)
            }
        }
    }
}
