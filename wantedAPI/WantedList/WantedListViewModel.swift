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

    // input
    let viewDidLoad = PassthroughSubject<Void, Never>()
    let state = PassthroughSubject<State, Never>()
    // let refresh = PassthroughSubject<Void, Never>()
    // let dismissAlert = PassthroughSubject<Void, Never>()

    // output
    @Published private(set) var list: [Item]?
    @Published private(set) var failure: Void?
    @Published private(set) var reload: Void?

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
//            .map { list -> [Item] in
//                guard let list = list else { return [] }
//                print("vm-list\(list)")
//                return list.map { list in
//                        .init(rewardText: <#T##String?#>,
//                              url: <#T##String#>,
//                              details: <#T##String?#>,
//                              gender: <#T##Gender?#>,
//                              rewardMax: <#T##Int#>,
//                              rewardMin: <#T##Int#>,
//                              modified: <#T##Date#>,
//                              itemDescription: <#T##String#>,
//                              ageRange: <#T##String?#>,
//                              title: <#T##String#>,
//                              files: <#T##[Name : String]#>,
//                              images: <#T##[Image]#>,
//                              uid: <#T##String#>,
//                              path: <#T##String#>,
//                              subjects: <#T##[String]#>,
//                              id: <#T##String#>)
//                }
//            }
            .sink { [weak self] in
                self?.list = $0

            }
            .store(in: &cancellabbleSet)

        store.$failure
            .sink { [weak self] in
                self?.failure = $0
                self?.showErrorAlert
            }
            .store(in: &cancellabbleSet)
    }
}
