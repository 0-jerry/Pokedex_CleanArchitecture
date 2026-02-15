//
//  PokemonImageCell.swift
//  Pokedex
//
//  Created by jerry on 2/13/26.
//

import UIKit
import PokedexDomain

final class PokemonImageCell: UICollectionViewCell {

    static let typeID: String = "PokemonImageCell"
    private(set) var pokemonID: PokemonID?
        
    private let pokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pokemonID = nil
        pokeImageView.image = nil
        activityIndicator.startAnimating()
    }

    func setPokemonID(_ pokemonID: PokemonID) {
        self.pokemonID = pokemonID
    }
    
    func setPokemonImage(_ pokemonImage: PokemonImage) {
        guard pokemonID == pokemonImage.pokemonID else {
            return
        }
        pokeImageView.image = pokemonImage.image
        activityIndicator.stopAnimating()
    }
    
    func setImageLoadFail() {
        pokeImageView.image = UIImage(systemName: "photo.badge.exclamationmark")
        activityIndicator.stopAnimating()
    }
    // MARK: - UI Layout
    
    private func configureUI() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .hex(.primaryWhite)
        clipsToBounds = true
        
        containerView.addSubview(pokeImageView)
        containerView.addSubview(activityIndicator)
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            pokeImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            pokeImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pokeImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pokeImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
        
        activityIndicator.startAnimating()
    }
}
