import HealthKit

extension Date {
    
    static func -(lhs: Date, rhs: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -rhs, to: lhs)!
    }
}

class HealthManager {
    
    var healthStore: HKHealthStore?
    var sevenDaysAgo: Date?
    
    init() {
        
        healthStore = HKHealthStore()
        let today = Date()
        sevenDaysAgo = today - 7
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
                
                getDistanceWalked()
                
                getStepCount()
                
            } catch {
                print("Encountered error = \(error)")
            }
            
        }
    }
    
    func getDistanceWalked() {
        let startDate = sevenDaysAgo

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
    
    func getStepCount() {
        //   Define the Step Quantity Type
          let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)

          //   Get the start of the day
        
         let startDate = sevenDaysAgo

          let date = Date()

          //  Set the Predicates & Interval
          let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
          var interval = DateComponents()
          interval.day = 1

          //  Perform the Query
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate! as Date, intervalComponents:interval)

          query.initialResultsHandler = { query, results, error in

              if error != nil {
                  return
              }
            var totalSteps: Double = 0
              if let myResults = results{
                  myResults.enumerateStatistics(from: startDate!, to: date) {
                      statistics, stop in

                      if let quantity = statistics.sumQuantity() {

                          let steps = quantity.doubleValue(for: HKUnit.count())

                          totalSteps += steps
                      }
                  }
              }
            print("Steps = \(totalSteps)")


          }

          healthStore?.execute(query)
    }
    
}
