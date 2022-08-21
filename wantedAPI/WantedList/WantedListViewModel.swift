//
//  WantedListViewModel.swift
//  wantedAPI
//
//  Created by 逢坂 美芹 on 2022/08/13.
//

import Foundation
import Combine

final class WantedListViewModel {
    enum State {
        case isRefresh(Bool)
        case isShowAlert(Bool)
    }

    struct SectionModel {
        let section: ViewController.Section
        let rows: [ViewController.Row]
    }

    // input
    let viewDidLoad = PassthroughSubject<Void, Never>()
    let state = PassthroughSubject<State, Never>()
    // let refresh = PassthroughSubject<Void, Never>()
    // let dismissAlert = PassthroughSubject<Void, Never>()

    // output
    @Published private(set) var sectionModels: [SectionModel] = []
    let failureFetchWantedList = PassthroughSubject<Void, Never>()
    // @Published private(set) var list: [Item]?
    // @Published private(set) var failure: Void?
    // @Published private(set) var reload: Void?

    private var cancellabbleSet: Set<AnyCancellable> = []
    private let actionCreator: WantedListActionCreator
    private let store: WantedListStore

    init(
        actionCreator: WantedListActionCreator = .init(),
        store: WantedListStore = .init()
    ) {
        self.actionCreator = actionCreator
        self.store = store

        viewDidLoad
            .sink {
                actionCreator.fetchWantedList.send()
            }
            .store(in: &cancellabbleSet)

        store.$list
            .map { repositories -> [SectionModel] in
                [.init(section: .wantedList, rows: repositories.map { .wantedList($0) })]
            }
            .sink { [weak self] in
                self?.sectionModels = $0
            }
            .store(in: &cancellabbleSet)

        store.failureFetchWantedList
            .sink { [weak self] in
                self?.failureFetchWantedList.send($0)
                // self?.showErrorAlert
            }
            .store(in: &cancellabbleSet)
    }
}
