//
//  ArtistViewController.swift
//  CleanSwiftByReni
//
//  Created by Bootcamp on 13/05/19.
//  Copyright (c) 2019 Bootcamp. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreLocation
import RxSwift

protocol ArtistDisplayLogic: class
{ 
    func displaySomething(viewModel: Artist.Artist.ResponseArtist)
    func displayTags(viewModel: Tags.TagsData.ResponseTags)
}

class ArtistViewController: UITableViewController, ArtistDisplayLogic, CLLocationManagerDelegate, UISearchResultsUpdating
{
    var interactor: ArtistBusinessLogic?
    var router: (NSObjectProtocol & ArtistRoutingLogic & ArtistDataPassing)?
    var data = Artist.Artist.ResponseDataArtist()
    var dataTags = Tags.TagsData.ResponseDataTag()
    var locationManager: CLLocationManager?
    var country: String = ""
    var refreshControll = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    let manager = LocalNotificationManager()
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup()
    {
        let viewController = self
        let interactor = ArtistInteractor()
        let presenter = ArtistPresenter()
        let router = ArtistRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        determineUserCurrentLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        refreshControll.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControll.addTarget(self, action: #selector(refresh1), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControll)
        doSomething()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candy"
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
        manager.notifications = [Notification(id: "reminder-1", title: "Remember drink milk!", datetime: DateComponents(calendar: Calendar.current, year: 2019, month: 5, day: 20, hour: 14, minute: 46))]
        manager.schedule()
        
    }
    
    
    func doSomething()
    {
        manager.listScheduleNotifications()
        let request = Artist.Artist.Request(method: "geo.gettopartists", country: country)
        interactor?.findTopArtists(request: request)
    }
    
    func findTopTag()
    {
        let request = Tags.TagsData.Request(method: "chart.gettoptags")
        interactor?.findNetworkTopTags(request: request)
    }
    
    func displaySomething(viewModel: Artist.Artist.ResponseArtist)
    {
        data = viewModel.topartists
        tableView.reloadData()
        refreshControll.endRefreshing()
    }
    
    func displayTags(viewModel: Tags.TagsData.ResponseTags )
    {
        dataTags = viewModel.tags
        tableView.reloadData()
        refreshControll.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch segmentControl.selectedSegmentIndex {
        case 0:
            count = data.artist.count
        case 1:
            count = dataTags.tag.count
        default:
            break
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch segmentControl.selectedSegmentIndex {
        case 0:
            cell.textLabel?.text = data.artist[indexPath.row].name
        case 1:
            cell.textLabel?.text = dataTags.tag[indexPath.row].name
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.dataStore?.name = data.artist[indexPath.row].url
        router?.routeToDetail(segue: nil)
    }
    
    func determineUserCurrentLocation()  {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping(_ city: String?, _ country: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) {placemarks, error in
            completion(placemarks?.first?.locality, placemarks?.first?.country, error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        fetchCityAndCountry(from: CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)) { city, country, error in
            guard let city = city, let country = country, error == nil else {return}
            self.country = country
            print("negara: \(country)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    @objc func refresh1() {
        print("refreshcoy")
        if  Connectivity.isConnectedToInternet() {
            print(" there is an conectivity ")
            let request = Artist.Artist.Request(method: "geo.gettopartists", country: country)
            interactor?.findNetworkTopArtists(request: request)
        } else {
            print("No conectivity found")
            refreshControll.endRefreshing()
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scoope: String = "All") {
        print(searchText)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    @IBAction func changeComponent(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            doSomething()
        case 1:
            findTopTag()
        default:
            break
        }
    
    
    }
    
}
