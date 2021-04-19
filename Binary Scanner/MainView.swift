//
//  MainView.swift
//  Binary Scanner
//
//  Created by Jonathan Dowdell on 4/18/21.
//

import SwiftUI

struct MainView: View {
    
    @State private var showingScanningView = false
    @State private var recognizedText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text(recognizedText)
                
                Button(action: {
                    showingScanningView = true
                }, label: {
                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                })
            }
        }
        .navigationTitle("Scan Binary")
        .sheet(isPresented: $showingScanningView, content: {
            ScanDocumentView(recognizedText: $recognizedText)
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
