//
//  WantedListActionCreator.swift
//  wantedAPI
//
//  Created by 逢坂 美芹 on 2022/08/13.
//

import Foundation
import Combine

final class WantedListActionCreator: CombineActionable {
    enum Action: ActionType {
        case updateItem([Item])
        case failure
    }

    let dispatcher: DispatchableDispatcher
    private var cancellableSet: Set<AnyCancellable> = []

    let fetchWantedList = PassthroughSubject<Void, Never>()

    init(
        dispatcher: DispatchableDispatcher = .init(),
        api: WantedAPI = WantedAPIImpl()
    ) {
        self.dispatcher = dispatcher

        fetchWantedList
            .sink { _ in
                api.getWantedList().eraseToAnyPublisher()
                    .sink { completion in
                        switch completion {
                        case .finished:
                            break

                        case .failure:
                            print("action-failure")
                            dispatcher.dispatch.send(Action.failure)
                        }
                    } receiveValue: { model in
                        dispatcher.dispatch.send(Action.updateItem(model.items))
                    }
                    .store(in: &self.cancellableSet)
            }
            .store(in: &cancellableSet)
    }
}
