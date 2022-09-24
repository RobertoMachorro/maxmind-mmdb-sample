//
//  main.swift
//  maxmind-mmdb-sample
//
//  Created by Roberto Machorro on 9/24/22.
//

import Foundation
import MMDB

let testIP = "YOURIP"
let basePath = "YOUR PATH TO MMDB FILES"

let countryFileUrl = URL(fileURLWithPath: basePath + "GeoLite2-Country.mmdb")
if let countrydb = GeoLite2CountryDatabase(from: countryFileUrl) {
	// Convenience method to get country ISO code:
	print(countrydb.countryCode(address: testIP) ?? "not found")

	// Fetch country and details from record
	switch countrydb.search(address: testIP) {
	case .notFound:
		print("Data file not found.")
	case .partial(_):
		print("Partial.")
	case .value(let v):
		if case let .map(m) = v,
		   case let .map(country) = m["country"],
		   case let .string(country_isocode) = country["iso_code"],
		   case let .map(country_names) = country["names"],
		   case let .string(country_name) = country_names["en"]
		{
			print("\(country_name) / \(country_isocode)")
		}
	case .failed(_):
		print("Search failed.")
	}
}

// There is no wrapper class for City or other files, so using MMDB directly

let cityFileUrl = URL(fileURLWithPath: basePath + "GeoLite2-City.mmdb")
if let citydb = MMDB(from: cityFileUrl) {
	// Fetch country and details from record
	switch citydb.search(address: testIP) {
	case .notFound:
		print("Data file not found.")
	case .partial(_):
		print("Partial.")
	case .value(let v):
		if case let .map(m) = v,
		   case let .map(country) = m["country"],
		   case let .string(country_isocode) = country["iso_code"],
		   case let .map(country_names) = country["names"],
		   case let .string(country_name) = country_names["en"],
		   case let .map(location) = m["location"],
		   case let .string(timezone) = location["time_zone"],
		   case let .double(longitude) = location["longitude"],
		   case let .double(latitude) = location["latitude"],
		   case let .uint16(accuracyRadius) = location["accuracy_radius"],
		   case let .map(city) = m["city"],
		   case let .map(city_names) = city["names"],
		   case let .string(city_name) = city_names["en"],
		   case let .map(postal) = m["postal"],
		   case let .string(postalCode) = postal["code"]
		{
			print("country_isocode=\(country_isocode) name=\(country_name) timezone=\(timezone) longitude=\(longitude) latitude=\(latitude) accuracyRadius=\(accuracyRadius) city_name=\(city_name) postalCode=\(postalCode)")
		}
	case .failed(let reason):
		print("Search failed [\(reason)].")
	}
}
