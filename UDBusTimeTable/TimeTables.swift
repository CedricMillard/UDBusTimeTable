//
//  TimeTables.swift
//  AgeoBusTimeTable
//
//  Created by Erin Millard on 2026/06/22.
//

import Foundation

let UDtoAgeo = [
                BusData(departureTime:08*60+50,duration:10),
                
                BusData(departureTime:09*60+00,duration:10),
                BusData(departureTime:09*60+15,duration:10),
                BusData(departureTime:09*60+30,duration:10),
                BusData(departureTime:09*60+50,duration:10),
                
                BusData(departureTime:10*60+20,duration:10,isActiveRedDays:false),
                BusData(departureTime:10*60+50,duration:10),
                
                BusData(departureTime:11*60+20,duration:10,isActiveRedDays:false),
                BusData(departureTime:11*60+50,duration:10),
                
                BusData(departureTime:12*60+20,duration:10),
                BusData(departureTime:12*60+50,duration:10),
                
                BusData(departureTime:13*60+20,duration:10,isActiveRedDays:false),
                BusData(departureTime:13*60+50,duration:10),
                
                BusData(departureTime:14*60+20,duration:10,isActiveRedDays:false),
                BusData(departureTime:14*60+50,duration:10),
                
                BusData(departureTime:15*60+20,duration:10,isActiveRedDays:false),
                BusData(departureTime:15*60+50,duration:10),
                
                BusData(departureTime:16*60+20,duration:10,isActiveRedDays:false),
                BusData(departureTime:16*60+50,duration:10),

                BusData(departureTime:17*60+05,duration:10),
                BusData(departureTime:17*60+25,duration:10),
                BusData(departureTime:17*60+40,duration:10),
                BusData(departureTime:17*60+47,duration:14),
                BusData(departureTime:17*60+55,duration:14),

                BusData(departureTime:18*60+03,duration:14),
                BusData(departureTime:18*60+10,duration:14),
                BusData(departureTime:18*60+17,duration:14),
                BusData(departureTime:18*60+25,duration:12),
                BusData(departureTime:18*60+33,duration:10),
                BusData(departureTime:18*60+40,duration:10),
                BusData(departureTime:18*60+47,duration:10),
                BusData(departureTime:18*60+55,duration:10),

                BusData(departureTime:19*60+03,duration:10),
                BusData(departureTime:19*60+10,duration:10),
                BusData(departureTime:19*60+20,duration:10),
                BusData(departureTime:19*60+30,duration:10),
                BusData(departureTime:19*60+40,duration:10),
                BusData(departureTime:19*60+50,duration:10),
                
                BusData(departureTime:20*60+00,duration:10),
                BusData(departureTime:20*60+15,duration:10),
                BusData(departureTime:20*60+30,duration:10),
                BusData(departureTime:20*60+45,duration:10),
                
                BusData(departureTime:21*60+00,duration:10),
                
                BusData(departureTime:21*60+15,duration:10),
                BusData(departureTime:21*60+30,duration:10),
                BusData(departureTime:21*60+45,duration:10),
                BusData(departureTime:22*60+00,duration:10),
                BusData(departureTime:22*60+15,duration:10),
                BusData(departureTime:22*60+30,duration:10),
                BusData(departureTime:22*60+45,duration:10),
                BusData(departureTime:23*60+00,duration:10),
                BusData(departureTime:23*60+15,duration:10),
                BusData(departureTime:23*60+30,duration:10),
                BusData(departureTime:23*60+45,duration:10)
                ]

