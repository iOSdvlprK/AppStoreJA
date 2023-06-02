//
//  DiffableController.swift
//  AppStoreJA
//
//  Created by joe on 2023/06/01.
//

import SwiftUI

class DiffableController: UICollectionViewController {
    init() {
        let layout = UICollectionViewCompositionalLayout { sectionNumber, _ in
            if sectionNumber == 0 {
                return DiffableController.topSection()
            } else {
                // second section
                
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 16)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets.leading = 16
                
                let kind = UICollectionView.elementKindSectionHeader
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: kind, alignment: .topLeading)
                ]
                
                return section
            }
        }
        
        super.init(collectionViewLayout: layout)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CompositionalHeader
//        var title: String?
//        if indexPath.section == 1 {
//            title = group1?.feed.title
//        } else if indexPath.section == 2 {
//            title = group2?.feed.title
//        } else {
//            title = group3?.feed.title
//        }
//        header.label.text = title
//        return header
//    }
    
    static func topSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.bottom = 16
        item.contentInsets.trailing = 16
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        return section
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: "smallCellId")
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        fetchApps()
        setupDiffableDataSource()
    }
    
    enum AppSection {
        case topSocial
        case topFree
        case topPaid
        case krApp
    }
    
    lazy var diffableDataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable> = UICollectionViewDiffableDataSource(collectionView: self.collectionView) { collectionView, indexPath, object in
        if let object = object as? SocialApp {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
            cell.app = object
            return cell
            
        } else if let object = object as? FeedResult {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppRowCell
            cell.app = object
            cell.getButton.addTarget(self, action: #selector(self.handleGet), for: .primaryActionTriggered)
            return cell
        }
        
        return nil
    }
    
    @objc func handleGet(button: UIView) {
        var superview = button.superview
        
        // logic to reach the parent cell of the 'get' button
        while superview != nil {
            if let cell = superview as? UICollectionViewCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                guard let objectIClickedOnto = diffableDataSource.itemIdentifier(for: indexPath) else { return }
//                print(objectIClickedOnto)
                
                var snapshot = diffableDataSource.snapshot()
                snapshot.deleteItems([objectIClickedOnto])
                diffableDataSource.apply(snapshot)
            }
            superview = superview?.superview
        }
    }
    
    var title1: String?
    var title2: String?
    var title3: String?
    
    private func setupDiffableDataSource() {
//        collectionView.dataSource = diffableDataSource
        
        diffableDataSource.supplementaryViewProvider = .some({ collectionView, elementKind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: self.headerId, for: indexPath) as! CompositionalHeader
            
            let snapshot = self.diffableDataSource.snapshot()
            if let object = self.diffableDataSource.itemIdentifier(for: indexPath) {
                if let section = snapshot.sectionIdentifier(containingItem: object) {
                    if section == .topFree {
                        header.label.text = self.title1
                    } else if section == .topPaid {
                        header.label.text = self.title2
                    } else {
                        header.label.text = self.title3
                    }
                }
            }
            return header
        })
        
        Service.shared.fetchSocialApps { socialApps, err in
            Service.shared.fetchTopFreeApps { appGroup, err in
                Service.shared.fetchTopPaidApps { paidGroup, err in
                    Service.shared.fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/kr/apps/top-free/50/apps.json") { krGroup, err in
                        var snapshot = self.diffableDataSource.snapshot()
                        
                        // top social
                        snapshot.appendSections([.topSocial])
                        snapshot.appendItems(socialApps ?? [])
                        
                        // top free
                        snapshot.appendSections([.topFree])
                        let objects = appGroup?.feed.results ?? []
                        self.title1 = appGroup?.feed.title ?? ""
                        snapshot.appendItems(objects)
                        
                        // top paid
                        snapshot.appendSections([.topPaid])
                        self.title2 = paidGroup?.feed.title ?? ""
                        snapshot.appendItems(paidGroup?.feed.results ?? [])
                        
                        // kr app
                        snapshot.appendSections([.krApp])
                        self.title3 = krGroup?.feed.title ?? ""
                        snapshot.appendItems(krGroup?.feed.results ?? [])
                        
                        self.diffableDataSource.apply(snapshot)
                    }
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = diffableDataSource.itemIdentifier(for: indexPath)
        
        if let object = object as? SocialApp {
            let appDetailController = AppDetailController(appId: object.id)
            navigationController?.pushViewController(appDetailController, animated: true)
            
        } else if let object = object as? FeedResult {
            let appDetailController = AppDetailController(appId: object.id)
            navigationController?.pushViewController(appDetailController, animated: true)
        }
    }
    
//    var socialApps = [SocialApp]()
//    var group1: AppGroup?
//    var group2: AppGroup?
//    var group3: AppGroup?
//
//    private func fetchApps() {
//        // fire all fetches at once
//        fetchAppsDispatchGroup()
//    }
    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 0
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return socialApps.count
//        } else if section == 1 {
//            return group1?.feed.results.count ?? 0
//        } else if section == 2 {
//            return group2?.feed.results.count ?? 0
//        } else {
//            return group3?.feed.results.count ?? 0
//        }
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let appId: String
//        if indexPath.section == 0 {
//            appId = socialApps[indexPath.item].id
//        } else if indexPath.section == 1 {
//            appId = group1?.feed.results[indexPath.item].id ?? ""
//        } else if indexPath.section == 2 {
//            appId = group2?.feed.results[indexPath.item].id ?? ""
//        } else {
//            appId = group3?.feed.results[indexPath.item].id ?? ""
//        }
//        let appDetailController = AppDetailController(appId: appId)
//        navigationController?.pushViewController(appDetailController, animated: true)
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.section {
//        case 0:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
//            cell.app = self.socialApps[indexPath.item]
//            return cell
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppRowCell
//            var appGroup: AppGroup?
//            if indexPath.section == 1 {
//                appGroup = group1
//            } else if indexPath.section == 2 {
//                appGroup = group2
//            } else {
//                appGroup = group3
//            }
//            cell.app = appGroup?.feed.results[indexPath.item]
//            return cell
//        }
//    }
    
    class CompositionalHeader: UICollectionReusableView {
        
        let label = UILabel(text: "Editor's Choice Games", font: .boldSystemFont(ofSize: 32))
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(label)
            label.fillSuperview()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

//extension DiffableController {
//    func fetchAppsDispatchGroup() {
//        let dispatchGroup = DispatchGroup()
//
//        dispatchGroup.enter()
//        Service.shared.fetchSocialApps { apps, err in
//            self.socialApps = apps ?? []
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.enter()
//        Service.shared.fetchTopFreeApps { appGroup, err in
//            self.group1 = appGroup
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.enter()
//        Service.shared.fetchTopPaidApps { appGroup, err in
//            self.group2 = appGroup
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.enter()
//        Service.shared.fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/kr/apps/top-free/50/apps.json") { appGroup, err in
//            self.group3 = appGroup
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.notify(queue: .main) {
//            self.collectionView.reloadData()
//        }
//    }
//}

struct DiffableView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = DiffableController()
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
}

struct DiffableController_Previews: PreviewProvider {
    static var previews: some View {
        DiffableView()
            .edgesIgnoringSafeArea(.all)
    }
}
