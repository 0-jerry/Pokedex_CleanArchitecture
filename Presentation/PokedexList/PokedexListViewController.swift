//
//  PokedexListViewController.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

import UIKit
import PokedexDomain

internal final class PokedexListViewController: UIViewController {
    
    private let usecase: PokedexListUsecaseProtocol
    private let contentView: PokedexListView
    
    internal init(
        usecase: PokedexListUsecaseProtocol,
        contentView: PokedexListView
    ) {
        self.usecase = usecase
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = contentView
    }
    
}
