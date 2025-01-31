import UIKit

class FavoriteCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let removeButton = UIButton(type: .system)

    var removeAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        let trashImage = UIImage(systemName: "trash.fill")
        removeButton.setImage(trashImage, for: .normal)
        removeButton.tintColor = .red
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        removeButton.accessibilityIdentifier = "Eliminar" 

        contentView.addSubview(titleLabel)
        contentView.addSubview(removeButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            removeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with favorite: FavoriteLocation, removeAction: @escaping () -> Void) {
        titleLabel.text = "\(favorite.name), \(favorite.country)"
        self.removeAction = removeAction
    }

    @objc private func removeTapped() {
        removeAction?()
    }
}
