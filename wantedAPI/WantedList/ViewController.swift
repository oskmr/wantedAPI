//
//  ViewController.swift
//  wantedAPI
//
//  Created by 逢坂 美芹 on 2022/08/13.
//

import UIKit
import Combine

final class ViewController: UIViewController {

    private var cancellableSet: Set<AnyCancellable> = []
    private let viewModel = WantedListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad.send()
        addPublisher()
    }

    private func addPublisher() {
        viewModel.$list
            .sink {
                print("vc-\($0)")
            }
            .store(in: &cancellableSet)

        viewModel.$failure
            .sink { [weak self] in
                print("vc-error\($0)")
                self?.presentAlert()
            }
            .store(in: &cancellableSet)
    }

    private func presentAlert() {
        let alertController = UIAlertController(title: "Error",
                                                message: "エラーが発生しました",
                                                preferredStyle: .alert)

        let closeAction = UIAlertAction(title: "閉じる", style: .cancel) { [weak self] _ in
            // self?.viewModel.viewDidLoad.send()
        }

        alertController.addAction(closeAction)
        present(alertController, animated: true)
    }

}
