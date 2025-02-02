import UIKit

class SearchResultsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    weak var tableView: UITableView?
    var locations: [Location] = []
    var favoriteLocations: [FavoriteLocation] = []
    
    var didSelectLocation: ((Location) -> Void)?
    var didTapFavorite: ((Location) -> Void)?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else {
            return UITableViewCell()
        }
        
        let location = locations[indexPath.row]
        
        // 🔹 Comparación más precisa: Se usa nombre y país
        let isFavorite = favoriteLocations.contains { $0.name == location.name && $0.country == location.country }
        
        cell.configure(with: location, isFavorite: isFavorite) { [weak self] in
            self?.didTapFavorite?(location)
            
            // 🔹 Solo cambiar el estado del favorito seleccionado, no de todos los que tengan el mismo nombre
            if let index = self?.locations.firstIndex(where: { $0.name == location.name && $0.country == location.country }) {
                let newFavoriteState = !(self?.favoriteLocations.contains { $0.name == location.name && $0.country == location.country } ?? false)
                if let selectedCell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SearchResultCell {
                    selectedCell.updateFavoriteIcon(isFavorite: newFavoriteState)
                }
            }
        }
        
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        didSelectLocation?(location)
    }
}
