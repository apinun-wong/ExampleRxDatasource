//
//  ViewController.swift
//  DatasourceTableView
//
//  Created by Apinun on 9/4/2564 BE.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

struct MySection {
    var header: String
    var items: [Item]
}

extension MySection : AnimatableSectionModelType {
    typealias Item = Int

    var identity: String {
        return header
    }

    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    var dataSource: RxTableViewSectionedAnimatedDataSource<MySection>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Item in section
        let dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(
            configureCell: { ds, tv, _, item in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
                cell.textLabel?.text = "Item Nun \(item)"

                return cell
            },
            titleForHeaderInSection: { ds, index in
                return ds.sectionModels[index].header
            }
        )

        self.dataSource = dataSource

        // Item in Header
        let sections = [
            MySection(header: "First section", items: [1,2]),
            MySection(header: "Second section", items: [3,4])
        ]

        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }


}


extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        // you can also fetch item
        guard let item = dataSource?[indexPath],
        // .. or section and customize what you like
            dataSource?[indexPath.section] != nil
            else {
            return 0.0
        }

        return CGFloat(40 + item * 10)
    }
}
