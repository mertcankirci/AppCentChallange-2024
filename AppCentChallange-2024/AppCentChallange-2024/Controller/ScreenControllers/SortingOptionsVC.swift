//
//  SortingOptionsVC.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 13.05.2024.
//

import UIKit

protocol SortingOptionsVCDelegate: AnyObject {
    func didSelectSortingOption(with option: SortingOptions)
}

class SortingOptionsVC: UIViewController {
    
    var sortingOptions: [SortingOptions] = SortingOptions.allCases
    var closeButton: UIBarButtonItem!
    var titleLabel = ACTitleLabel(textAlignment: .left, fontSize: 22)
    let tableView = UITableView()
    let padding: CGFloat = 16
    weak var delegate: SortingOptionsVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTitleLabel()
        configureTableView()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        
        closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        closeButton.tintColor = .systemPink
        navigationItem.rightBarButtonItem = closeButton
    }
    
    func configureTitleLabel() {
        titleLabel.text = "Sort By"
        titleLabel.textColor = .systemPink
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 80),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.rowHeight = 40
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(SortingOptionCell.self, forCellReuseIdentifier: SortingOptionCell.reuseID)
    }
    
    @objc func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension SortingOptionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortingOptionCell.reuseID, for: indexPath) as! SortingOptionCell
        let sortingOption = sortingOptions[indexPath.row]
        cell.set(for: sortingOption)
        cell.selectedImage.image = UIImage(systemName: cell.sortingOpiton == NetworkManager.shared.sortingOption ? "circle.circle.fill" : "circle.circle")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SortingOptionCell {
            self.dismiss(animated: true)
            self.delegate?.didSelectSortingOption(with: cell.sortingOpiton)
        }
    }
}
