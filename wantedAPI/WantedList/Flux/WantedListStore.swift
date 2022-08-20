//
//  WantedListStore.swift
//  wantedAPI
//
//  Created by 逢坂 美芹 on 2022/08/13.
//

import Combine

final class WantedListStore: CombineStorable {
    typealias Action = WantedListActionCreator.Action

    private var cancellableSet: Set<AnyCancellable> = []
    let dispatcher: RegisterableDispatcher

    @Published private(set) var list: [Item]?
    @Published private(set) var failure: Void?

    init(
        dispatcher: RegisterableDispatcher = .init()
    ) {
        self.dispatcher = dispatcher

        dispatchedAction
            .sink(receiveValue: { [weak self] action in
                switch action {
                case .updateItem(let list):
                    self?.list = list

                case .failure:
                    self?.failure = ()
                }
            })
            .store(in: &cancellableSet)
    }
}
