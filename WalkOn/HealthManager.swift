import HealthKit

class HealthManager {
    
    init() {
        
        let healthStore = HKHealthStore()
        
        let readData: Set<HKObjectType> = [
                    HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
                    HKObjectType.characteristicType(forIdentifier: .bloodType)!,
                    HKObjectType.quantityType(forIdentifier: .stepCount)!,
                    HKObjectType.quantityType(forIdentifier: .bodyMass)!
                ]
        
        let writeData: Set<HKSampleType> = []
       healthStore.requestAuthorization(toShare: writeData, read: readData) { status, error in
       }
        
        
        if HKHealthStore.isHealthDataAvailable() {
            
            do {
                let sex = try healthStore.biologicalSex()
                
                var gender = ""
                
                switch sex.biologicalSex {
                case .male:
                    gender = "🙋‍♂️"
                case .female:
                    gender = "💁‍♀️"
                default:
                    gender = "😊"
                }
                
                print("Biological sex = \(gender)")
                
                
                
            } catch {
                print("Encountered error = \(error)")
            }
            
        }
    }
    
}
