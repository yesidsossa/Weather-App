import UIKit

class SearchResultsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    weak var tableView: UITableView?
    var locations: [Location] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    var didSelectLocation: ((Location) -> Void)?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else {
            return UITableViewCell()
        }
        
        let location = locations[indexPath.row]
        cell.configure(with: location)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectLocation?(locations[indexPath.row])
    }
}
