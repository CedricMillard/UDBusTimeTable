//
//  ContentView.swift
//  AgeoBusTimeTable
//
//  Created by Erin Millard on 2026/06/22.
//

import SwiftUI
import WidgetKit

let today = Date()

struct ContentView: View {
    let hours: [Int] = [23] + Array(0...23) + [0]
    
    @State private var currentIndex: Int = Calendar.current.component(.hour, from: today)+1
    
    @State private var strDirection="UD Plant -> Ageo Station"
    
    @State private var showSettings = false
    
    @State private var currentTime: Int = Calendar.current.component(.hour, from: Date())*60 + Calendar.current.component(.minute, from: Date())
    
    var body: some View {
        
        VStack {
            ZStack{
                Text("UD Bus-Train timetable")
                    .bold()
                HStack{
                    Spacer()
                    Button(action:{
                        showSettings.toggle()
                    }) {
                        Image(systemName: "gearshape.fill")
                            .imageScale(.large)
                            .foregroundColor(.gray)
                    }
                    .frame(width:100)
                    .sheet(isPresented: $showSettings){
                        SettingsView(currentTime: $currentTime)
                            .presentationDetents([.medium])
                            .presentationDragIndicator(.visible)
                    }
                }
            }
            Spacer()
            Text(strDirection)
                .italic()
                .font(.footnote)
            /*Button(action:{
                if strDirection=="UD Plant -> Ageo Station" {strDirection = "Ageo Station->UD"}
                else {strDirection = "UD Plant -> Ageo Station"}
            })
            {
                Text(strDirection)
            }*/
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
                Text("\(hours[currentIndex]) H")
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
                                HourlyContentView(hour: hours[index], currentTime: $currentTime)
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never)) // Enables swipe paging
                        .onChange(of: currentIndex) { oldIndex, newIndex in
                            handleLoop(targetIndex: newIndex)
                        }
                        
            Spacer(minLength: 25)
            Image("UDBusSideView")
                .resizable()
                .scaledToFit()
                .frame(width: 350)
            Spacer(minLength: 25)
            HStack{
                
                Text("Ueno-Tokyo line ")
                    .foregroundColor(getTrainFontColor(iIsShonan: false))
                    .font(.footnote)
                    .italic()
                Text("/")
                    .font(.footnote)
                    .italic()
                Text("Shonan-Shinjuku line")
                    .foregroundColor(getTrainFontColor(iIsShonan: true))
                    .font(.footnote)
                    .italic()
                Text("toward Oomiya")
                    .font(.footnote)
                    .italic()
            }
            Text("Bus does not operate on red days")
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

struct HourlyContentView: View {
    let hour: Int
    @Binding var currentTime: Int
    //@State private var currentTime: Int = Calendar.current.component(.hour, from: Date())*60 + Calendar.current.component(.minute, from: Date())
    
    @AppStorage("BusTimeBuffer", store: UserDefaults(suiteName: appGroupSuite)) private var BusTimeBuffer = 5
    @AppStorage("TrainTimeBuffer", store: UserDefaults(suiteName: appGroupSuite)) private var TrainTimeBuffer = 3
    @AppStorage("AvoidShonanShinjuku", store: UserDefaults(suiteName: appGroupSuite)) private var AvoidShonanShinjuku = false
    
    //let nextBus = getBusFromIndex(iIndex: getNextBusToAgeo(iTime:18*60+12))
    
