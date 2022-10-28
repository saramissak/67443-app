//
//  ContentView.swift
//  TuneIn-Firebase
//
//  Created by The Family on 10/26/22.
//

import SwiftUI

struct ContentView: View {
  var test = Test()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Text(test.setName(name: "stella"))

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
