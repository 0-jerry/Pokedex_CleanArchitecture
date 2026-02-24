//
//  PokemonInfoView.swift
//  Pokedex
//

import UIKit

public final class PokemonInfoView: UIViewController, PokemonInfoRendererProtocol {
    
    // (선택) 이전 코드에 포함되었던 InputPort가 정의되어 있다면 그대로 유지
     var input: PokemonInfoInputPort?
    
    // MARK: - UI Components
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.backgroundColor = .hex(.secondaryRed)
        stackView.layer.cornerRadius = 15
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let pokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    // MARK: - Initializer
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        input?.loadPokemonInfo()
    }
    
    // MARK: - UI Setup
    
    private func configureUI() {
        view.backgroundColor = .hex(.primaryRed)
        
        view.addSubview(stackView)
        
        [
            pokeImageView,
            nameLabel,
            typeStackView,
            weightLabel,
            heightLabel,
            emptyView
        ].forEach { stackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            pokeImageView.widthAnchor.constraint(equalToConstant: 300),
            pokeImageView.heightAnchor.constraint(equalToConstant: 300),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -15),
            
            typeStackView.heightAnchor.constraint(equalToConstant: 30),
            
            weightLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 15),
            weightLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -15),
            
            heightLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 15),
            heightLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -15),
            
            emptyView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - Renderer Protocol
    
    public func render(_ viewModel: PokemonInfoViewModel) {
        switch viewModel {
        case .pokemonInfo(let info, let image):
            pokeImageView.image = image.image
            nameLabel.text = "\(info.number) \(info.name)"
            
            // 기존 뷰 초기화 후 재생성
            typeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            info.types.forEach { type in
                let typeLabel = UILabel()
                typeLabel.text = type.string
                typeLabel.font = .systemFont(ofSize: 16, weight: .semibold)
                typeLabel.textColor = .white
                typeLabel.backgroundColor = .hex(type.backgroundColor)
                typeLabel.textAlignment = .center
                typeLabel.layer.cornerRadius = 4
                typeLabel.clipsToBounds = true
                typeLabel.translatesAutoresizingMaskIntoConstraints = false
                typeLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
                typeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
                typeStackView.addArrangedSubview(typeLabel)
            }
            
            if info.figure.count >= 2 {
                weightLabel.text = info.figure[0]
                heightLabel.text = info.figure[1]
            }
            
        case .showErrorAlert(let title, let message):
            showAlert(title: title, message: message)
        }
        
        input?.completedLoad()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "재시도", style: .default, handler: { [weak self] _ in
            self?.input?.loadPokemonInfo()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: { [weak self] _ in
            self?.input?.dismiss()
        }))
        // UIViewController이므로 직접 present 호출 가능
        self.present(alert, animated: true)
    }
}
