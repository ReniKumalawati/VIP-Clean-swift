//
//  ArtistPresenter.swift
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

protocol ArtistPresentationLogic
{
  func presentSomething(response: Artist.Artist.ResponseArtist)
}

class ArtistPresenter: ArtistPresentationLogic
{
  weak var viewController: ArtistDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Artist.Artist.ResponseArtist)
  {
    viewController?.displaySomething(viewModel: response)
  }
}
