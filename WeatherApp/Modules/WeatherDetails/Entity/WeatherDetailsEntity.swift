import Foundation

struct WeatherDetails: Codable {
    let location: LocationInfo
    let current: CurrentWeather
    let forecast: ForecastInfo
}

struct LocationInfo: Codable {
    let name: String
    let country: String
}

struct CurrentWeather: Codable {
    let temp_c: Double
    let condition: WeatherCondition
}

struct ForecastInfo: Codable {
    let forecastday: [DayForecast]
}

struct DayForecast: Codable {
    let date: String
    let day: DayWeather
}

struct DayWeather: Codable {
    let avgtemp_c: Double
    let condition: WeatherCondition
}

struct WeatherCondition: Codable {
    let text: String
    let icon: String
}
