//
//  CombineDispatcher.swift
//  wantedAPI
//
//  Created by 逢坂 美芹 on 2022/08/13.
//

import Combine

protocol ActionType {}

final class DispatchableDispatcher {
    let dispatch: PassthroughSubject<ActionType, Never>
    private var cancellableSet: Set<AnyCancellable> = []
    private let dispatcher: CombineDispatcher

    init(dispatcher: CombineDispatcher = .default) {
        self.dispatcher = dispatcher
        let dispatchSubject = PassthroughSubject<ActionType, Never>()
        dispatch = dispatchSubject
        dispatchSubject
            .sink { dispatcher.dispatch.send($0) }
            .store(in: &cancellableSet)
    }
}

final class RegisterableDispatcher {
    let register: AnyPublisher<ActionType, Never>
    private let dispatcher: CombineDispatcher

    init(dispatcher: CombineDispatcher = .default) {
        self.dispatcher = dispatcher
        register = dispatcher.register
    }
}

final class CombineDispatcher {
    public static let `default` = CombineDispatcher()

    fileprivate var dispatch: PassthroughSubject<ActionType, Never>
    fileprivate let register: AnyPublisher<ActionType, Never>

    init() {
        let dispatchSubject = PassthroughSubject<ActionType, Never>()

        dispatch = dispatchSubject
        register = dispatchSubject.eraseToAnyPublisher()
    }
}

protocol CombineActionable: AnyObject {
    var dispatcher: DispatchableDispatcher { get }
}

protocol CombineStorable: AnyObject {
    associatedtype Action: ActionType

    var dispatcher: RegisterableDispatcher { get }
    var dispatchedAction: AnyPublisher<Action, Never> { get }
}

extension CombineStorable {
    var dispatchedAction: AnyPublisher<Action, Never> {
        dispatcher.register
            .compactMap { $0 as? Action }
            .eraseToAnyPublisher()
    }
}
