# Ember: Couples Haptics App 💕

**Stay connected through touch, no matter the distance.**

Ember is a premium iOS app designed to help couples maintain intimate physical connection through haptic feedback, real-time touch sharing, and emotional communication tools. Built with SwiftUI and Core Haptics, Ember transforms your iPhone into a bridge for physical affection.

## ✨ Features

### 🤲 Core Touch Features
- **Live Touch Canvas**: Draw touches with your finger and send haptic feedback to your partner in real-time
- **Quick Touch Gestures**: Send instant kisses, hugs, waves, and love taps with custom haptic patterns
- **Touch History**: View and replay past touch sessions
- **Touch Patterns**: Explore different haptic styles and intensities

### 💬 Communication Tools
- **Love Notes**: Send sweet text messages with beautiful animations
- **Voice Messages**: Record and share voice notes with your partner
- **Photo Messages**: Share moments through images
- **Status Updates**: Let your partner know how you're feeling with 23 different mood states

### 👥 Character System
Meet **Touchy** and **Syncee** - your adorable blob companions that represent you and your partner:
- **8 Different Expressions**: Happy, excited, love, sleepy, sad, waiting, romantic, warm smile
- **9 Color Themes**: Default ember, sunset, ocean, forest, lavender, orange, coral, blue, pink
- **6 Accessories**: Crown, party hat, bow tie, glasses, flower, or none
- **Animated Personalities**: Characters breathe, blink, and react to your emotions

### 📊 Relationship Analytics
- **Daily Touch Goals**: Set and track daily connection targets
- **Streak Counter**: Maintain your connection streak
- **Activity History**: View detailed relationship analytics
- **Progress Tracking**: Monitor your communication patterns

### 🎯 Premium Features
- **Heartbeat Sync**: Feel each other's heartbeat through haptic feedback
- **Location Sharing**: Share your location with contextual messages
- **Advanced Touch Patterns**: Unlock premium haptic experiences
- **Voice Message Recording**: High-quality audio messages

## 🏗️ Architecture

### Core Components

#### **Managers**
- `EmberHapticsManager`: Handles Core Haptics integration and custom haptic patterns
- `EmberAuthManager`: Manages user authentication and partner connections
- `EmberNotificationManager`: Handles push notifications and alerts
- `EmberStreakManager`: Tracks daily connection streaks

#### **Models**
- `CoupleStatus`: 23 different status types across 5 categories (Love & Romance, Mood & Energy, Daily Life, Physical & Health, Emotional)
- `TouchGesture`: Represents different types of touches (kiss, hug, wave, love, tickle, squeeze)
- `CharacterCustomization`: Handles character appearance and expressions
- `UserStatus`: Manages user mood and custom messages

#### **Design System**
- **Premium Typography**: SF Pro Display/Text with 8 font sizes and custom modifiers
- **Color System**: Brand colors (Rose Quartz, Peachy Keen, Coral Pop) with semantic variants
- **Spacing System**: 8pt grid system with semantic spacing helpers
- **Shadow System**: 6 elevation levels with brand-colored shadows
- **Icon System**: Organized icon categories with size variants

### Screen Architecture

```
📱 App Structure
├── 🏠 Home (EmberHomeView)
│   ├── Partner status & connection
│   ├── Character display (Touchy & Syncee)
│   ├── Daily progress tracking
│   ├── Quick touch actions
│   ├── Love notes section
│   ├── Heartbeat sync (Premium)
│   ├── Voice messages
│   └── Location sharing
├── 💝 Memories (EmberMemoriesView)
│   ├── Memory capture & gallery
│   ├── Timeline view
│   ├── Milestone tracking
│   └── Memory search
├── 🤲 Touch (EmberTouchView)
│   ├── Live touch canvas
│   ├── Touch history
│   ├── Touch patterns
│   └── Premium haptic features
└── 👤 Profile (EmberProfileView)
    ├── Character customization
    ├── Relationship analytics
    ├── Settings & preferences
    └── Support & feedback
```

## 🎨 Design Philosophy

Ember follows a **premium design approach** with:

