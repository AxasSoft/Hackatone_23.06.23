//
//  ViewController.swift
//  hackathon
//
//

import UIKit

final class MainViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    fileprivate enum Sections: Int, CaseIterable {
        case charts
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI() {
        tableView.dataSource = self
    }

}
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChartsTableViewCell.reuseID) as! ChartsTableViewCell
        return cell
    }
    
    
    
}

