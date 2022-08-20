//
//  WantedAPI.swift
//  wantedAPI
//
//  Created by 逢坂 美芹 on 2022/08/13.
//

import Foundation
import Combine

protocol WantedAPI {
    func getWantedList() -> Future<Model, APIError>
}

final class WantedAPIImpl: WantedAPI {
    private var cancellableSet: Set<AnyCancellable> = []

    func getWantedList() -> Future<Model, APIError> {
        return Future<Model, APIError> { result in
            self.fetchWantedList().sink { completion in
                switch completion {
                case .failure:
                    result(.failure(APIError.internalServerError))

                case .finished:
                    print("Finished")
                }
            } receiveValue: { list in
                result(.success(list))
            }
            .store(in: &self.cancellableSet)
        }
    }

    func fetchWantedList() -> AnyPublisher<Model, Error> {
        let url = URL(string: "https://api.fbi.gov/wanted/v1/list")!

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap() { element -> Data in
                guard
                    let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200
                else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: Model.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
