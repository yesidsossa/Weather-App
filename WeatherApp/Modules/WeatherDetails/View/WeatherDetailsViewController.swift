import UIKit

protocol WeatherDetailsViewProtocol {
    func showWeatherDetails(_ details: WeatherDetails)
    func showError(_ message: String)
}

class WeatherDetailsViewController: UIViewController, WeatherDetailsViewProtocol {
    
    // MARK: - Properties
    var presenter: WeatherDetailsPresenterProtocol?
    private var forecastDays: [DayForecast] = []

    // MARK: - UI Elements
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24) 
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()

    private lazy var currentTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .blue
        label.accessibilityIdentifier = "currentTempLabel"
        return label
    }()

    private lazy var forecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ForecastCell.self, forCellReuseIdentifier: ForecastCell.identifier)
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizationManager.localizedString(forKey: LocalizedKeys.WeatherDetails.title)
        setupUI()
        setupNavigationBar()
        presenter?.loadWeatherDetails()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(containerView)
        containerView.addSubview(locationLabel)
        containerView.addSubview(currentTempLabel)
        view.addSubview(forecastTableView)

        NSLayoutConstraint.activate([
            // Contenedor
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Ubicación
            locationLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // Temperatura
            currentTempLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            currentTempLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            currentTempLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

            // Tabla de pronóstico
            forecastTableView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            forecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            forecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            forecastTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "backButton"

    }

    // MARK: - Actions
    @objc private func backButtonTapped() {
        presenter?.navigateBack()
    }

    // MARK: - WeatherDetailsViewProtocol
    func showWeatherDetails(_ details: WeatherDetails) {
        locationLabel.text = "\(details.location.name), \(details.location.country)"
        currentTempLabel.text = LocalizationManager.localizedString(
            forKey: LocalizedKeys.WeatherDetails.temperature,
            with: String(format: "%.1f", details.current.temp_c)
        )
        forecastDays = details.forecast.forecastday
        forecastTableView.reloadData()
    }

    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension WeatherDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastDays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.identifier, for: indexPath) as! ForecastCell
        let forecast = forecastDays[indexPath.row]
        cell.configure(with: forecast)
        return cell
    }
}
