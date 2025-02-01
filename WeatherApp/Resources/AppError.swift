//
//  AppError.swift
//  WeatherApp
//
//  Created by Yesid Hernandez on 31/01/25.
//


enum AppError: Error {
    case networkError
    case apiError(message: String)
    case parsingError
    case unknown

    var localizedDescription: String {
        switch self {
        case .networkError:
            return "No hay conexión a Internet."
        case .apiError(let message):
            return "Error de API: \(message)"
        case .parsingError:
            return "Error al procesar los datos."
        case .unknown:
            return "Ocurrió un error inesperado."
        }
    }
}
