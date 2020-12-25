//
//  GlobalPicker.swift
//  Demo
//
//  Created by Gesen on 16/3/1.
//  Copyright © 2016年 Gesen. All rights reserved.
//

import SwiftTheme

let tc = [["#1B435D","#78BBE6","#D5EEFF","#F99F48"],// Standard Coler set
    ["#F99292","#FFBC61","#FFC679","#FFF4E0"], // Warm
    ["#28385E","#516C8D","#6A91C1","#CCCCCC"], // Cool
    ["#FA776D","#FC9D9A","#F9CDAD","#757575"], // Cute
    [tc_black, "#454C50","#6E777C",tc_white], // Night
    ["#1C75BC","#5CC0EF","#F9A638",tc_orange],//  Walkthrough and In-Purchase
    ["#292b38","#6E777C","#FFFFFF","#01040D"]]//Dark・

let tc_white = "#FFFFFF"
let tc_black = "#000000"
let tc_orange = "#F99F48"
let tc_offwhite = "#ECF0F1"
//let tc_yellow = "FFFB00"

enum GlobalPicker {
    
    // Automaticall
    
    static let debug:ThemeColorPicker = [tc_orange,tc_orange,tc_orange,tc_orange,tc_orange,tc_orange,tc_orange]
    
    // Mark:- View // 実際には使用されていない？
    static let backgroundColor: ThemeColorPicker = [tc_white,tc[1][3], tc_white, tc_white,tc_white,tc_white,tc_white,tc[6][0]]
    static let tintColor: ThemeColorPicker = [tc[0][0], tc[1][1], tc[2][1], tc[3][0], tc_black,tc[5][1],tc[5][1],tc_white]
    
    // Mark:- Stepper
    static let stepperBackgroundColor:ThemeColorPicker =
        [tc[0][3],tc[1][1],tc[2][3],tc[3][1],tc[2][3],tc_white,tc_white,tc[6][2]]
    // Mark: - Graph
    static let gr_fillColor = [tc[0][2],tc[1][2],tc[2][0],tc[3][1],"#D7E6EF",tc_white,tc_white,tc[6][0]]
    static let gr_lineColor = [tc[0][1],tc[1][1],tc[2][2],tc[3][0],tc[4][0],tc_white,tc_white,tc[6][1]]
    static let gr_dotColor = [tc[0][3],tc[1][0],tc[2][2],tc[3][3],tc[4][1],tc_white,tc_white,tc[6][2]]
    // Mark: - EmptyStatusView
    static let emptyStateViewBackground:ThemeColorPicker = [tc[0][2],tc[1][2],tc[2][0],tc[3][1],"#D7E6EF",tc_white,tc_white,tc[6][0]]
    
    // MARK:- Navigation
    static let naviItemColor:ThemeColorPicker =  [tc_black,tc_black,tc_black,tc_black,tc_black,tc_black,tc_black,tc_black]
    // Mark:- Bar
    static let barBackGroundColor:ThemeColorPicker = [tc[0][1],tc[1][1],tc[2][2],tc[3][3],tc[4][3],tc_white,tc_white,tc[6][0]]
    static let toolBarButtonColor:ThemeColorPicker = [tc_black,tc_black,tc_black,tc_black,tc_black,tc_black,tc_black,tc[6][2]]
    static let toolBarButtonColor1:ThemeColorPicker = [tc_black,tc_black,tc_black,tc_black,tc_black,tc_black,tc_black,tc_black]
    static let barTitleColors = [tc[0][0], tc[1][0],tc[2][0],tc[3][0],tc_black,tc_black,tc_black,tc_black]
    static let tabTintColor:ThemeColorPicker = ThemeColorPicker.pickerWithColors(barTitleColors)
    static let barTextColor: ThemeColorPicker = ThemeColorPicker.pickerWithColors(barTextColors)
    static let barTextColors = [tc[0][0], tc[1][3],tc[2][3],tc_white,tc[4][3],tc[5][0],tc[5][0],tc[6][2]]
    static let barTintColor: ThemeColorPicker = [tc[0][1], tc[1][1],tc[2][0],tc[3][0],tc[4][1],tc[5][1],tc[5][1],tc[6][0]]
   
