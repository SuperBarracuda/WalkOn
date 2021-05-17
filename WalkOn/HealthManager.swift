import HealthKit

class HealthManager {
    
    init() {
        
        let healthStore = HKHealthStore()
        
        //Request users permission
        let allTypes = Set([HKObjectType.workoutType(),
                            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                            HKObjectType.quantityType(forIdentifier: .heartRate)!])

        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if !success {
                // Handle the error here.
            }
        }
        
        
        
        if HKHealthStore.isHealthDataAvailable() {
            
            do {
                let sex = try healthStore.biologicalSex()
                print("Biological sex = \(sex.description)")
            } catch {
                
            }
            
        }
    }
    
}
