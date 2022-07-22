//
//  VotingView.swift
//  PruebaTecnicaIOSCatsApi
//
//  Created by Quinto Cossio on 21/07/2022.
//

import Foundation
import UIKit

class VotingView: UIView{
    
    let stackView = UIStackView()
    let breedImage = UIImageView()
    let breedLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}

extension VotingView {
    
    func style(){
        translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
        breedImage.translatesAutoresizingMaskIntoConstraints = false
        breedImage.contentMode = .scaleAspectFit
        
        breedLabel.translatesAutoresizingMaskIntoConstraints = false
        breedLabel.textAlignment = .center
        breedLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        breedLabel.adjustsFontSizeToFitWidth = true
        breedLabel.numberOfLines = 0
        
        
    }
    
    func layout(){
        
        stackView.addArrangedSubview(breedImage)
        stackView.addArrangedSubview(breedLabel)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 1),
            breedImage.heightAnchor.constraint(equalToConstant: 200),
            breedImage.widthAnchor.constraint(equalToConstant: 200),
            
            
        ])
        
    }
    
    func configureView(with viewModel:VotingViewModel) {
        breedLabel.text = viewModel.breedName
        guard let imageUrl = viewModel.breedImageUrl, let url = URL(string: imageUrl) else { return }
        breedImage.sd_setImage(with: url)
    }
}
