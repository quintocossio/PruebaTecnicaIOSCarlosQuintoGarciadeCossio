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
                self.configureVotingView(with: cats[currentIndex])
            case .failure(let error):
                self.displayError(error)
            }
        }
    }
    
    private func reloadView() {
//        LocalState.currentIndex = LocalState.currentIndex + 1
//        print(LocalState.currentIndex)
//        if LocalState.currentIndex >= cats.count{
//            print("No more breeds")
//            return
//        }
//
//        self.configureVotingView(with: cats[LocalState.currentIndex])
        
        
    }
    
    private func configureVotingView(with cat: Cat) {
        let vm = VotingViewModel(breedName: cat.name, breedImageUrl: cat.image?.url)
        votingView.configureView(with: vm)
    }
    
    private func saveCatWith(voteType: String, date: Date) {
        if currentIndex > cats.count{
            print("No more breeds")
            return
        }
        var cat = cats[currentIndex]
        cat.voteType = voteType
        cat.date = Date()
        votedCats.append(cat)
        currentIndex = currentIndex + 1

        if currentIndex >= cats.count{
            print("No more breeds")
            return
        }
        
        BreedStore.save(cats: votedCats) { [self] result in
            switch result {
            case .success(_):
                configureVotingView(with: cats[currentIndex])
                LocalState.currentIndex = currentIndex
                votedCats.removeAll()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        print("current3",currentIndex)
        print("localstate3",LocalState.currentIndex)
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
        
        let imageConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        
        dislikeButton.translatesAutoresizingMaskIntoConstraints = false
        dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown.fill", withConfiguration: imageConfiguration), for: .normal)
        dislikeButton.tintColor = .red
        dislikeButton.addTarget(self, action: #selector(dislikeButtonPressed), for: .touchUpInside)
        
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
        self.saveCatWith(voteType: "negative", date: Date())
        
    }
    
    @objc func likeButtonPressed(sender: UIButton) {
        print("like")
        self.saveCatWith(voteType: "positive", date: Date())

    }
    
    @objc func savedBreedsPressed(sender:UIButton) {
        let savedBreedsViewController = SavedBreedsViewController()
        self.navigationController?.pushViewController(savedBreedsViewController, animated: false)
    }
}
