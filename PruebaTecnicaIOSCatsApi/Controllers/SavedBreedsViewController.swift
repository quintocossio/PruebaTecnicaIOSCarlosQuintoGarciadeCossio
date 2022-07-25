//
//  SavedBreedsViewController.swift
//  PruebaTecnicaIOSCatsApi
//
//  Created by Quinto Cossio on 21/07/2022.
//

import UIKit

class SavedBreedsViewController: UIViewController {

    var savedBreeds: [Cat] = []
    var breedCellViewModel: [BreedCellViewModel] = []

    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

    }
    

}

extension SavedBreedsViewController {
    
    private func setup() {
        setupTableView()
        loadData()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .tertiarySystemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BreedCell.self, forCellReuseIdentifier: BreedCell.reuseID)
        tableView.rowHeight = BreedCell.rowHeight
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTableCells(with breeds: [Cat]) {
        breedCellViewModel = breeds.map({
            BreedCellViewModel(breedName: $0.name, breedImageUrl: $0.image?.url, date: $0.date ?? Date(), voteType: $0.voteType ?? "")
        })
    }
    
    private func loadData() {
        BreedStore.load { [self] result in
            switch result {
            case .success(let savedBreeds):
                configureTableCells(with: savedBreeds)
                //print(savedBreeds)
                tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}

extension SavedBreedsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedCellViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !breedCellViewModel.isEmpty else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BreedCell.reuseID, for: indexPath) as! BreedCell
        
        let breed = breedCellViewModel[indexPath.row]
        cell.configureCell(with: breed)
        
        return cell
    }
    
}

extension SavedBreedsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
