//
//  ViewController.swift
//  MusicApi
//
//  Created by 浦山秀斗 on 2024/10/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    private var repository: MusicRepository = MusicRepository()
    private var musics: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Task {
            do {
                let fetchedMusics = try await repository.fetchMusics(keyword: searchBar.text ?? "")
                musics = fetchedMusics ?? []
                tableView.reloadData()
            } catch(MusicError.invalidURL) {
                print("Error: invalid URL")
            } catch(MusicError.invalidResponse) {
                print("Error: invalid Response")
            } catch(MusicError.notFound) {
                print("Error: Music not found")
            } catch {
                print("想定外のエラー")
            }
        }
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.image = musics[indexPath.row].artistImage
        content.text = musics[indexPath.row].trackName
        
        cell.contentConfiguration = content
        return cell
    }
}

extension URL {
    func image() async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: self)
            guard let image = UIImage(data: data) else { return nil }
            return image
        } catch {
            return nil
        }
    }
}
