//
//  FavoritesManager.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 26.12.25.
//
import CoreData
import Foundation
import CoreData
import CoreLocation

import CoreData

final class FavoritesCoreDataManager {

    static let shared = FavoritesCoreDataManager()
    private let context = PersistenceController.shared.container.viewContext

    // MARK: - Check
    func isFavorite(place: Place) -> Bool {
        let request: NSFetchRequest<FavoriteCountryEntity> =
            FavoriteCountryEntity.fetchRequest()

        request.predicate = NSPredicate(format: "name == %@", place.name)
        return (try? context.count(for: request)) ?? 0 > 0
    }

    // MARK: - Add (PLACE saxlanır)
    func add(place: Place, country: Country) {
        guard !isFavorite(place: place) else { return }

        let fav = FavoriteCountryEntity(context: context)
        fav.name = place.name
        fav.imageUrl = place.photoReference
        fav.latitude = country.coordinate.latitude
        fav.longitude = country.coordinate.longitude
        fav.createdAt = Date()

        try? context.save()
    }

    // MARK: - Remove
    func remove(place: Place) {
        let request: NSFetchRequest<FavoriteCountryEntity> =
            FavoriteCountryEntity.fetchRequest()

        request.predicate = NSPredicate(format: "name == %@", place.name)

        if let item = try? context.fetch(request).first {
            context.delete(item)
            try? context.save()
        }
    }

    // MARK: - Fetch
    func fetchFavorites() -> [FavoriteCountryEntity] {
        let request: NSFetchRequest<FavoriteCountryEntity> =
            FavoriteCountryEntity.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]

        return (try? context.fetch(request)) ?? []
    }
}