- **Warm Color Palette**: Rose Quartz (#FF6B9D), Peachy Keen (#FFB07A), Coral Pop (#FF8A65)
- **Glassmorphism Effects**: Subtle transparency and blur effects
- **Micro-interactions**: Smooth animations and haptic feedback
- **Character-Driven UI**: Touchy and Syncee guide the user experience
- **Emotional Design**: Every interaction is designed to evoke warmth and connection

## 🔧 Technical Implementation

### Haptic Feedback System
```swift
// Custom haptic patterns for different gestures
static let kiss = HapticGesture(
    name: "Kiss",
    events: [
        HapticEvent(time: 0.0, type: .hapticContinuous, intensity: 0.4, sharpness: 0.2, duration: 1.0)
    ],
    duration: 1.0,
    icon: "heart.fill"
)
```

### Character Animation System
```swift
// Blob characters with realistic animations
private func startAnimations() {
    // Bounce animation
    withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
        bounce = -size * 0.035
    }
    // Breathing animation
    withAnimation(.easeInOut(duration: 3.6).repeatForever(autoreverses: true)) {
        breathe = 1.06
    }
    // Random blinking
    Task.detached {
        while true {
            try? await Task.sleep(nanoseconds: UInt64(Double.random(in: 1.9...3.8) * 1_000_000_000))
            // Blink animation
        }
    }
}
```

### Status System
```swift
enum CoupleStatus: String, CaseIterable, Codable {
    // Love & Romance (4)
    case romantic, missing, inLove, dreaming
    // Mood & Energy (4) 
    case happy, excited, peaceful, playful
    // Daily Life (4)
    case available, busy, working, relaxing
    // Physical & Health (5)
    case sleeping, tired, energetic, cozy, underTheWeather
    // Emotional (6)
    case grateful, nostalgic, hopeful, content, feelingBlue, thatTimeOfTheMonth
}
```

## 🚀 Getting Started

### Prerequisites
- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+
- Core Haptics support (iPhone 8 and later)

### Installation
1. Clone the repository
2. Open `Ember.xcodeproj` in Xcode
3. Build and run on a physical device (haptics require hardware)

### Configuration
The app uses mock authentication for development. In production, you would integrate with:
- Firebase Authentication
- Real-time database for touch synchronization
- Push notifications for partner interactions

## 📱 User Experience Flow

1. **Onboarding**: Users create accounts and connect with their partner
2. **Character Setup**: Customize Touchy and Syncee appearances
3. **Daily Connection**: Set status, send touches, share moments
4. **Touch Canvas**: Draw touches that translate to haptic feedback
5. **Memory Building**: Capture and save special moments together
6. **Analytics**: Track relationship connection patterns

## 🎯 Target Audience

- **Long-distance couples** seeking physical connection
- **Busy couples** wanting quick emotional check-ins
- **Tech-savvy partners** who appreciate innovative communication
- **Privacy-conscious users** preferring intimate, closed communication

## 🔮 Future Enhancements

- **Apple Watch Integration**: Haptic feedback on wrist
- **Couple Challenges**: Daily connection goals and achievements
- **AI Mood Detection**: Automatic status updates based on usage patterns
- **Custom Haptic Creation**: Let users design their own touch patterns
- **Video Messages**: Short video clips with haptic accompaniment
- **Sleep Mode**: Gentle haptic goodnight/good morning routines

## 🛡️ Privacy & Security

- **End-to-end encryption** for all communications
- **Local data storage** with optional cloud backup
- **No data sharing** with third parties
- **Partner-only access** to all shared content
- **Secure authentication** with biometric support

## 🎨 Brand Identity

**Ember** represents the warm, glowing connection between two people - like embers that keep a fire alive even when apart. The app's design reflects this through:

- Warm, gradient colors that evoke sunset and candlelight
- Soft, rounded shapes that feel approachable and intimate
- Gentle animations that mirror the flickering of embers
- Character design that's cute but sophisticated

---

**Ember: Where distance disappears and love ignites.** 🔥💕

*Built with love, powered by touch, connected by technology.*