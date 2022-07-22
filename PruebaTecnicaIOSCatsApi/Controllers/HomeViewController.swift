//
//  HomeViewController.swift
//  PruebaTecnicaIOSCatsApi
//
//  Created by Quinto Cossio on 21/07/2022.
//

import UIKit

class HomeViewController: UIViewController {

    var cats: [Cat] = []
    var apiManager: APIManageable = APIManager()
    
    var votingView = VotingView()
    let buttonsStackView = UIStackView()
    let likeButton = UIButton()
    let dislikeButton = UIButton()
    
    lazy var savedBreedsBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Registros", style: .plain, target: self, action: #selector(savedBreedsPressed))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
        setup()
        
        
        fetchData()


    }
    
    private func fetchData() {
        apiManager.fetchCatBreeds { result in
            switch result {
                
            case .success(let cats):
                self.cats = cats
                self.configureVotingView(with: cats[0])
            case .failure(let error):
                self.displayError(error)
            }
        }
    }
    
    private func reloadView() {
        self.configureVotingView(with: cats[1])
    }
    
    private func configureVotingView(with cat: Cat) {
        let vm = VotingViewModel(breedName: cat.name, breedImageUrl: cat.image?.url)
        votingView.configureView(with: vm)
    }
    
    
    //Error handling
    
    private func displayError(_ error: NetworkError) {
        let titleAndMessage = titleAndMessage(for: error)
        self.showErrorAlert(withTitle: titleAndMessage.0, message: titleAndMessage.1)
    }
    
    private func titleAndMessage(for error: NetworkError) -> (String, String) {
        let title: String
        let message:String
        switch error {
        case .serverError:
            title = "Server Error"
            message = "We could not process your request. Please try again."
        case .decodingError:
            title = "Network Error"
            message = "Please check your network connectivity and try again."
        }
        
        return (title, message)
    }
    
    private func showErrorAlert(withTitle title: String, message: String) {
        errorAlert.title = title
        errorAlert.message = message
        
        present(errorAlert, animated: true, completion: nil)
    }

    

    

}

extension HomeViewController {
    
    private func setup() {
        navigationItem.rightBarButtonItem = savedBreedsBarButtonItem
    }
    
    private func style() {
        
        votingView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 20
        
        dislikeButton.translatesAutoresizingMaskIntoConstraints = false
        dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .normal)
        dislikeButton.tintColor = .red
        dislikeButton.addTarget(self, action: #selector(dislikeButtonPressed), for: .touchUpInside)
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        likeButton.tintColor = .green
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        

    }
    
    private func layout() {
        
        view.addSubview(votingView)

        NSLayoutConstraint.activate([
            votingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            votingView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 12),
            votingView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: votingView.trailingAnchor, multiplier: 1)
        ])
    
        
        buttonsStackView.addArrangedSubview(dislikeButton)
        buttonsStackView.addArrangedSubview(likeButton)
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalToSystemSpacingBelow: votingView.bottomAnchor, multiplier: 3),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
    }
}

//MARK: - Actions Methods
extension HomeViewController {
    
    @objc func dislikeButtonPressed(sender: UIButton) {
        print("dislike")
    }
    
    @objc func likeButtonPressed(sender: UIButton) {
        print("like")
        self.reloadView()
    }
    
    @objc func savedBreedsPressed(sender:UIButton) {
        let savedBreedsViewController = SavedBreedsViewController()
        savedBreedsViewController.savedBreeds = cats
        self.navigationController?.pushViewController(savedBreedsViewController, animated: false)
    }
}
