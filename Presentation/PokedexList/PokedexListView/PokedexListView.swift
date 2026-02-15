//
//  PokedexListViewController.swift
//  Pokedex
//
//  Created by jerry on 2/13/26.
//

import UIKit
import PokedexDomain

public final class PokedexListView: UIViewController {
    
    private enum Section {
        case main
    }
    
    public var input: PokedexInputPort!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, PokemonID>!
    private var offset: Int { dataSource.snapshot().numberOfItems(inSection: .main) }
    
    private let placeholderTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeholderDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("재시도", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        return button
    }()
    
    private lazy var placeholder: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [placeholderTitleLabel,
                                                   placeholderDescriptionLabel,
                                                   retryButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -20)
        ])

        container.isHidden = true
        return container
    }()
    
    private let pokeBallImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.pokeBall
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let pokemonListView: UICollectionView = {
        let itemsForRow: CGFloat = 3
        let itemSpacing: CGFloat = 10
        let width = (UIScreen.main.bounds.width - (itemsForRow - 1) * itemSpacing - 10) / itemsForRow
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = .init(width: width, height: width)
        flowLayout.minimumLineSpacing = itemSpacing
        flowLayout.minimumInteritemSpacing = itemSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.hex(.primaryRed)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        
        return collectionView
    }()
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        input.onAppear()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurePokemonListView()
        input.loadNextPokemonIDList(offset: offset)
    }
    
}

extension PokedexListView: PokedexListRenderer {
    
    public func render(_ viewModel: PokedexListViewModel) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            switch viewModel {
            case .appendPokemonList(let newPokemonIDList):
                self.updateSnapshot(with: newPokemonIDList)
                self.input.completedLoadNextPokemonIDList()
                
            case .setupPokemonImage(let pokemonImage):
                self.pokemonImageCell(for: pokemonImage.pokemonID)?
                    .setPokemonImage(pokemonImage)
                
            case .showError(title: let title, description: let description):
                if self.offset == 0 {
                    self.showPlaceholder(title: title, description: description)
                } else {
                    self.showAlert(title: title, message: description)
                }
                self.input.completedLoadNextPokemonIDList()
                
            case .imageLoadFail(let pokemonID):
                self.pokemonImageCell(for: pokemonID)?
                    .setImageLoadFail()
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "재시도", style: .default,
                                      handler: { [weak self] _ in self?.didTapRetry() }))
        present(alert, animated: true, completion: nil)
    }
}

extension PokedexListView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pokemonID = pokemonID(at: indexPath) else { return }
        input.selectedPokemon(pokemonID)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        let frameHeight = scrollView.frame.size.height
        
        let threshold: CGFloat = 300.0
        
        if scrollOffset > (contentHeight - frameHeight - threshold) {
            input.loadNextPokemonIDList(offset: offset)
        }
    }
    
}

extension PokedexListView: UICollectionViewDataSourcePrefetching {
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let currentTotalCount = dataSource.snapshot().numberOfItems(inSection: .main)
        
        let threshold = 6
        if indexPaths.contains(where: { $0.item >= currentTotalCount - threshold }) {
            input.loadNextPokemonIDList(offset: offset)
        }
    }
    
}

private extension PokedexListView {
    
    func configureUI() {
        view.backgroundColor = UIColor.hex(.primaryRed)
        [
            pokeBallImageView,
            placeholder,
            pokemonListView
        ].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            pokeBallImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokeBallImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pokeBallImageView.widthAnchor.constraint(equalToConstant: 80),
            pokeBallImageView.heightAnchor.constraint(equalToConstant: 80),
            
            placeholder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            placeholder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            placeholder.topAnchor.constraint(equalTo: pokeBallImageView.bottomAnchor, constant: 20),
            placeholder.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
            pokemonListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            pokemonListView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            pokemonListView.topAnchor.constraint(equalTo: pokeBallImageView.bottomAnchor, constant: 20),
            pokemonListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    
}

private extension PokedexListView {
    
    func configurePokemonListView() {
        pokemonListView.register(PokemonImageCell.self,
                                 forCellWithReuseIdentifier: PokemonImageCell.typeID)
        
        dataSource = UICollectionViewDiffableDataSource<Section, PokemonID>(collectionView: pokemonListView) { [weak self] (collectionView, indexPath, pokemonID) -> UICollectionViewCell? in
            guard let cell = self?.dequeuePokemonImageCell(at: indexPath) else {
                return UICollectionViewCell()
            }
            
            cell.setPokemonID(pokemonID)
            self?.input.loadPokemonImage(pokemonID)
            return cell
        }
        
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems([], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        pokemonListView.delegate = self
        pokemonListView.prefetchDataSource = self
    }
    
    func updateSnapshot(with newIDs: [PokemonID]) {
        var snapshot = dataSource.snapshot()

        hidePlaceholder()
        snapshot.appendItems(newIDs, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}


private extension PokedexListView {
    
    func pokemonID(at indexPath: IndexPath) -> PokemonID? {
        dataSource.itemIdentifier(for: indexPath)
    }
    
    func pokemonImageCell(for pokemonID: PokemonID) -> PokemonImageCell? {
        guard let indexPath = dataSource.indexPath(for: pokemonID) else { return nil }
        return pokemonListView.cellForItem(at: indexPath) as? PokemonImageCell
    }
    
    func dequeuePokemonImageCell(at indexPath: IndexPath) -> PokemonImageCell? {
        return pokemonListView.dequeueReusableCell(
            withReuseIdentifier: PokemonImageCell.typeID,
            for: indexPath
        ) as? PokemonImageCell
    }
    
}

private extension PokedexListView {
    func showPlaceholder(title: String, description: String) {
        placeholderTitleLabel.text = title
        placeholderDescriptionLabel.text = description

        placeholder.isHidden = false
        pokemonListView.isHidden = true
    }

    func hidePlaceholder() {
        placeholder.isHidden = true
        pokemonListView.isHidden = false
    }
}

private extension PokedexListView {
    @objc func didTapRetry() {
        // Retry loading from the beginning when there is no data
        input.loadNextPokemonIDList(offset: offset)
    }
}

