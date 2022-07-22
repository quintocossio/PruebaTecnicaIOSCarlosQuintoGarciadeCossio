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
    
    let breedNameLabel = UILabel()
    let breedImageView = UIImageView()
    let isLikedLabel = UILabel()
    let dateLabel = UILabel()
    
    static let reuseID = "BreedCell"
    static let rowHeight:CGFloat = 250
    
    var onReuse: () -> Void = {}

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
        breedImageView.translatesAutoresizingMaskIntoConstraints = false
        breedImageView.contentMode = .scaleAspectFit
        
        breedNameLabel.translatesAutoresizingMaskIntoConstraints = false
        breedNameLabel.textAlignment = .center
        breedNameLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        breedNameLabel.adjustsFontSizeToFitWidth = true
        breedNameLabel.numberOfLines = 0
        
        contentView.addSubview(breedImageView)
        contentView.addSubview(breedNameLabel)
    }
    
    private func layout() {
        
        NSLayoutConstraint.activate([
            breedImageView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            breedImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: breedImageView.bottomAnchor, multiplier: 1),
            breedNameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: breedImageView.trailingAnchor, multiplier: 2),
            breedNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

extension BreedCell {
    func configureCell(with viewModel: BreedCellViewModel) {
        breedNameLabel.text = viewModel.breedName
        //breedImageView.loadFrom(URLAddress: viewModel.breedImageUrl!)
        //dateLabel.text = String(viewModel.date)
        //isLikedLabel.text = viewModel.isLiked
        guard let imageUrl = viewModel.breedImageUrl, let url = URL(string: imageUrl) else { return }
        breedImageView.sd_setImage(with: url)
        
    }
}
