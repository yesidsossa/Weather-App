import UIKit

protocol SearchViewProtocol {
    func showLocations(_ locations: [Location])
    func showError(_ message: String)
    func showFavorites(_ favorites: [FavoriteLocation])
    func isFavorite(location: FavoriteLocation) -> Bool  
}

class SearchViewController: UIViewController, SearchViewProtocol {
    
    var presenter: SearchPresenter?

    // MARK: - UI Elements
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizationManager.localizedString(forKey: LocalizedKeys.Search.placeholder)
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.1
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowRadius = 4
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.accessibilityIdentifier = "searchField"
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = .gray
        icon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        leftView.addSubview(icon)
        textField.leftView = leftView
        textField.leftViewMode = .always

        return textField
    }()

    private lazy var favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.delegate = favoritesDataSource
        tableView.dataSource = favoritesDataSource
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: "favoriteCell")
        tableView.accessibilityIdentifier = "favoritesTableView"
        return tableView
    }()

    private lazy var searchResultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.delegate = searchResultsDataSource
        tableView.dataSource = searchResultsDataSource
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "SearchResultCell")
        tableView.accessibilityIdentifier = "searchResultsTableView"
        return tableView
    }()

    // MARK: - Data Sources
    private let searchResultsDataSource = SearchResultsDataSource()
    private let favoritesDataSource = FavoritesDataSource()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizationManager.localizedString(forKey: LocalizedKeys.Search.title)
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
        view.backgroundColor = UIColor.systemGroupedBackground
        view.addSubview(searchTextField)
        view.addSubview(favoritesTableView)
        view.addSubview(searchResultsTableView)

        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),

            favoritesTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            favoritesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            favoritesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            favoritesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),

            searchResultsTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Event Handlers
    private func setupEventHandlers() {
        searchResultsDataSource.didSelectLocation = { [weak self] location in
            self?.presenter?.didSelectLocation(location: location)
        }

        searchResultsDataSource.didTapFavorite = { [weak self] location in
            self?.presenter?.toggleFavorite(location: location)
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
        searchResultsDataSource.favoriteLocations = favorites
        DispatchQueue.main.async {
            self.toggleFavoritesVisibility()
            self.favoritesTableView.reloadData()
            self.searchResultsTableView.reloadData() 
        }
    }

    
    func isFavorite(location: FavoriteLocation) -> Bool {
        return favoritesDataSource.favorites.contains { $0.name == location.name }
    }

    func showError(_ message: String) {
        guard !(searchTextField.text?.isEmpty ?? true) else { return }
        
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let currentText = textField.text ?? ""
        
        if currentText.isEmpty {
            presenter?.loadFavorites()
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

        print("Buscando: \(updatedText)")

        if updatedText.isEmpty {
            presenter?.loadFavorites() 
        } else {
            presenter?.searchLocation(query: updatedText)
        }
        
        return true
    }
}


