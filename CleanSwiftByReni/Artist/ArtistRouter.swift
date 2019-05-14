//
//  ArtistRouter.swift
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

@objc protocol ArtistRoutingLogic
{
  func routeToDetail(segue: UIStoryboardSegue?)
}

protocol ArtistDataPassing
{
  var dataStore: ArtistDataStore? { get set }
}

class ArtistRouter: NSObject, ArtistRoutingLogic, ArtistDataPassing
{
  weak var viewController: ArtistViewController?
  var dataStore: ArtistDataStore?
  
  // MARK: Routing
  
  func routeToDetail(segue: UIStoryboardSegue?)
  {
    if let segue = segue {
      let destinationVC = segue.destination as! DetailViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    } else {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! DetailViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToSomewhere(source: dataStore!, destination: &destinationDS)
      navigateToSomewhere(source: viewController!, destination: destinationVC)
    }
  }

  // MARK: Navigation
  
  func navigateToSomewhere(source: ArtistViewController, destination: DetailViewController)
  {
    source.show(destination, sender: nil)
  }
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: ArtistDataStore, destination: inout DetailDataStore)
  {
    destination.name = source.name
  }
}
