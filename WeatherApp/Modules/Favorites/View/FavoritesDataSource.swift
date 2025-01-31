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
            cell.configure(with: favorite) { [weak self] in
                guard let self = self else { return }
                
                self.didRemoveFavorite?(favorite)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.favorites.removeAll { $0.name == favorite.name }
                    self.tableView?.reloadData()
                }
            }
            return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectFavorite?(favorites[indexPath.row])
    }
}
