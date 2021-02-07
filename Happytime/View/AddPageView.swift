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
    @State var showDatePicker: Bool = false
    @State var savedDate: Date? = nil
//    @State var state: String = "Closed"
    
    var body: some View {
        
        
        NavigationView {
            ZStack {
            
                VStack(spacing: 10) {
                    
//                    Text(state)
                                
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
                                Circle()
                                    .stroke(Color.gray.opacity(0.15), lineWidth: 5)
                                    .frame(width: 50, height: 50)
                                if image == modelData.feeling {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.white)
                                        .frame(width: 50, height: 50)
                                }
                                Spacer()
                            }
                            
                        }
                    }
                    .padding(10)
    //                .background(Color.gray.opacity(0.15))
    //                .cornerRadius(10)
//                    DatePicker("",selection: $modelData.targetDate, displayedComponents: .date)
//                        .datePickerStyle(DefaultDatePickerStyle())
//                        .accentColor(Color(UIColor.systemRed))
                    
                    TextEditor(text: $modelData.detail)
                        //.autocapitalization(.none)
                        .padding(10)
    //                    .background(Color.gray.opacity(0.15))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.15), lineWidth: 5))
                    
                    HStack() {
                        Spacer()
                        Button(action: {
                            modelData.addData(presentation: presentation)
                        }, label: {
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                        })
                    }
                }
                .padding()
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button(action: {
//                            modelData.addData(presentation: presentation)
//                        }, label: {
//                            Image(systemName: "checkmark.circle")
//                        })
//                    }

                    // Center
                    ToolbarItem(placement: .principal) {
                        Button(action: {
                            showDatePicker.toggle()
                            UIApplication.shared.closeKeyboard()
                        }, label: {
                            Text(getDay(date:modelData.targetDate))
                        })
                        
                    }
                    // Left
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentation.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "multiply")
                        })
                    }
//                    ToolbarItemGroup(placement: .bottomBar) {
//                        Spacer()
//                        Button(action: {
//                            modelData.addData(presentation: presentation)
//                        }, label: {
//                            Image(systemName: "checkmark.circle")
//                        })
//                    }

                }
                
                if showDatePicker {
                    DatePickerWithButtons(showDatePicker: $showDatePicker, savedDate: $modelData.targetDate, selectedDate: modelData.targetDate)
                        .animation(.linear)
                        .transition(.opacity)
                }
            }
//            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
//                self.state = "Opened"
//            }.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
//                self.state = "Closed"
//            }
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

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

func getDay(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    
    formatter.dateFormat = "MMM d, yyyy"
    
    return formatter.string(from: date)
}
