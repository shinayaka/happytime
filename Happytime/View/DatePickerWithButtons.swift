//
//  DatePickerWithButtons.swift
//  Happytime
//
//  Created by Shinya on 2021/01/30.
//

import SwiftUI

struct DatePickerWithButtons: View {
    @Binding var showDatePicker: Bool
    @Binding var savedDate: Date
    @State var selectedDate: Date = Date()
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(1.3)
                .onTapGesture {
                    showDatePicker = false
                }
//            Image("5")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .edgesIgnoringSafeArea(.all)
//                .blur(radius: 10.0)
//                .onTapGesture {
//                    showDatePicker = false
//                }
            
            
            VStack {
                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .accentColor(Color(UIColor.systemRed))
//                    .transformEffect(.init(scaleX: 0.8, y: 0.8))
//                Divider()
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        savedDate = selectedDate
                        showDatePicker = false
                    }, label: {
                        Image(systemName: "checkmark.circle")
                            .resizable()
//                            .aspectRatio(contentMode: .fill)
                            .frame(width: 25, height: 25)
                    })
                    
                    
                }
                .padding(.horizontal)

            }
            .padding()
            .background(
                Color(UIColor.systemBackground)
                    .cornerRadius(5)
            )

            
        }

    }
}
