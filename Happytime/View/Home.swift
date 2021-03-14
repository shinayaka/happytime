//
//  Home.swift
//  Happytime
//
//  Created by Shinya on 2021/01/14.
//

import SwiftUI

struct Home: View {
    
    @StateObject var modelData = DBViewModel()
        
    var body: some View {
        
        NavigationView {
            
            ScrollView {

                VStack() {
                    ForEach(modelData.cards){card in
                            
                        HStack(spacing: 10) {
                            VStack() {
                                Text("\(Calendar.current.component(.day, from: card.targetDate))").font(.headline)
                                Text(getWeekday(date:card.targetDate)).font(.subheadline)
                            }
                            .frame(width: 40)
                            Image(card.feeling)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/, style: FillStyle())
                            Text(card.detail)
                                .lineLimit(2)
                            Spacer()
                        }
                        .padding(10)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(10)
                        .contextMenu {
                            Button(action: {
                                modelData.deleteData(card: card)
                            }, label: {
                                Image(systemName: "trash")
                            })
                        }
                        .onTapGesture {
                            modelData.updateObject = card
                            modelData.openNewPage.toggle()
                        }
                    }
                }
                .padding()
                
            }
            .gesture(DragGesture()
                .onEnded({ value in
                    if (abs(value.translation.width) < 10) { return }
                    if (value.translation.width < 0 ) {
                        // swiped to left
                        modelData.fetchNextMonth()
                    } else if (value.translation.width > 0 ) {
                        // swiped to right
                        modelData.fetchPrevMonth()
                    }
                })
            )
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Center
                ToolbarItem(placement: .principal) {
                    Text(getMonth(date:modelData.displayedDate)).font(.title)
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    
                    Button(action: {
                        modelData.openNewPage.toggle()
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $modelData.openNewPage, content: {
                AddPageView().environmentObject(modelData)
            })
        }
        // For iPad
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(Color("label"))
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
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
