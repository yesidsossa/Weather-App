import UIKit

class FavoritesDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    weak var tableView: UITableView? 
    var favorites: [FavoriteLocation] = [] {
        didSet {
            tableView?.reloadData()
        }
    }

    var didSelectFavorite: ((FavoriteLocation) -> Void)?
    var didRemoveFavorite: ((FavoriteLocation) -> Void)?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.configure(with: favorite) {
            self.didRemoveFavorite?(favorite)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectFavorite?(favorites[indexPath.row])
    }
}
