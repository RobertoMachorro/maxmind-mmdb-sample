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
