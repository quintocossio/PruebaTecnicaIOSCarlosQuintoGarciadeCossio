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
    var votedCats: [Cat] = []
    var currentIndex: Int = LocalState.currentIndex
    
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
        apiManager.fetchCatBreeds { [self] result in
            switch result {
                
            case .success(let cats):
                self.cats = cats
                if currentIndex == cats.count {
                    votingView.breedImage.image = nil
                    votingView.breedLabel.text = "No more breeds"
                    likeButton.isEnabled = false
                    dislikeButton.isEnabled = false
                    return
                }
                self.configureVotingView(with: cats[currentIndex])
            case .failure(let error):
                self.displayError(error)
            }
        }
    }
    
    
    private func configureVotingView(with cat: Cat) {
        let vm = VotingViewModel(breedName: cat.name, breedImageUrl: cat.image?.url)
        votingView.configureView(with: vm)
        likeButton.isEnabled = true
        dislikeButton.isEnabled = true
    }
    
    private func saveCatWith(voteType: String, date: Date) {
        var cat = cats[currentIndex]
        cat.voteType = voteType
        cat.date = Date()
        votedCats.append(cat)
        currentIndex = currentIndex + 1

        if currentIndex > cats.count {
            votingView.breedImage.image = nil
            votingView.breedLabel.text = "No more breeds"
            print("No more breeds")
            return
        }
        print(cats.count)
        print(currentIndex)
        BreedStore.save(cats: votedCats) { [self] result in
            switch result {
            case .success:

                if currentIndex == cats.count  {
                    votingView.breedImage.image = nil
                    votingView.breedLabel.text = "No more breeds"
                    LocalState.currentIndex = currentIndex
                    return

                }
                configureVotingView(with: cats[currentIndex])
                LocalState.currentIndex = currentIndex
                votedCats.removeAll()
                likeButton.isEnabled = true
                dislikeButton.isEnabled = true
                
            case .failure(let error):
                votedCats.removeAll()
                likeButton.isEnabled = true
                dislikeButton.isEnabled = true
                print(error.localizedDescription)
            }
        }
        
    }


}

extension HomeViewController {
    
    private func setup() {
        navigationItem.rightBarButtonItem = savedBreedsBarButtonItem
        navigationItem.title = "Vote"
        
    }
    
    private func style() {
        
        votingView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 20
        
        let imageConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        
        dislikeButton.translatesAutoresizingMaskIntoConstraints = false
        dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown.fill", withConfiguration: imageConfiguration), for: .normal)
        dislikeButton.tintColor = .red
        dislikeButton.addTarget(self, action: #selector(dislikeButtonPressed), for: .touchUpInside)
        dislikeButton.isEnabled = false
        
        likeButton.isEnabled = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill", withConfiguration: imageConfiguration), for: .normal)
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
        likeButton.isEnabled = false
        dislikeButton.isEnabled = false
        self.saveCatWith(voteType: "negative", date: Date())
        
    }
    
    @objc func likeButtonPressed(sender: UIButton) {
        print("like")
        likeButton.isEnabled = false
        dislikeButton.isEnabled = false
        self.saveCatWith(voteType: "positive", date: Date())

    }
    
    @objc func savedBreedsPressed(sender:UIButton) {
        let savedBreedsViewController = SavedBreedsViewController()
        self.navigationController?.pushViewController(savedBreedsViewController, animated: false)
    }
}

//MARK: - Error Handling
extension HomeViewController {
    
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
