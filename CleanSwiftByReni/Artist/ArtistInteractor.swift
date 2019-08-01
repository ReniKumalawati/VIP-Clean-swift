//
//  ArtistInteractor.swift
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

protocol ArtistBusinessLogic
{
    func doSomething(request: Artist.Artist.Request)
    func findTopArtists(request: Artist.Artist.Request)
    func findNetworkTopArtists(request: Artist.Artist.Request)
    func findNetworkTopTags(request: Tags.TagsData.Request)
}

protocol ArtistDataStore
{
  var name: String { get set }
}

class ArtistInteractor: ArtistBusinessLogic, ArtistDataStore
{
    
    var presenter: ArtistPresentationLogic?
    var worker: ArtistWorker?
    var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: Artist.Artist.Request)
    {
        worker = ArtistWorker()
        worker?.doSomeWork()
    }
    
    func findTopArtists(request: Artist.Artist.Request)
    {
        worker = ArtistWorker()
        worker?.findTopChart(request: request){ response in
            let response = response
            self.presenter?.presentSomething(response: response)
        }
    }
    
    func findNetworkTopArtists(request: Artist.Artist.Request)
    {
        worker = ArtistWorker()
        worker?.findAllArtistfromNetwork(request: request){ response in
            let response = response
            self.presenter?.presentSomething(response: response)
        }
    }
    
    func findNetworkTopTags(request: Tags.TagsData.Request)
    {
        worker = ArtistWorker()
        worker?.findAllTagsfromNetwork(request: request){ response in
            let response = response
            self.presenter?.presentTags(response: response)
        }
    }
}
