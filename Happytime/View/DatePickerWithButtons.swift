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
            DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .accentColor(Color(UIColor.systemRed))

            VStack {
                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .accentColor(Color(UIColor.systemRed))
                HStack {
                    Spacer()
                    
                    Button(action: {
                        savedDate = selectedDate
                        showDatePicker = false
                    }, label: {
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    })
                }
            }
            .padding()
            .background(
                Color(UIColor.systemBackground)
                    .cornerRadius(5)
            )
        }
    }
}
