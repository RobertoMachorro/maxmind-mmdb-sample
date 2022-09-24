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
}