let TrainFromAgeo = [
                     TrainData(departureTime:08*60+55,isShonan:false),
                     
                     TrainData(departureTime:09*60+08,isShonan:false),
                     TrainData(departureTime:09*60+15,isShonan:true),
                     TrainData(departureTime:09*60+24,isShonan:false),
                     TrainData(departureTime:09*60+34,isShonan:false),
                     TrainData(departureTime:09*60+47,isShonan:true),
                     TrainData(departureTime:09*60+57,isShonan:false),
    
                     TrainData(departureTime:10*60+03,isShonan:false),
                     TrainData(departureTime:10*60+20,isShonan:true),
                     TrainData(departureTime:10*60+26,isShonan:false),
                     TrainData(departureTime:10*60+39,isShonan:false),
                     TrainData(departureTime:10*60+48,isShonan:true),

                     TrainData(departureTime:11*60+03,isShonan:false),
                     TrainData(departureTime:11*60+19,isShonan:true),
                     TrainData(departureTime:11*60+23,isShonan:false),
                     TrainData(departureTime:11*60+40,isShonan:false),
                     TrainData(departureTime:11*60+48,isShonan:true),

                     TrainData(departureTime:12*60+03,isShonan:false),
                     TrainData(departureTime:12*60+19,isShonan:true),
                     TrainData(departureTime:12*60+24,isShonan:false),
                     TrainData(departureTime:12*60+42,isShonan:false),
                     TrainData(departureTime:12*60+48,isShonan:true),
                     
                     TrainData(departureTime:13*60+03,isShonan:false),
                     TrainData(departureTime:13*60+19,isShonan:true),
                     TrainData(departureTime:13*60+23,isShonan:false),
                     TrainData(departureTime:13*60+42,isShonan:false),
                     TrainData(departureTime:13*60+48,isShonan:true),

                     TrainData(departureTime:14*60+04,isShonan:false),
                     TrainData(departureTime:14*60+19,isShonan:true),
                     TrainData(departureTime:14*60+23,isShonan:false),
                     TrainData(departureTime:14*60+41,isShonan:false),
                     TrainData(departureTime:14*60+47,isShonan:true),

                     TrainData(departureTime:15*60+05,isShonan:false),
                     TrainData(departureTime:15*60+19,isShonan:true),
                     TrainData(departureTime:15*60+23,isShonan:false),
                     TrainData(departureTime:15*60+40,isShonan:false),
                     TrainData(departureTime:15*60+48,isShonan:true),

                     TrainData(departureTime:16*60+04,isShonan:false),
                     TrainData(departureTime:16*60+19,isShonan:true),
                     TrainData(departureTime:16*60+23,isShonan:false),
                     TrainData(departureTime:16*60+33,isShonan:false),
                     TrainData(departureTime:16*60+43,isShonan:false),
                     TrainData(departureTime:16*60+50,isShonan:true),
                     TrainData(departureTime:16*60+57,isShonan:false),

                     TrainData(departureTime:17*60+07,isShonan:false),
                     TrainData(departureTime:17*60+21,isShonan:true),
                     TrainData(departureTime:17*60+25,isShonan:false),
                     TrainData(departureTime:17*60+42,isShonan:false),
                     TrainData(departureTime:17*60+48,isShonan:true),
                     TrainData(departureTime:17*60+57,isShonan:false),

                     TrainData(departureTime:18*60+11,isShonan:false),
                     TrainData(departureTime:18*60+24,isShonan:true),
                     TrainData(departureTime:18*60+32,isShonan:false),
                     TrainData(departureTime:18*60+39,isShonan:false),
                     TrainData(departureTime:18*60+47,isShonan:false),
                     TrainData(departureTime:18*60+57,isShonan:false),
                     
                     TrainData(departureTime:19*60+02,isShonan:true),
                     TrainData(departureTime:19*60+16,isShonan:false),
                     TrainData(departureTime:19*60+26,isShonan:true),
                     TrainData(departureTime:19*60+34,isShonan:false),
                     TrainData(departureTime:19*60+54,isShonan:true),
                     TrainData(departureTime:19*60+58,isShonan:false),
                     
                     TrainData(departureTime:20*60+18,isShonan:false),
                     TrainData(departureTime:20*60+27,isShonan:true),
                     TrainData(departureTime:20*60+35,isShonan:false),
                     TrainData(departureTime:20*60+42,isShonan:false),
                     TrainData(departureTime:20*60+59,isShonan:false),

                     TrainData(departureTime:21*60+14,isShonan:true),
                     TrainData(departureTime:21*60+18,isShonan:false),
                     TrainData(departureTime:21*60+26,isShonan:false),
                     TrainData(departureTime:21*60+40,isShonan:false),
                     TrainData(departureTime:21*60+46,isShonan:false),
                     
                     TrainData(departureTime:22*60+01,isShonan:true),
                     TrainData(departureTime:22*60+06,isShonan:false),
                     TrainData(departureTime:22*60+15,isShonan:true),
                     TrainData(departureTime:22*60+30,isShonan:false),
                     TrainData(departureTime:22*60+41,isShonan:false),
                     TrainData(departureTime:22*60+56,isShonan:false),
                     
                     TrainData(departureTime:23*60+13,isShonan:false),
                     TrainData(departureTime:23*60+22,isShonan:false),
                     TrainData(departureTime:23*60+40,isShonan:false)
                     ]

