import UIKit

protocol SearchViewProtocol {
    func showLocations(_ locations: [Location])
    func showError(_ message: String)
    func showFavorites(_ favorites: [FavoriteLocation])
}

class SearchViewController: UIViewController, SearchViewProtocol {
    
    var presenter: SearchPresenter?

    // MARK: - UI Elements
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizationManager.localizedString(forKey: LocalizedKeys.Search.placeholder)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.accessibilityIdentifier = "searchField"
        return textField
    }()

    private lazy var favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.delegate = favoritesDataSource
        tableView.dataSource = favoritesDataSource
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: "favoriteCell")
        tableView.accessibilityIdentifier = "favoritesTableView"
        return tableView
    }()

    private lazy var searchResultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = searchResultsDataSource
        tableView.dataSource = searchResultsDataSource
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        tableView.accessibilityIdentifier = "searchResultsTableView"
        return tableView
    }()

    // MARK: - Data Sources
    private let searchResultsDataSource = SearchResultsDataSource()
    private let favoritesDataSource = FavoritesDataSource()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEventHandlers()
        presenter?.loadFavorites()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearSearch()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
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
    }

    // MARK: - Event Handlers
    private func setupEventHandlers() {
        searchResultsDataSource.didSelectLocation = { [weak self] location in
            self?.presenter?.didSelectLocation(location: location)
        }

        favoritesDataSource.didSelectFavorite = { [weak self] favorite in
            let location = Location(name: favorite.name, country: favorite.country)
            self?.presenter?.didSelectLocation(location: location)
        }

        favoritesDataSource.didRemoveFavorite = { [weak self] favorite in
            self?.presenter?.removeFavorite(location: favorite)
        }
    }

    // MARK: - SearchViewProtocol
    func showLocations(_ locations: [Location]) {
        searchResultsDataSource.locations = locations
        DispatchQueue.main.async {
            self.toggleFavoritesVisibility()
            self.searchResultsTableView.reloadData()
        }
    }

    func showFavorites(_ favorites: [FavoriteLocation]) {
        favoritesDataSource.favorites = favorites
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
        let hasFavorites = !favoritesDataSource.favorites.isEmpty
        let isSearching = !(searchTextField.text?.isEmpty ?? true)

        favoritesTableView.isHidden = !hasFavorites || isSearching
        searchResultsTableView.isHidden = isSearching ? false : hasFavorites
    }

    private func clearSearch() {
        searchTextField.text = ""
        searchResultsDataSource.locations = []
        searchResultsTableView.reloadData()
        toggleFavoritesVisibility()
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

        print("Buscando: \(updatedText)") 

        presenter?.searchLocation(query: updatedText)
        return true
    }
}
