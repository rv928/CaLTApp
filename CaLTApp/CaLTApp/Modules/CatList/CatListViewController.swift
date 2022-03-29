//
//  CatListViewController.swift
//  CaLTApp
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/24.
//

import UIKit
private let kPageSize = 10

protocol CatListView {
    func displayCatList(axCatList: [CatListViewModel])
    func showLoading()
    func hideLoading()
    func showAlertError(errorHandler: ErrorHandler)
}

class CatListViewController: UIViewController {
    
    @IBOutlet weak private var catListTableView: UITableView?
    var interactor: CatListBusinessLogic?
    var router: CatListRouterInterface?
    private var catList: [CatListViewModel]? = []
    private var currentPage: Int = 0
    
    // MARK: - Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil:
                    Bundle?) {
        super.init(nibName: nibNameOrNil, bundle:nibBundleOrNil)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init(interatcor: CatListBusinessLogic? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.interactor = interatcor
    }
    
    // MARK: - Setup
    private func setup() {
        let router = CatListRouter()
        router.viewController = self
        
        let presenter = CatListPresenter(viewController: self)
        presenter.catListView = self
        
        let interactor = CatListInteractor(presenter: presenter)
        interactor.presenter = presenter
        
        self.interactor = interactor
        self.router = router
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setUpCatListTableView()
        setupUI()
        self.fetchCatList()
    }
    
    override func viewDidLayoutSubviews() {
        self.catListTableView?.frame = view.bounds
    }
    
    private func setupUI() {
        self.catListTableView?.isHidden = true
    }
    
    private func setUpCatListTableView() {
        self.catListTableView?.separatorInset = .zero
        self.catListTableView?.layoutMargins = .zero
        self.catListTableView?.tableFooterView = UIView(frame: .zero)
        self.catListTableView?.register(UINib(nibName: "CatListCell", bundle: nil), forCellReuseIdentifier: "CatListCell")
        self.catListTableView?.accessibilityIdentifier = "tableView--catListTableView"
    }
    
    /*
     * This method will setup NavigationBar
     */
    private func setupNavigationBar() {
        self.navigationItem.title = "Cats"
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    private func fetchCatList() {
        DispatchQueue.main.async {
            self.interactor?.showLoading()
        }
        let request = CatListModel.Request(limit: kPageSize, page: currentPage)
        self.interactor?.fetchCatList(request: request)
    }
    
    func navigateToDetailView(catViewModel: CatListViewModel) {
        self.router?.navigateToCatDetailView(catViewModel: catViewModel)
    }
}

extension CatListViewController: CatListView {
    
    func displayCatList(axCatList: [CatListViewModel]) {
        
        for(index, _) in axCatList.enumerated() {
            let catmodel: CatListViewModel = axCatList[index]
            self.catList?.append(catmodel)
        }
        DispatchQueue.main.async {
            self.catListTableView?.isHidden = false
            self.catListTableView?.delegate = self
            self.catListTableView?.dataSource = self
            self.catListTableView?.reloadData()
        }
    }
    
    func showLoading() {
        self.showProgressHUD()
    }
    
    func hideLoading() {
        self.hideProgressHUD()
    }
    
    func showAlertError(errorHandler: ErrorHandler) {
        self.presentAlert(errorHandler: errorHandler)
    }
}

extension CatListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cats = self.catList {
            return cats.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CatListCell", for: indexPath) as? CatListCell {
            cell.accessibilityIdentifier = "CatListCell\(indexPath.row)"
            if let cats = self.catList {
                let catcellData = cats[indexPath.row]
                cell.prepareCell(with: catcellData)
                return cell
            }
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

extension CatListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let catDetailViewModel = self.catList?[indexPath.row]
        if let detailVMModel = catDetailViewModel {
            self.navigateToDetailView(catViewModel: detailVMModel)
        }
    }
}

// MARK:- UIScrollViewDelegate
extension CatListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - currentOffset <= 10.0) {
            self.currentPage = self.currentPage + 1
            self.fetchCatList()
        }
    }
}