    var body: some View {
        
        let lHourlyTables: [BusTrainTimeTable] = getTimeTablePerHour(iHour: hour, TrainTimeBuffer: TrainTimeBuffer, AvoidShonanShinjuku: AvoidShonanShinjuku, iAddOneExtra: false)
        let nextBusIndex = getNextBusToAgeo(iTime: currentTime, BusTimeBuffer: BusTimeBuffer)
        let nextBus = getBusFromIndex(iIndex: nextBusIndex)
        
        
        ScrollView{
            
            VStack {
                HStack(spacing:50) {
                    Text("Bus")
                        .bold()
                        .frame(width:100)
                    Text("Train")
                        .bold()
                        .frame(width:100)
                }
                Divider()
                ForEach(lHourlyTables) { item in
                    HStack (spacing:50){
                        
                        Text(timeToString(iTime: item.curBus.departureTime))
                            .foregroundColor(getBusFontColor(iIsOperateRedDays: item.curBus.isActiveRedDays))
                            .frame(width:100)
                            
                        if (item.curTrain.count==1){
                            Text(timeToString(iTime: item.curTrain[0].departureTime))
                            .foregroundColor(getTrainFontColor(iIsShonan: item.curTrain[0].isShonan))
                            .frame(width:100)
                        }
                        else {
                            VStack{
                                Text(timeToString(iTime: item.curTrain[1].departureTime))
                                    .foregroundColor(getTrainFontColor(iIsShonan: item.curTrain[1].isShonan))
                            
                                Text("("+timeToString(iTime: item.curTrain[0].departureTime)+")")
                                    .font(.footnote)
                                    .foregroundColor(getTrainFontColor(iIsShonan: item.curTrain[0].isShonan))
                            }
                            .frame(width:100)
                        }
                    }
                    .bold(item.curBus.departureTime == nextBus.departureTime)
                    .padding((item.curBus.departureTime == nextBus.departureTime && nextBus.departureTime > 0) ? 2 : 0)
                    .border((item.curBus.departureTime == nextBus.departureTime && nextBus.departureTime > 0) ? Color.green : Color.clear)
                    Divider()
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var currentTime: Int
    
    @AppStorage("BusTimeBuffer", store: UserDefaults(suiteName: appGroupSuite)) private var BusTimeBuffer = 5
    @AppStorage("TrainTimeBuffer", store: UserDefaults(suiteName: appGroupSuite)) private var TrainTimeBuffer = 3
    @AppStorage("AvoidShonanShinjuku", store: UserDefaults(suiteName: appGroupSuite)) private var AvoidShonanShinjuku = false
    
    var body: some View {
            
            VStack(spacing:1) {
                Text("Settings")
                    .font(.title)
                HStack{
                    Spacer()
                    Text("BusTimeBuffer: ")
                        .frame(width:150)
                    Picker("Buffer time to catch bus", selection: $BusTimeBuffer){
                        ForEach(0...15,id:\.self){number in
                        Text("\(number)")
                                .tag(number)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .frame(width:50, height:100)
                    .onChange(of: BusTimeBuffer) { oldvalue, newvalue in
                        currentTime = Calendar.current.component(.hour, from: Date())*60 + Calendar.current.component(.minute, from: Date())
                        WidgetCenter.shared.reloadTimelines(ofKind: "UDBusTimeTableWidget")
                    }
                    
                    Spacer()
                }
                HStack{
                    Spacer()
                    Text("TrainTimeBuffer: ")
                        .frame(width:150)

                    Picker("Buffer time to catch train", selection: $TrainTimeBuffer){
                        ForEach(0...15,id:\.self){number in
                        Text("\(number)")
                                .tag(number)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .frame(width:50, height:100)
                    .onChange(of: TrainTimeBuffer) { oldvalue, newvalue in
                        currentTime = Calendar.current.component(.hour, from: Date())*60 + Calendar.current.component(.minute, from: Date())
                        WidgetCenter.shared.reloadTimelines(ofKind: "UDBusTimeTableWidget")
                    }
                    Spacer()
                }
                Toggle("Avoid Shonan Shinjuku line",isOn:$AvoidShonanShinjuku)
                    .frame(width:200)
                    .onChange(of: AvoidShonanShinjuku) { oldvalue, newvalue in
                        currentTime = Calendar.current.component(.hour, from: Date())*60 + Calendar.current.component(.minute, from: Date())
                        WidgetCenter.shared.reloadTimelines(ofKind: "UDBusTimeTableWidget")
                    }
                
            }
            .frame(height: 350)
            
            Spacer()
            Text("Provided to you by Cédric Millard")
                .italic()
                .font(.footnote)
                .foregroundColor(Color.gray)
    }
}

#Preview (){
    ContentView()
}

