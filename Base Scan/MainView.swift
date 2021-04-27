//
//  MainView.swift
//  Binary Scanner
//
//  Created by Jonathan Dowdell on 4/18/21.
//

import SwiftUI
import BigNumber


struct MainView: View {
    
    @State private var showingScanningView = false
    
    @State private var fromBase = ""
    @State private var fromNumber = ""
    
    @State private var toBase = ""
    @State private var toNumber = ""
    
    @ObservedObject private var baseConverter = BaseConverter()
    
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("FROM")) {
                    HStack {
                        Text("Base")
                        
                        TextField("2-36", text: $fromBase)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("Value")
                            .foregroundColor((fromBase == "2") && (fromNumber.count > 63) ? .red : .none)
                        TextField("Number", text: $fromNumber)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(chooseKeyboardType(fromBase: fromBase))
                            .foregroundColor((fromBase == "2") && (fromNumber.count > 63) ? .red : .none)
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
                        
                        TextField("2-36", text: $toBase)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
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
            .navigationTitle("Base Scan")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingScanningView, content: {
            ScanDocumentView(recognizedText: $fromNumber)
        })
    }
    
    fileprivate func convertBase() {
        guard let conversion = baseConverter.convert(fromBase: fromBase, fromNumber: fromNumber, toBase: toBase) else { return }
        toNumber = conversion
    }
    
    fileprivate func copyToClipboard() {
        UIPasteboard.general.string = toNumber
        generator.impactOccurred()
    }
    
    fileprivate func copyToFrom() {
        fromBase = toBase
        fromNumber = toNumber
    }
    
    fileprivate func chooseKeyboardType(fromBase: String) -> UIKeyboardType {
        guard let fromBase = Int(fromBase) else { return .default }
        if fromBase < 11 {
            return .decimalPad
        } else {
            return .default
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
