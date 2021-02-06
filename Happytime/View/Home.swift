//
//  Home.swift
//  Happytime
//
//  Created by Shinya on 2021/01/14.
//

import SwiftUI

struct Home: View {
    
    @StateObject var modelData = DBViewModel()
    @State var showDatePicker: Bool = false
    
//    @State private var image = UIImage()
//    @State private var isShowPhotoLibrary = false
    
//    @State var displayedDate: Date = Date()
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                VStack() {
                    if showDatePicker {
                        ZStack() {
                            DatePicker("",selection: $modelData.targetDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
    //                            .labelsHidden()
                                .accentColor(Color(UIColor.systemRed))

                        }
                    }

//                    Image(uiImage: self.image)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(minWidth: 0, maxWidth: .infinity)
//                        .edgesIgnoringSafeArea(.all)
//                    Button(action: {
//                        self.isShowPhotoLibrary = true
//                    }, label: {
//                        Text("Photo Library")
//                            .padding()
//                    })

                    ForEach(modelData.cards){card in
                            
                            HStack(spacing: 10) {
                                VStack() {
                                    Text("\(Calendar.current.component(.day, from: card.targetDate))").font(.headline)
                                    Text(getWeekday(date:card.targetDate)).font(.subheadline)
                                }
                                .frame(width: 40)
                                Image(card.feeling)
//                                Image("feeling")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
//                                    .colorMultiply(Color.red)
                                    .frame(width: 50, height: 50)
                                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/, style: FillStyle())
                                Text(card.detail)
                                    .lineLimit(2)
                                Spacer()
                            }
                            .padding(10)
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(10)
                            .contextMenu(menuItems: {
                                Button(action: {modelData.deleteData(card: card)}, label: {
                                    Text("Delete")
                                })
                            })
                            .onTapGesture {
                                modelData.updateObject = card
                                modelData.openNewPage.toggle()
                            }
                            
                            
                        }

                }
                .padding()
                
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Right
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {modelData.openNewPage.toggle()}) {
                        Image(systemName: "square.and.pencil")
                            
                    }
                }
                // Center
                ToolbarItem(placement: .principal) {
                    Button(action: {
                        showDatePicker.toggle()
                        
                    }) {
                        Text(getMonth(date:modelData.displayedDate)).font(.title)
                    }
                }
                    
            }
            .sheet(isPresented: $modelData.openNewPage, content: {
                AddPageView().environmentObject(modelData)
            })
//            .sheet(isPresented: $isShowPhotoLibrary, content: {
//                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
//                    })
        }
        .accentColor(Color("label"))
//        .foregroundColor(Color("label"))
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
//            .environment(\.colorScheme, .dark)
    }
}

func getMonth(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    
    formatter.dateFormat = "MMMM yyyy"
    
    return formatter.string(from: date)
}

func getWeekday(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    
    formatter.dateFormat = "E"
    
    return formatter.string(from: date)
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()