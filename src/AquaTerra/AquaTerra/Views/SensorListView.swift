//
//  SensorListView.swift
//  AquaTerra
//
//  Created by Davincci on 9/9/2023.
//
import SwiftUI

struct SensorListView: View {
    @State var fieldData: [FieldData]

    @ObservedObject var viewModel: SessionViewViewModel
    @State var selectedFieldName: FieldData?
    @State var sensorData: [SensorData] = []

    @State private var showAlert = false
    @State private var showSelection = false
    @State private var deletionIndex: Int?
    @State private var showAddSensorSheet = false
    @State private var shouldRefreshData = false
    var colors : [Color] = [.init(hex: "#7FAF3A"),.init(hex: "#85B3A4")]
    
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedSensor: SensorData?

    var body: some View {
        NavigationView {
            VStack {
                FMNavigationBarView(title: "My Sensors")
                    .frame(height: 45)
                
                Divider()
                
                HStack{
                    Text("Current Field:").font(.custom("OpenSans-SemiBold", size: 14))
                        .foregroundColor(Color.black)
                    
                        if selectedFieldName != nil {
                            Text(selectedFieldName?.field_name ?? "").font(.custom("OpenSans-Bold", size: 14))
                                .foregroundColor(Color("ButtonGradient2"))

                            Spacer()
                            Button{
                                showSelection = true
                            }label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(Color("HighlightColor"))
                                        .frame(height: 41)
                                        .frame(width: 110)

                                    Text("Select A Field")
                                        .foregroundColor(Color.white)
                                        .font(.custom("OpenSans-Regular", size: 14))
                                        .bold()
                                }

                            }.navigationDestination(isPresented: $showSelection){
                                SelectionView(selectedFieldName: $selectedFieldName, viewModel: SessionViewViewModel(), fieldData: $fieldData, sensorData: $sensorData)
                            }
                        }
                    
                    
                    
                        else{

                            Text(selectedFieldName?.field_name ?? "Not Selected").font(.custom("OpenSans-SemiBold", size: 14))
                                .foregroundColor(Color.gray)
                            
                            Spacer()
                            Button{
                                showSelection = true
                            }label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(Color("HighlightColor"))
                                        .frame(height: 41)
                                        .frame(width: 110)
                                    
                                    Text("Select A Field")
                                        .foregroundColor(Color.white)
                                        .font(.custom("OpenSans-Regular", size: 14))
                                        .bold()
                                }
                                
                            }.navigationDestination(isPresented: $showSelection){
                                SelectionView(selectedFieldName: $selectedFieldName, viewModel: SessionViewViewModel(), fieldData: $fieldData, sensorData: $sensorData)
                            }
                            
                        }

                }.frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .padding(.leading, 25)
                    .padding(.trailing, 20)
                
                
                //List title bar
                HStack{
                    Text("ID")
                        .font(.custom("OpenSans-SemiBold", size: 16))
                        .foregroundColor(.black)
                    
                    Spacer().frame(width: 55)
                    
                    Text("Gateway")
                        .font(.custom("OpenSans-SemiBold", size: 16))
                        .foregroundColor(.black)
                    Spacer()
                    
                    Spacer()
                    if(selectedFieldName != nil){
                        Button(action: {
                            // Show the add sensor sheet
                            showAddSensorSheet = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(height: 41)
                                    .frame(width: 126)
                                    
                                Text("Add New Sensor")
                                    .foregroundColor(Color.white)
                                    .font(.custom("OpenSans-Regular", size: 14))
                                    .bold()
                            }
                        }
                    }else{
                        Button(action: {

                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(height: 41)
                                    .frame(width: 126)
                                    .opacity(0.3)
                                    
                                Text("Add New Sensor")
                                    .foregroundColor(Color.white)
                                    .font(.custom("OpenSans-Regular", size: 14))
                                    .bold()
                                    
                                }
                        }.disabled(true)
                    }
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .padding(.leading, 25)
                    .padding(.trailing, 20)
                    .background(Color("bar"))
                
                
                if selectedFieldName != nil {
                    List {
                        ForEach(sensorData) { sensor in
                            HStack {
                                Text((viewModel.abbreviateSensorID(sensor.sensor_id)))
                                    .font(.custom("OpenSans-Regular", size: 14))
                                
                                Spacer().frame(width: 20)
                                Text(sensor.gateway_id ?? "")
                                    .font(.custom("OpenSans-Regular", size: 14))

                                Spacer()
                                Button(action: {
                                }) {
                                    Image("edit").resizable()
                                        .frame(width: 38,height: 38)
                                }
                                Spacer().frame(width: 0)
                                Button(action: {
                                    deletionIndex = sensorData.firstIndex(of: sensor)
                                    showAlert = true

                                }) {
                                    Image("close-circle-fill").resizable()
                                        .frame(width: 38,height: 38)
                                }
                                
                            }
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .frame(height: 68)
                            .listRowInsets(EdgeInsets())

                        }
                        .onDelete(perform: deleteSensor)
                        
                    }
                    .scrollIndicators(.hidden)
                    .listStyle(PlainListStyle())
                    .padding(.top, -7)
                    .padding(.bottom, 70)
                    .frame(maxHeight: .infinity)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Delete Sensor"),
                            message: Text("Are you sure you want to delete this sensor?"),
                            primaryButton: .destructive(Text("Delete")) {
                                if let index = deletionIndex {
                                    let sensorToDelete = sensorData[index]
                                    viewModel.deleteSensor(sensorID: sensorToDelete.sensor_id) { result in
                                        switch result {
                                        case .success:
                                            sensorData.remove(at: index)
                                        case .failure(let error):
                                            print("Error deleting sensor: \(error)")
                                        }
                                    }
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    
                }else{
                    Spacer()
                    
                    Image("empty")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width:50, height: 50)
                    .foregroundColor(Color.gray).opacity(0.5)
                    
                    
                    Group {
                        Text("Please ").font(.custom("OpenSans-Regular", size: 13)).foregroundColor(Color.gray) +
                      Text("Select A Field ").font(.custom("OpenSans-ExtraBold", size: 13)).foregroundColor(Color("HighlightColor")) +
                      Text("To Display Your Sensor Data").font(.custom("OpenSans-Regular", size: 13)).foregroundColor(Color.gray)
                    }.padding(.vertical,15)
 
                    Spacer()
                    Spacer()
                }


                
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationBackView()
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .frame(width: 70,height: 17)
                }
            }
            .navigationBarBackButtonHidden(true)
            

        }
        .sheet(isPresented: $showAddSensorSheet) {
            if let field = selectedFieldName {
                AddSensorView(viewModel: viewModel, showAddSensorSheet: $showAddSensorSheet, fieldID: field.field_id)
            }
        }.navigationBarBackButtonHidden(true)
    }

    private func deleteSensor(at offsets: IndexSet) {
        if let firstIndex = offsets.first {
            deletionIndex = firstIndex
            showAlert = true
        }
    }
}

struct SensorListView_Previews: PreviewProvider {
    static var previews: some View {
        SensorListView(fieldData: [], viewModel: SessionViewViewModel())
    }
}
