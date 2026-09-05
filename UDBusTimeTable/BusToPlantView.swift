//
//  BusToPlantView.swift
//  UDBusTimeTable
//
//  Created by Cedric Millard on 31/08/2026.
//

import SwiftUI

struct BusToPlantView: View {
    let hours: [Int] = [23] + Array(0...23) + [0]
    
    @Binding var isFlipped: Bool
    
    @State private var currentIndex: Int = Calendar.current.component(.hour, from: today)+1
    @State private var currentTime: Int = Calendar.current.component(.hour, from: Date())*60 + Calendar.current.component(.minute, from: Date())
    
    var body: some View {
        
        VStack {
            Text("UD Bus timetable")
                .bold()
            
            Spacer()
            Button(action: {
                withAnimation(.bouncy(duration:0.6)){
                    isFlipped.toggle()
                }
            }){
                Text("Ageo Station \u{2192} UD Plant")
                    .italic()
                    .font(.callout)
            }
            Spacer(minLength: 25)
            
            HStack (spacing: 15){
                Button(action:{
                    navigate(direction: -1)
                })
                {
                    Image(systemName: "chevron.left")
                        .bold()
                }
                .buttonStyle(.bordered)
                
                Button(action:{
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentIndex = Calendar.current.component(.hour, from: today)+1
                    }
                })
                {
                    Text("\(hours[currentIndex]) H")
                }
                
                Button(action:{
                    navigate(direction: 1)
                })
                {
                    Image(systemName: "chevron.right")
                        .bold()
                }
                .buttonStyle(.bordered)
            }
            Spacer(minLength: 25)
            
            TabView(selection: $currentIndex) {
                ForEach(0..<hours.count, id: \.self) { index in
                                HourlyToPlantView(hour: hours[index], currentTime: $currentTime)
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never)) // Enables swipe paging
                        .onChange(of: currentIndex) { oldIndex, newIndex in
                            handleLoop(targetIndex: newIndex)
                        }
                        
            Spacer(minLength: 25)
            Button(action: {
                withAnimation(.bouncy(duration:0.6)){
                    isFlipped.toggle()
                }
            }){
                Image("UDBusLeftView")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
                //.scaleEffect(x: -1, y: 1)
            }
            Spacer(minLength: 25)
            
            Text("Bus not in service on public holidays")
                .foregroundColor(getBusFontColor(iIsOperateRedDays: false))
                .font(.footnote)
                .italic()
        }
    }
    
    private func handleLoop(targetIndex: Int) {
            // If they swipe left past Hour 0 into the buffer (Index 0 / Hour 23)
            if targetIndex == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    currentIndex = hours.count - 2 // Snap to real Hour 23
                }
            }
            // If they swipe right past Hour 23 into the buffer (Last Index / Hour 0)
            else if targetIndex == hours.count - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    currentIndex = 1 // Snap to real Hour 0
                }
            }
        }
    
    // 3. Animates button presses, but leaves swipes alone
        private func navigate(direction: Int) {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentIndex += direction
            }
        }
}

struct HourlyToPlantView: View {
    let hour: Int
    @Binding var currentTime: Int
    
    var body: some View {
        
        let lHourlyTables: [BusData] = getBusTimePerHour(iHour:hour, isBusToPlant:true)
        
        let nextBusIndex = getNextBusToPlant(iTime: currentTime)
        let nextBus = getBusFromIndex(iIndex: nextBusIndex, isBusToPlant: true)
        
        ScrollView{
            
            VStack {
                    Text("Bus")
                        .bold()
                        .frame(width:100)
                Divider()
                
                ForEach(lHourlyTables) { item in
                    Text(timeToString(iTime: item.departureTime))
                        .foregroundColor(getBusFontColor(iIsOperateRedDays: item.isActiveRedDays))
                        .frame(width:100)
                        .bold(item.departureTime == nextBus.departureTime)
                        .padding((item.departureTime == nextBus.departureTime && nextBus.departureTime > 0) ? 2 : 0)
                        .border((item.departureTime == nextBus.departureTime && nextBus.departureTime > 0) ? Color.green : Color.clear)
                    Divider()
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}