    // Mark:- Button
    static let buttonTintColor2: ThemeColorPicker = [tc[0][0], tc[1][1],tc[2][3],tc[3][0],tc[4][0],tc[5][2],tc[5][2],tc[6][3]]//
    static let buttonTintColor3: ThemeColorPicker = [tc[0][3], tc[1][0],tc[2][0],tc[3][3],tc[4][2],tc[5][0],tc[5][2],tc[6][2]]
    
    static let buttonTitleColor: ThemeColorPicker = [tc_white, tc_white,tc_white, tc_white,tc_white,tc_orange,tc_white,tc_white]
    // Mark:-Data Entry Cell
    static let cellBackGround_dataEntry:ThemeColorPicker = [tc_white,tc_white,tc_white,tc_white,tc_white,tc_white,tc_white,tc[6][0]]
    // Mark:- Segment & Switch
    static let segmentTintColor: ThemeColorPicker = [tc[0][2],tc[1][2],tc[2][3],tc[3][1],tc[4][2],tc[5][2],tc[5][2],tc[6][0]]
    static let onSwithTintColor: ThemeColorPicker = [tc[0][3], tc[1][0],tc[2][0],tc[3][1],tc[4][1],tc[5][2],tc[5][2],tc[6][2]]
    static let onSwithTintColors = [tc[0][3], tc[1][0],tc[2][0],tc[3][1],tc[4][1],tc[5][2],tc[5][2],tc[6][2]]
    static let thumbTintColor: ThemeColorPicker = [tc_white,tc_white,tc_white,tc_white,tc_white,tc_white,tc_white,tc[6][1]]
    // Mark:- Table
    static let tv_separatorColor: ThemeColorPicker = [tc[0][2], tc[1][2], tc[2][2], tc[3][2],tc[4][3],tc[5][2],tc[5][2],"#ECF0F1"]
    static let groupBackground: ThemeColorPicker = [
        tc[0][2],tc[1][2],tc[2][3],tc[3][2],tc_white,tc[5][2],tc[5][2],tc[6][1]]
    static let groupTextColor: ThemeColorPicker = [tc_black,tc_black,tc_black,tc_black,tc_black,tc_black,tc_black,tc[6][3]]
    // Mark: - Label
    static let labelTextColors = [tc_black,tc_black,tc_black,tc_black,tc_black,tc_black,tc_black,tc[6][2]]
    static let labelTextColor:ThemeColorPicker = ThemeColorPicker.pickerWithColors(labelTextColors)
    static let labelHilight:ThemeColorPicker = [tc[0][2], tc[1][2], tc[0][1], tc[3][2],tc_white,tc[5][2],tc[5][2],tc[6][2]]
    
    // Mark:- Calendar
    static let cal_weekdayTextColor = [tc[0][1], tc[1][1], tc[2][1], tc[3][1],tc[4][1],tc_black,tc_black,tc[6][2]]
    static let cal_headerTitleColor  = [tc[0][0], tc[1][0], tc[2][0], tc[3][2],tc[4][0],tc_black,tc_black,tc[6][2]]
    static let cal_eventDefaultColor  = [tc[0][2], tc[1][2], tc[2][2], tc[3][3],tc[4][2],tc_black,tc_black,tc[6][2]]
    static let cal_selectionColor = [tc[0][3], tc[1][0], tc[2][3], tc[3][3],tc[4][1],tc_black,tc_black,tc_offwhite]
    static let cal_todayColor  = [tc[0][2], tc[1][1], tc[2][1], tc[3][1],tc[4][2],tc_black,tc_black,tc[6][1]]
    static let cal_event1 = [tc[0][0], tc[1][1], tc[2][1], tc[3][1],tc[4][1],tc_black,tc_black,tc[6][2]]
    static let cal_event2 = [tc[0][3], tc[1][0], tc[2][0], tc[3][0],tc[4][0],tc_black,tc_black,tc[6][2]]
    static let cal_defaultColor = [tc_black,tc_black,tc_black,tc_black,tc_black,tc_black,tc_black,tc[6][2]]
}
