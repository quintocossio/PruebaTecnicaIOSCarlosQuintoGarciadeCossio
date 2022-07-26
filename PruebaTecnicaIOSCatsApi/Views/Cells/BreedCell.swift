//
//  BreedCell.swift
//  PruebaTecnicaIOSCatsApi
//
//  Created by Quinto Cossio on 21/07/2022.
//

import UIKit
import SDWebImage

class BreedCell: UITableViewCell {
    
    let breedCellViewModel: BreedCellViewModel? = nil
    
    let breedImageView = UIImageView()
    let stackView = UIStackView()
    let breedNameLabel = UILabel()
    let voteTypeImage = UIImageView()
    let dateLabel = UILabel()
    
    static let reuseID = "BreedCell"
    static let rowHeight:CGFloat = 150
    
    override func prepareForReuse() {
      super.prepareForReuse()
        breedImageView.image = nil
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension BreedCell {
    
    private func setup() {
        
        selectionStyle = .none
        
        breedImageView.translatesAutoresizingMaskIntoConstraints = false
        breedImageView.contentMode = .scaleAspectFit
        breedImageView.clipsToBounds = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        
        breedNameLabel.translatesAutoresizingMaskIntoConstraints = false
        breedNameLabel.textAlignment = .left
        breedNameLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        breedNameLabel.adjustsFontSizeToFitWidth = true
        breedNameLabel.numberOfLines = 0
        
        voteTypeImage.translatesAutoresizingMaskIntoConstraints = false
        voteTypeImage.contentMode = .scaleAspectFit
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .left
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.numberOfLines = 0
        
        
    }
    
    private func layout() {
        
        stackView.addArrangedSubview(breedNameLabel)
        stackView.addArrangedSubview(voteTypeImage)
        stackView.addArrangedSubview(dateLabel)
        
        contentView.addSubview(breedImageView)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            breedImageView.heightAnchor.constraint(equalToConstant: 100),
            breedImageView.widthAnchor.constraint(equalToConstant: 100),
            breedImageView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            breedImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: breedImageView.bottomAnchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: breedImageView.trailingAnchor, multiplier: 2),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1),
            voteTypeImage.heightAnchor.constraint(equalToConstant: 20),
            voteTypeImage.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
}

extension BreedCell {
    func configureCell(with viewModel: BreedCellViewModel) {
        breedNameLabel.text = viewModel.breedName
        dateLabel.text = viewModel.dateFormatted
        configureVoteImage(voteType: viewModel.voteType)
        let placeHolderImage = UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title3))
        guard let imageUrl = viewModel.breedImageUrl, let url = URL(string: imageUrl) else {
            breedImageView.image = placeHolderImage
            return
            
        }
        breedImageView.sd_setImage(with: url, placeholderImage: placeHolderImage)
        
    }
    
    func configureVoteImage(voteType: String) {
        if voteType == "positive"{
            voteTypeImage.image = UIImage(systemName: "hand.thumbsup.fill")
            voteTypeImage.tintColor = .green
        } else {
            voteTypeImage.image = UIImage(systemName: "hand.thumbsdown.fill")
            voteTypeImage.tintColor = .red
        }
    }
}
