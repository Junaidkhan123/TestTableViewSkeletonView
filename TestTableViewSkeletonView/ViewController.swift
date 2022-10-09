//
//  ViewController.swift
//  TestTableViewSkeletonView
//
//  Created by Junaid on 09/10/2022.
//

import UIKit
import SkeletonView
struct SomeData: Hashable {
    var name: String
}

enum SomeSection {
    case top
}
class ViewController: UIViewController {
    @IBOutlet weak var someTableView: UITableView!
    var arrayOfSomeData = [SomeData]()
    var tableViewDataSource: UITableViewDiffableDataSource<SomeSection, SomeData>!
    var snapShot = NSDiffableDataSourceSnapshot<SomeSection,SomeData>()
    override func viewDidLoad() {
        super.viewDidLoad()
        someTableView.delegate = self
        configureDataSource()
        setupUIRefreshControl(with: someTableView)
        showTableViewSkeleton()

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.createSnapShot()
        }
    }

    private func configureDataSource() {
        tableViewDataSource = TableViewSkeletonDiffableDataSource<SomeSection, SomeData>(tableView: someTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "SomeCell", for: indexPath) as! SomeCell
            cell.nameLabel.text = itemIdentifier.name
            return cell
        })
    }

    private func getData(isNewFetched: Bool = true) ->  [SomeData] {
        var array: [SomeData]  = []
        array.append(SomeData(name: "HeadPhone"))
        array.append(SomeData(name: "Mic"))
        array.append(SomeData(name: "Headphone B?"))
        array.append(SomeData(name: "Wireless?"))
        array.append(SomeData(name: "HeadPhone A+"))
        array.append(SomeData(name: "Mic +"))

        if isNewFetched {
            array.append(SomeData(name: "HABIBI Headset"))
            array.append(SomeData(name: "Memorial Headset"))
        }

        return array
    }

    private func createSnapShot(isNewFetched: Bool = false) {
        snapShot = NSDiffableDataSourceSnapshot<SomeSection,SomeData>()
        snapShot.appendSections([.top])
        snapShot.appendItems(getData(isNewFetched: isNewFetched))
        someTableView.hideSkeleton()
        tableViewDataSource.apply(snapShot, animatingDifferences: true)
    }

    fileprivate func showTableViewSkeleton() {
        someTableView.showAnimatedGradientSkeleton()
    }

    func setupUIRefreshControl(with tableView: UITableView) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .gray
        someTableView.refreshControl = refreshControl
    }

    @objc func handleRefresh() {
        showTableViewSkeleton()
        self.arrayOfSomeData = []
        self.snapShot.deleteAllItems()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {

            self.createSnapShot(isNewFetched: true)
            self.someTableView.refreshControl?.endRefreshing()

        }
    }

}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let someOneData = tableViewDataSource.itemIdentifier(for: indexPath) {
            print(someOneData.name)
        }
    }
}



class TableViewSkeletonDiffableDataSource<Section: Hashable, Item: Hashable>: UITableViewDiffableDataSource<Section, Item>, SkeletonTableViewDataSource {

    var cellIdentifier: String = "SomeCell"

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return cellIdentifier

    }

    func collectionSkeletonView(_ skeletonView: UITableView, prepareCellForSkeleton cell: UITableViewCell, at indexPath: IndexPath) {

    }

    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
