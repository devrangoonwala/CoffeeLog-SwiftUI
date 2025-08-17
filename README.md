# ☕ CoffeeLog - iOS Coffee Brewing Companion

A comprehensive iOS app built with SwiftUI for coffee enthusiasts to log their brewing experiments, calculate ratios, and track their coffee journey.


## ✨ Features

### 📝 Coffee Logging
- **Detailed Brew Records**: Log coffee name, brew method, beans weight, water weight, grind size, temperature, and brew time
- **Coffee Information**: Track origin, coffee type, altitude, and roast level
- **Notes & Observations**: Add personal notes about each brew
- **Automatic Timestamps**: Every entry is automatically dated and timed

### 📊 Coffee Ratio Calculator
- **Real-time Ratio Calculation**: Instantly see your coffee-to-water ratio
- **Common Brewing Ratios**: Pre-configured ratios for popular methods:
  - Espresso (1:2.0)
  - Pour Over (1:16.67)
  - French Press (1:15.0)
  - AeroPress (1:17.0)
  - Chemex (1:16.0)
  - V60 (1:16.67)
  - And more...
- **Interactive Sliders**: Adjust coffee and water weights with precision
- **Total Brew Calculation**: See your total brew weight

### ⚖️ Digital Scale Simulator
- **Realistic Scale Display**: Large, easy-to-read weight display
- **Target Weight Tracking**: Set and track your target weight
- **Progress Visualization**: Visual progress bar toward your target
- **Tare Function**: Zero the scale for accurate measurements
- **Simulated Weight Addition**: Test the scale functionality

### 📱 Modern iOS Design
- **Tab-based Navigation**: Three main sections for easy access
- **Adaptive UI**: Works seamlessly across all iPhone sizes
- **Smooth Animations**: Spring animations for a polished feel
- **Dark Mode Support**: Automatic light/dark mode adaptation
- **Accessibility**: VoiceOver and accessibility features included

## 🏗️ Architecture

- **SwiftUI**: Modern declarative UI framework
- **MVVM Pattern**: Clean separation of concerns
- **FileManager**: Local JSON storage for coffee entries
- **Environment Objects**: Shared state management across tabs
- **iOS 16+**: Leverages latest iOS features and APIs

## 📱 Screenshots

### Main Features
- **Logs Tab**: Comprehensive coffee logging form
- **History Tab**: View and manage all your coffee entries
- **Calculator Tab**: Ratio calculator and digital scale

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 16.0+ deployment target
- macOS 13.0 or later (for development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/devrangoonwala/CoffeeLog-SwiftUI.git
   cd CoffeeLog-SwiftUI
   ```

2. **Open in Xcode**
   ```bash
   open CoffeeLog.xcodeproj
   ```

3. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### App Icon Setup
The project includes a custom coffee-themed app icon. To use it:
1. Convert the provided `coffee_icon.svg` to PNG files in the required sizes
2. Add the PNG files to `Assets.xcassets/AppIcon.appiconset/`
3. The `Contents.json` file is already configured with the correct mappings

## 📖 Usage Guide

### Logging a Coffee Entry
1. Open the **Logs** tab
2. Fill in the coffee details:
   - Coffee name and brew method (required)
   - Beans weight and water weight
   - Grind size and water temperature
   - Brew time
3. Add optional information:
   - Origin, coffee type, altitude
   - Roast level
   - Personal notes
4. Tap **Save Coffee Log**

### Using the Ratio Calculator
1. Open the **Calculator** tab
2. Adjust coffee and water weights using the sliders
3. View the calculated ratio in real-time
4. Use pre-configured ratios by tapping on brewing methods
5. Open the digital scale for precise measurements

### Managing Your History
1. Open the **History** tab
2. View all your coffee entries in chronological order
3. Swipe left on entries to delete them
4. Tap the **Edit** button to enter edit mode for bulk deletion

## 🛠️ Technical Details

### File Structure
```
CoffeeLog/
├── CoffeeLogApp.swift          # App entry point
├── Views/
│   ├── CoffeeLogView.swift     # Main logging form
│   ├── HistoryView.swift       # Coffee entries history
│   └── CoffeeRatioCalculatorView.swift # Calculator & scale
├── ViewModels/
│   └── CoffeeLogViewModel.swift # Data management
├── Models/
│   └── CoffeeEntry.swift       # Coffee entry data model
├── Helpers/
│   └── FileManager+Documents.swift # File storage utilities
└── Assets.xcassets/            # App icons and assets
```

### Data Model
```swift
struct CoffeeEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    var type: String              // Coffee name
    var brewMethod: String        // Brewing method
    var rating: Int               // Rating (1-5)
    var gramsUsed: Double         // Beans weight
    var pourTimeSeconds: Int      // Brew time
    var stopTime: Date?           // Optional stop time
    var notes: String?            // Personal notes
    var origin: String?           // Coffee origin
    var coffeeType: String?       // Coffee type (Arabica, etc.)
    var altitudeMeters: Int?      // Growing altitude
}
```

### Storage
- **Local JSON Storage**: All data is stored locally using FileManager
- **Automatic Saving**: Changes are saved immediately
- **Data Persistence**: Entries survive app restarts and updates

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Guidelines
- Follow SwiftUI best practices
- Maintain MVVM architecture
- Add comments for complex logic
- Test on multiple device sizes
- Ensure accessibility compliance

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with ❤️ using SwiftUI
- Inspired by coffee enthusiasts worldwide
- Icons from SF Symbols
- Coffee brewing ratios from industry standards

## 📞 Support

If you have any questions or need help with the app:
- Open an issue on GitHub
- Check the documentation above
- Review the code comments for implementation details

---

**Happy Brewing! ☕**

*CoffeeLog helps you perfect your coffee brewing technique, one cup at a time.*
