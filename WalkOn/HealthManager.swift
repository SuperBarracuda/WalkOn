import HealthKit

class HealthManager {
    
    var healthStore: HKHealthStore?
    
    init() {
        
        healthStore = HKHealthStore()
        
        let readData: Set<HKObjectType> = [
                    HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
                    HKObjectType.characteristicType(forIdentifier: .bloodType)!,
                    HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                    HKObjectType.quantityType(forIdentifier: .stepCount)!,
                    HKObjectType.quantityType(forIdentifier: .bodyMass)!
                ]
        
        let writeData: Set<HKSampleType> = []
        self.healthStore?.requestAuthorization(toShare: writeData, read: readData) { status, error in
       }
        
        
        if HKHealthStore.isHealthDataAvailable() {
            
            do {
                let sex = try healthStore?.biologicalSex()
                
                var gender = ""
                
                switch sex?.biologicalSex {
                case .male:
                    gender = "🙋‍♂️"
                case .female:
                    gender = "💁‍♀️"
                default:
                    gender = "😊"
                }
                
                print("Biological sex = \(gender)")
                
                
                getSteps()
                
            } catch {
                print("Encountered error = \(error)")
            }
            
        }
    }
    
    func getSteps() {
        let startDate = Date.init(timeIntervalSince1970: TimeInterval(1622246400))//Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!

        let endDate = Date()

        print("Collecting workouts between \(startDate) and \(endDate)")

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions.strictEndDate)

        let query = HKSampleQuery(sampleType: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            
            
            if let results = results {
                for item in results {
                    print(item)
                }
            }
            
        }

        healthStore?.execute(query)
    }
    
}
