import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Distance walked")
                .font(.title)
            Text(".... Miles")
                .font(.body)
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
