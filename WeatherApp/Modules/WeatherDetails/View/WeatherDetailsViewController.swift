import UIKit

protocol WeatherDetailsViewProtocol {
    func showWeatherDetails(_ details: WeatherDetails)
    func showError(_ message: String)
}

class WeatherDetailsViewController: UIViewController, WeatherDetailsViewProtocol {
    var presenter: WeatherDetailsPresenterProtocol?

    private let locationLabel = UILabel()
    private let currentTempLabel = UILabel()
    private let forecastTableView = UITableView()

    private var forecastDays: [DayForecast] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupNavigationBar()  // 🔥 Se agrega el botón de "Atrás"
        presenter?.loadWeatherDetails()
    }

    private func setupUI() {
        locationLabel.textAlignment = .center
        locationLabel.font = UIFont.boldSystemFont(ofSize: 24)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false

        currentTempLabel.textAlignment = .center
        currentTempLabel.font = UIFont.systemFont(ofSize: 20)
        currentTempLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTempLabel.accessibilityIdentifier = "currentTempLabel"

        forecastTableView.translatesAutoresizingMaskIntoConstraints = false
        forecastTableView.dataSource = self
        forecastTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(locationLabel)
        view.addSubview(currentTempLabel)
        view.addSubview(forecastTableView)

        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            currentTempLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            currentTempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            forecastTableView.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor, constant: 20),
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
    }

    @objc private func backButtonTapped() {
        presenter?.navigateBack()  
    }

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let forecast = forecastDays[indexPath.row]
        cell.textLabel?.text = "\(forecast.date): \(forecast.day.avgtemp_c)°C - \(forecast.day.condition.text)"
        return cell
    }
}
