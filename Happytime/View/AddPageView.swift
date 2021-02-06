//
//  AddPageView.swift
//  Happytime
//
//  Created by Shinya on 2021/01/14.
//

import SwiftUI

struct AddPageView: View {
    @EnvironmentObject var modelData: DBViewModel
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        
        
        NavigationView {
            
            VStack(spacing: 10) {
                                
                HStack() {
                    let images = ["1","2","3","4","5"]
                    
                    ForEach(images, id: \.self) {image in
                        ZStack {
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle(), style: FillStyle())
                                .tag(image)
                                .onTapGesture(perform: {
                                    modelData.feeling = image
                                })
                            if image == modelData.feeling {
                                Circle()
                                    .stroke(Color("label"), lineWidth: 3)
                                    .frame(width: 50, height: 50)
                            }
                            Spacer()
                        }
                        
                    }
                }
                .padding(10)
//                .background(Color.gray.opacity(0.15))
//                .cornerRadius(10)
                
                TextEditor(text: $modelData.detail)
                    //.autocapitalization(.none)
                    .padding(10)
//                    .background(Color.gray.opacity(0.15))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.15), lineWidth: 5))
                
            }
            .padding()
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Right
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {modelData.addData(presentation: presentation)}
                    ){Image(systemName: "checkmark.circle")}
                }
                // Center
                ToolbarItem(placement: .principal) {
                    DatePicker("",selection: $modelData.targetDate, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                        .accentColor(Color(UIColor.systemRed))
                }
                // Left
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {presentation.wrappedValue.dismiss()}, label: {
                        Image(systemName: "multiply")
                    })
                }

            }

        }
        .accentColor(Color("label"))
        .onAppear(perform: modelData.setUpInitialData)
        .onDisappear(perform: modelData.deInitData)
    }
}

struct AddPageView_Previews: PreviewProvider {
    static var previews: some View {
        AddPageView()
            .environment(\.colorScheme, .dark)
    }
}
