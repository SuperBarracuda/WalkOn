import SwiftUI

struct ContentView: View {
        
    var body: some View {
        VStack {
            Text("Distance walked")
                .font(.title)
                .foregroundColor(.blue)
            Text("\(String(format:"%.1f", locale: Locale.current, sharedHealthManager.distanceWalked ?? 0)) Miles")
                .font(.body)
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))

    }
}
