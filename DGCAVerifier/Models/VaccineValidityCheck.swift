//
//  VaccineValidityCheck.swift
//  Verifier
//
//  Created by Davide Aliti on 21/05/21.
//

import Foundation
import SwiftDGC

struct VaccineValidityCheck {
    
    func checkVaccineDate(_ hcert: HCert) -> Bool {
        let vaccineDoseString = hcert.statement.typeAddon
        let vaccineDosesArray = getDosesFromDoseString(from: vaccineDoseString)
        
        let isLastDose = vaccineDosesArray.first == vaccineDosesArray.last
        
        let vaccineMedicalProduct = hcert.statement.info.filter{ $0.header == l10n("vaccine.product")}.first?.content ?? ""
        let availableMedicalProductsInSettings = LocalData.sharedInstance.settings.filter { $0.name == "vaccine_end_day_complete"}.map { $0.type }
        let vaccineMedicalProductCode = availableMedicalProductsInSettings.filter { l10n("vac.product.\($0)") == vaccineMedicalProduct }
        
        // Vaccine code not included in settings -> not a valid vaccine for Italy
        if vaccineMedicalProductCode.isEmpty {
            return false
        }
        // Vaccine code included in settings -> check dates, checking if it is lastDose or not too
        let settingsNameStartDays = isLastDose ? "vaccine_start_day_complete" : "vaccine_start_day_not_complete"
        let settingsNameEndDays = isLastDose ? "vaccine_end_day_complete" : "vaccine_end_day_not_complete"
        let vaccineStartDays = LocalData.sharedInstance.settings.filter{ $0.name == settingsNameStartDays && $0.type == vaccineMedicalProductCode[0] }.first?.value ?? "0"
        let vaccineEndDays = LocalData.sharedInstance.settings.filter{ $0.name == settingsNameEndDays  && $0.type == vaccineMedicalProductCode[0] }.first?.value ?? "0"
        let dateOfVaccinationAsString = hcert.statement.info.filter{ $0.header == l10n("vaccine.date")}.first?.content
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        let dateOfVaccination = dateFormatter.date(from: dateOfVaccinationAsString!)
        let vaccineValidityStart = Calendar.current.date(byAdding: .day, value: Int(vaccineStartDays) ?? 0, to: dateOfVaccination!)!
        let vaccineValidityEnd = Calendar.current.date(byAdding: .day, value: Int(vaccineEndDays) ?? 0, to: dateOfVaccination!)!
        
        return (Date() > vaccineValidityStart && Date() < vaccineValidityEnd)
    }
    
    func getDosesFromDoseString(from doseString: String) -> [Int] {
        let doseStringArray = doseString.components(separatedBy: CharacterSet.decimalDigits.inverted)
        return doseStringArray.compactMap { Int($0) }
    }
}