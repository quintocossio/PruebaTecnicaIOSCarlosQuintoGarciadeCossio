//
//  DetailSavedBreedsViewController.swift
//  PruebaTecnicaIOSCatsApi
//
//  Created by Quinto Cossio on 25/07/2022.
//

import UIKit

class DetailSavedBreedsViewController: UIViewController {

    var catBreed: Cat? = nil
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let breedImage = UIImageView()
    let stackView = UIStackView()
    let descriptionLabel = UILabel()
    let originLabel = UILabel()
    let temperamentLabel = UILabel()
    let lifeSpanLabel = UILabel()
    let weightLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        style()
        layout()
    }
    
    


}

extension DetailSavedBreedsViewController {
    
    private func setup() {
        setupScrollView()
        configureView()
        
    }
    
    private func style() {
        breedImage.translatesAutoresizingMaskIntoConstraints = false
        breedImage.contentMode = .scaleAspectFit
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 8
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.numberOfLines = 0
        
        originLabel.translatesAutoresizingMaskIntoConstraints = false
        originLabel.textAlignment = .left
        originLabel.font = UIFont.preferredFont(forTextStyle: .body)
        originLabel.adjustsFontSizeToFitWidth = true
        originLabel.numberOfLines = 0
        
        temperamentLabel.translatesAutoresizingMaskIntoConstraints = false
        temperamentLabel.textAlignment = .left
        temperamentLabel.font = UIFont.preferredFont(forTextStyle: .body)
        temperamentLabel.adjustsFontSizeToFitWidth = true
        temperamentLabel.numberOfLines = 0
        
        lifeSpanLabel.translatesAutoresizingMaskIntoConstraints = false
        lifeSpanLabel.textAlignment = .left
        lifeSpanLabel.font = UIFont.preferredFont(forTextStyle: .body)
        lifeSpanLabel.adjustsFontSizeToFitWidth = true
        lifeSpanLabel.numberOfLines = 0
        
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.textAlignment = .left
        weightLabel.font = UIFont.preferredFont(forTextStyle: .body)
        weightLabel.adjustsFontSizeToFitWidth = true
        weightLabel.numberOfLines = 0
        
        
    }
    
    private func layout() {
        
        contentView.addSubview(breedImage)
        
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(originLabel)
        stackView.addArrangedSubview(temperamentLabel)
        stackView.addArrangedSubview(lifeSpanLabel)
        stackView.addArrangedSubview(weightLabel)
        contentView.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            breedImage.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            breedImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            breedImage.heightAnchor.constraint(equalToConstant: 200),
            breedImage.widthAnchor.constraint(equalToConstant: 200),
            
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: breedImage.bottomAnchor, multiplier: 2),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            
        ])
        
        
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
    }
    
    private func configureView() {
        
        navigationItem.title = catBreed?.name
        descriptionLabel.text = catBreed?.catDescription
        originLabel.text = "Origin: \(catBreed?.origin ?? "")"
        temperamentLabel.text = "Temperament: \(catBreed?.temperament ?? "")"
        lifeSpanLabel.text = "Lifespan: \(catBreed?.lifeSpan ?? "")"
        weightLabel.text = "Weight: \(catBreed?.weight?.metric ?? "") Kg"
        
        let placeHolderImage = UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title3))
        guard let imageUrl = catBreed?.image?.url, let url = URL(string: imageUrl) else {
            breedImage.image = placeHolderImage
            return
        }
        breedImage.sd_setImage(with: url, placeholderImage: placeHolderImage)
    }
}
