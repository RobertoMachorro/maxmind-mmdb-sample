//
//  main.swift
//  maxmind-mmdb-sample
//
//  Created by Roberto Machorro on 9/24/22.
//

import Foundation
import MMDB

let testIP = "YOURIP"
let pathToMMDBFile = "YOURPATH/GeoLite2-Country.mmdb"

let mmdbFileUrl = URL(fileURLWithPath: pathToMMDBFile)
if let geolite = GeoLite2CountryDatabase(from: mmdbFileUrl) {
	print(geolite.countryCode(address: testIP) ?? "not found")

	switch geolite.search(address: testIP) {
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
			print("country_isocode=\(country_isocode) country_name=\(country_name)")
		}
	case .failed(_):
		print("Search failed.")
	}
}
