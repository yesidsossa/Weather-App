import UIKit

protocol SearchViewProtocol {
    func showLocations(_ locations: [Location])
    func showError(_ message: String)
    func showFavorites(_ favorites: [FavoriteLocation])
}

class SearchViewController: UIViewController, SearchViewProtocol {
    
    var presenter: SearchPresenter?
    var locations: [Location] = []
    var favorites: [FavoriteLocation] = []

    // Elementos UI
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizationManager.localizedString(forKey: LocalizedKeys.Search.placeholder)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true // Inicialmente oculto hasta que haya favoritos
        return tableView
    }()

    private let searchResultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        setupUI()

        searchTextField.delegate = self
        searchTextField.accessibilityIdentifier = "searchField"

        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        searchResultsTableView.accessibilityIdentifier = "searchResultsTableView"
        
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        favoritesTableView.register(FavoriteCell.self, forCellReuseIdentifier: "favoriteCell")
        favoritesTableView.accessibilityIdentifier = "favoritesTableView"
        
        presenter?.loadFavorites()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearSearch()
    }

    private func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(favoritesTableView)
        view.addSubview(searchResultsTableView)

        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),

            favoritesTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            favoritesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoritesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoritesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            searchResultsTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        toggleFavoritesVisibility()
    }

    // MARK: - SearchViewProtocol
    func showLocations(_ locations: [Location]) {
        self.locations = locations
        DispatchQueue.main.async {
            self.toggleFavoritesVisibility()
            self.searchResultsTableView.reloadData()
        }
    }

    func showFavorites(_ favorites: [FavoriteLocation]) {
        self.favorites = favorites
        DispatchQueue.main.async {
            self.toggleFavoritesVisibility()
            self.favoritesTableView.reloadData()
        }
    }

    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    private func toggleFavoritesVisibility() {
        let hasFavorites = !favorites.isEmpty
        let isSearching = !(searchTextField.text?.isEmpty ?? true)

        favoritesTableView.isHidden = !hasFavorites || isSearching
        searchResultsTableView.isHidden = isSearching ? false : hasFavorites
    }

    private func clearSearch() {
        searchTextField.text = ""
        locations = []
        searchResultsTableView.reloadData()
        toggleFavoritesVisibility()
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

        presenter?.searchLocation(query: updatedText)
        return true
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchResultsTableView {
            return locations.count
        } else if tableView == favoritesTableView {
            return favorites.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchResultsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
            let location = locations[indexPath.row]
            cell.textLabel?.text = "\(location.name), \(location.country)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteCell
            let favorite = favorites[indexPath.row]
            cell.configure(with: favorite) {
                self.presenter?.removeFavorite(location: favorite)
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchResultsTableView {
            let selectedLocation = locations[indexPath.row]
            presenter?.didSelectLocation(location: selectedLocation)
        } else {
            let selectedFavorite = favorites[indexPath.row]
            let location = Location(
                name: selectedFavorite.name,
                country: selectedFavorite.country
            )
            presenter?.didSelectLocation(location: location)
        }
    }
}

// MARK: - Custom Favorite Cell
class FavoriteCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let removeButton = UIButton()

    var removeAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let trashImage = UIImage(systemName: "trash.fill") // Usa un ícono de SF Symbols
        removeButton.setImage(trashImage, for: .normal)
        removeButton.tintColor = .red // Color rojo para indicar eliminación
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)

        contentView.addSubview(titleLabel)
        contentView.addSubview(removeButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            removeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with favorite: FavoriteLocation, removeAction: @escaping () -> Void) {
        titleLabel.text = "\(favorite.name), \(favorite.country)"
        self.removeAction = removeAction
        removeButton.accessibilityIdentifier = "Eliminar"
    }

    @objc private func removeTapped() {
        removeAction?()
    }
}
