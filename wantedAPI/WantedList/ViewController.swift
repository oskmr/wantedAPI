//
//  ViewController.swift
//  wantedAPI
//
//  Created by 逢坂 美芹 on 2022/08/13.
//

import UIKit
import Combine

final class ViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>

    private var cancellableSet: Set<AnyCancellable> = []
    private let viewModel = WantedListViewModel()

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.registerNib(type: WantedListCollectionViewCell.self)
            // collectionView.delegate = self
        }
    }

    private lazy var cellProvider: DataSource.CellProvider = { [weak self] collectionView, indexPath, row -> UICollectionViewCell? in
            guard let self = self else { return nil }
            switch row {
            case .wantedList(let item):
                let cell = collectionView.dequeueReusableCell(type: WantedListCollectionViewCell.self, for: indexPath)
                cell.prepare(item: item)
                return cell
            }
        }
        private lazy var dataSource: DataSource = {
            .init(collectionView: collectionView, cellProvider: cellProvider)
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad.send()
        addPublisher()
        viewModel.$sectionModels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] models in
                self?.setupDataSource(models: models)
            }
            .store(in: &cancellableSet)
    }

    private func setup(collectionView: UICollectionView) {
        collectionView.collectionViewLayout = makeLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
    }

    private func addPublisher() {
        viewModel.$sectionModels
            .sink {
                print("vc-\($0)")
            }
            .store(in: &cancellableSet)

        viewModel.failureFetchWantedList
            .sink { [weak self] in
                print("vc-error\($0)")
                self?.presentAlert()
            }
            .store(in: &cancellableSet)
    }

    private func setupDataSource(models: [WantedListViewModel.SectionModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections(Section.allCases)

        models.forEach {
            snapshot.appendItems($0.rows, toSection: $0.section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(1.0),
                    heightDimension: .fractionalWidth(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 16, trailing: 6)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(1.0))
            let horizontalGroup: NSCollectionLayoutGroup = {
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                return horizontalGroup
            }()
            let verticalGroup: NSCollectionLayoutGroup = {
                let verticalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                return verticalGroup
            }()
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalWidth(1.0)
                ),
                subitems: [
                    horizontalGroup,
                    verticalGroup
                ]
            )

            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
            return sectionLayout
        }
        return layout
    }

    private func presentAlert() {
        let alertController = UIAlertController(title: "Error",
                                                message: "エラーが発生しました",
                                                preferredStyle: .alert)

        let closeAction = UIAlertAction(title: "閉じる", style: .cancel) // { [weak self] _ in
            // self?.viewModel.viewDidLoad.send()
        // }

        alertController.addAction(closeAction)
        present(alertController, animated: true)
    }

}

extension ViewController {
    enum Section: CaseIterable {
        case wantedList
    }

    enum Row: Equatable, Hashable {
        case wantedList(Item)

        static func == (lhs: ViewController.Row, rhs: ViewController.Row) -> Bool {
            lhs.hashValue == rhs.hashValue
        }

        func hash(into hasher: inout Hasher) {
            switch self {
            case .wantedList(let list):
                hasher.combine(list.title)
            }
        }
    }
}
