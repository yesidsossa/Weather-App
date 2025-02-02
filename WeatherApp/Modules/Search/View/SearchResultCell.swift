import UIKit

class SearchResultCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .gray
        button.accessibilityIdentifier = "favoriteButton" 
        return button
    }()

    var favoriteAction: (() -> Void)?

    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.addSubview(locationLabel)
        containerView.addSubview(countryLabel)
        containerView.addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            locationLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            locationLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10),

            countryLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            countryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            countryLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10),
            countryLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),

            favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            favoriteButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }

    // MARK: - Configuration
    func configure(with location: Location, isFavorite: Bool, favoriteAction: @escaping () -> Void) {
        locationLabel.text = location.name
        countryLabel.text = location.country
        updateFavoriteIcon(isFavorite: isFavorite)
        self.favoriteAction = favoriteAction
    }

    func updateFavoriteIcon(isFavorite: Bool) {
        let imageName = isFavorite ? "star.fill" : "star"
        let image = UIImage(systemName: imageName)
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = isFavorite ? .yellow : .gray
    }

    @objc private func favoriteTapped() {
        guard let favoriteAction = favoriteAction else { return }
        
        let isCurrentlyFavorite = favoriteButton.tintColor == .yellow
        updateFavoriteIcon(isFavorite: !isCurrentlyFavorite)
        
        favoriteAction()
    }

}
