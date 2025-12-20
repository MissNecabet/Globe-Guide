//
//  DetailsModel.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 20.12.25.
//

import Foundation

// back dan gelen details MOdeli
struct DetailsResponse: Decodable {
    let name: Name
    let tld: [String]?
    let cca2: String?
    let ccn3: String?
    let cioc: String?
    let independent: Bool?
    let status: String?
    let unMember: Bool?
    let currencies: [String: Currency]?
    let idd: IDD?
    let capital: [String]?
    let altSpellings: [String]?
    let region: String?
    let subregion: String?
    let languages: [String: String]?
    let latlng: [Double]?
    let landlocked: Bool?
    let borders: [String]?
    let area: Double?
    let demonyms: [String: Demonyms]?
    let cca3: String?
    let translations: [String: Translation]?
    let flag: String?
    let maps: Maps?
    let population: Int?
    let gini: [String: Double]?
    let fifa: String?
    let car: Car?
    let timezones: [String]?
    let continents: [String]?
    let flags: Flags?
    let coatOfArms: CoatOfArms?
    let startOfWeek: String?
    let capitalInfo: CapitalInfo?
    let postalCode: PostalCode?
}

struct Name: Decodable {
    let common: String?
    let official: String?
    let nativeName: [String: NativeName]?
}

struct NativeName: Decodable {
    let official: String?
    let common: String?
}

struct Currency: Decodable {
    let name: String?
    let symbol: String?
}

struct IDD: Decodable {
    let root: String?
    let suffixes: [String]?
}

struct Demonyms: Decodable {
    let f: String?
    let m: String?
}

struct Translation: Decodable {
    let official: String?
    let common: String?
}

struct Maps: Decodable {
    let googleMaps: String?
    let openStreetMaps: String?
}

struct Car: Decodable {
    let signs: [String]?
    let side: String?
}

struct Flags: Decodable {
    let png: String?
    let svg: String?
    let alt: String?
}

struct CoatOfArms: Decodable {
    let png: String?
    let svg: String?
}

struct CapitalInfo: Decodable {
    let latlng: [Double]?
}

struct PostalCode: Decodable {
    let format: String?
    let regex: String?
}


// bize lazim olan details modeli
struct CountryInfo {
    let currencies: [String: String]?
    let capital: [String]?
    let region: String?
    let subregion: String?
    let languages: [String: String]?
    let borders: [String]?
    let flag: String?
    let population: Int?
    let flagAlt: String?
}
