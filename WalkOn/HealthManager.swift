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

        
        let sumOption = HKStatisticsOptions.cumulativeSum
        
        
        
        var distanceTotalLength: Double = 0
        let statisticsSumQuery = HKStatisticsQuery(quantityType: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!, quantitySamplePredicate: predicate, options: sumOption) {
                 (query, result, error) in
                if let sumQuantity = result?.sumQuantity() {
                    DispatchQueue.main.async {
                        let totalDistance = sumQuantity.doubleValue(for:.mile())
                        distanceTotalLength = totalDistance
                        print("Total distance covered = \(String(format:"%.2f", distanceTotalLength)) Miles")
                    }
                }
            }
        healthStore?.execute(statisticsSumQuery)
    }
    
}
