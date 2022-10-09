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
    override func viewDidLoad() {
        super.viewDidLoad()
        someTableView.delegate = self
        configureDataSource()
        someTableView.showAnimatedGradientSkeleton()

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

    private func getData() ->  [SomeData] {
        return [
            SomeData(name: "HeadPhone"),
            SomeData(name: "Mic?"),
            SomeData(name: "Headphone B?"),
            SomeData(name: "Wireless?"),
            SomeData(name: "HeadPhone A+"),
            SomeData(name: "Mic +")
        ]
    }

    private func createSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<SomeSection,SomeData>()
        snapShot.appendSections([.top])
        snapShot.appendItems(getData())
        someTableView.hideSkeleton()
        tableViewDataSource.apply(snapShot, animatingDifferences: true)
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
