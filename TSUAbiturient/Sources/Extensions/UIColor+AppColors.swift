//
//  UIColor+AppColors.swift
//  TSUAbiturient
//

import UIKit

// swiftlint:disable nesting

extension UIColor {
  // MARK: - Light Theme
  enum Light {
   
    enum Global {
      static let white = Assets.Colors.lightGlobalWhite.color
      static let black = Assets.Colors.lightGlobalBlack.color
    }
    
    enum Text {
      static let primary = Assets.Colors.lightTextPrimary.color
      static let secondary = Assets.Colors.lightTextSecondary.color
      static let tertiary = Assets.Colors.lightTextTertiary.color
      static let accent = Assets.Colors.lightTextAccent.color
      static let white = Assets.Colors.lightTextWhite.color
    }
    
    enum Icons {
      static let accent = Assets.Colors.lightIconsAccent.color
      static let white = Assets.Colors.lightIconsWhite.color
      static let secondary = Assets.Colors.lightIconsSecondary.color
      static let tertiary = Assets.Colors.lightIconsTertiary.color
    }
    
    enum Surface {
      static let primary = Assets.Colors.lightSurfacePrimary.color
      static let secondary = Assets.Colors.lightSurfaceSecondary.color
      static let tertiary = Assets.Colors.lightSurfaceTertiary.color
      static let accentGreen = Assets.Colors.lightSurfaceAccentGreen.color
      static let accentYellow = Assets.Colors.lightSurfaceAccentYellow.color
      static let accent = Assets.Colors.lightSurfaceAccent.color
      static let accentRed = Assets.Colors.lightSurfaceAccentRed.color
    }
    
    enum Background {
      static let primary = Assets.Colors.lightBackgroundPrimary.color
      static let textInput = Assets.Colors.ligthBackgroundTextInput.color
    }
    
    enum Button {
      
      enum Primary {
        static let background = Assets.Colors.lightButtonPrimaryBackground.color
        static let backgroundPressed = Assets.Colors.lightButtonPrimaryBackgroundPressed.color
        static let backgroundDisabled = Assets.Colors.lightButtonPrimaryBackgroundDisabled.color
        static let title = Assets.Colors.lightButtonPrimaryTitle.color
        static let icon = Assets.Colors.lightButtonPrimaryIcon.color
      }
    }
  }
  
  // MARK: - Gradient
  enum Gradient {
    static let blue = Assets.Colors.gradientBlue.color
    static let turquoise = Assets.Colors.gradientTurquoise.color
    static let white = Assets.Colors.gradientWhite.color
    static let whiteTransparent = Assets.Colors.gradientWhiteTransparent.color
    static let black = Assets.Colors.gradientBlack.color
    static let blackFullTransparent = Assets.Colors.gradientBlackFullTransparent.color
    static let blackTransparent = Assets.Colors.gradientBlackTransparent.color
  }
}

// swiftlint:enable nesting
