//
//  MainView.swift
//  Binary Scanner
//
//  Created by Jonathan Dowdell on 4/18/21.
//

import SwiftUI
import BigNumber
import MobileCoreServices

struct MainView: View {
    
    @State private var showingScanningView = false
    @State private var recognizedText = ""
    
    @State private var fromBase = ""
    @State private var fromNumber = ""
    
    @State private var toBase = ""
    @State private var toNumber = ""
    
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("FROM")) {
                    HStack {
                        Text("Base")
                        
                        TextField("1-36", text: $fromBase)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Value")
                        TextField("Number", text: $fromNumber)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Button(action: {
                            showingScanningView = true
                        }, label: {
                            HStack {
                                Text("Scan Value")
                                Spacer()
                                Image(systemName: "doc.text.viewfinder")
                            }
                        })
                    }
                }
                
                
                Section(header: Text("TO")) {
                    HStack {
                        Text("Base")
                        
                        TextField("1-36", text: $toBase)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Button(action: convertBase, label: {
                            HStack {
                                Text("Convert")
                                Spacer()
                                Image(systemName: "square.and.line.vertical.and.square.fill")
                            }
                        })
                    }
                }
                
                if !toNumber.isEmpty {
                    Section {
                        Text(toNumber)
                            .font(.title)
                            .bold()
                            .onTapGesture(perform: copyToClipboard)
                    }
                    .contextMenu(ContextMenu(menuItems: {
                        Button(action: copyToClipboard, label: {
                            Text("Copy")
                        })
                        
                        Button(action: copyToFrom, label: {
                            Text("Copy To From")
                        })
                    }))
                    
                }
                
                
            }
            .navigationTitle("Base Conversion")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingScanningView, content: {
            ScanDocumentView(recognizedText: $fromNumber)
        })
    }
    
    fileprivate func convertBase() {
        guard let fromBase = Int(fromBase),
              let toBase = Int(toBase)
        else { return }
        
        if (1...36 ~= fromBase) && (1...36 ~= toBase) {
        
            if String(Int.max).count >= fromNumber.count {
                guard let fromValue = Int(fromNumber.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .punctuationCharacters).replacingOccurrences(of: ",", with: ""), radix: fromBase) else { return }
                toNumber = String(fromValue, radix: toBase).uppercased()
            } else {
                guard let num = BInt(fromNumber, radix: fromBase) else { return }
                print(num)
                toNumber = String(num, radix: toBase).uppercased()
            }
            
        }
    }
    
    fileprivate func copyToClipboard() {
        UIPasteboard.general.string = toNumber
        generator.impactOccurred()
    }
    
    fileprivate func copyToFrom() {
        fromBase = toBase
        fromNumber = toNumber
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
