//
//  PokedexListViewController.swift
//  Pokedex
//
//  Created by jerry on 2/2/26.
//

import UIKit
import PokedexDomain

public final class PokedexListViewController: UIViewController {
    
    private let useCase: PokedexListUseCaseProtocol
    private let contentView: PokedexListView
    
    public init(
        useCase: PokedexListUseCaseProtocol,
        contentView: PokedexListView
    ) {
        self.useCase = useCase
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        self.view = contentView
    }
    
}
