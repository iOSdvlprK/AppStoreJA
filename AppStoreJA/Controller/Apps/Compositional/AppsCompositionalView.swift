//
//  AppsCompositionalView.swift
//  AppStoreJA
//
//  Created by joe on 2023/05/30.
//

import SwiftUI

class CompositionalController: UICollectionViewController {
    
    init() {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.bottom = 16
        item.contentInsets.trailing = 16
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 32
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = .systemRed
        return cell
    }
}

class NavController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        let newNavBarAppearance = UINavigationBarAppearance()
        newNavBarAppearance.configureWithDefaultBackground()
        newNavBarAppearance.backgroundColor = .clear
        newNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        newNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().scrollEdgeAppearance = newNavBarAppearance
        UINavigationBar.appearance().compactAppearance = newNavBarAppearance
        UINavigationBar.appearance().standardAppearance = newNavBarAppearance
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct AppsView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = CompositionalController()
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
    
}

/*
struct AppsCompositionalView: View {
    var body: some View {
        Text("MODIFY")
    }
}
*/

struct AppsCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
            .edgesIgnoringSafeArea(.all)
    }
}
