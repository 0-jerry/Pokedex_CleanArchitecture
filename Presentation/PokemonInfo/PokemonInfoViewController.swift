//
//  PokemonInfoViewController.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

import UIKit
import PokedexDomain

public final class PokemonInfoViewController: UIViewController {
    
    private let usecase: PokemonInfoUsecaseProtocol
    private let contentView: PokemonInfoView
    
    public init(usecase: PokemonInfoUsecaseProtocol, contentView: PokemonInfoView) {
        self.usecase = usecase
        self.contentView = contentView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        self.view = contentView
    }
    
}
