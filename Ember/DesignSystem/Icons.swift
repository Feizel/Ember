import SwiftUI

// MARK: - Ember Premium Icon System
struct EmberIcons {
    // MARK: - Core App Icons
    struct Core {
        static let heart = "heart.fill"
        static let heartOutline = "heart"
        static let touch = "hand.point.up.braille.fill"
        static let connection = "link"
        static let sync = "arrow.triangle.2.circlepath"
        static let ember = "flame.fill"
    }
    
    // MARK: - Navigation Icons
    struct Navigation {
        static let home = "house.fill"
        static let homeOutline = "house"
        static let touch = "hand.draw.fill"
        static let touchOutline = "hand.draw"
        static let memories = "photo.stack.fill"
        static let memoriesOutline = "photo.stack"
        static let profile = "person.crop.circle.fill"
        static let profileOutline = "person.crop.circle"
        static let settings = "gearshape.fill"
        static let settingsOutline = "gearshape"
    }
    
    // MARK: - Touch & Gesture Icons
    struct Touch {
        static let kiss = "heart.fill"
        static let hug = "hands.sparkles.fill"
        static let wave = "hand.wave.fill"
        static let love = "bolt.heart.fill"
        static let heartTrace = "scribble.variable"
        static let loveNote = "text.bubble.fill"
        static let voiceMessage = "mic.fill"
        static let photoMessage = "camera.fill"
        static let heartbeat = "waveform.path.ecg"
        static let locationShare = "location.fill"
        static let draw = "pencil.tip.crop.circle"
        static let send = "paperplane.fill"
    }
    
    // MARK: - Status & Mood Icons
    struct Status {
        static let available = "heart.fill"
        static let busy = "clock.fill"
        static let sleeping = "moon.fill"
        static let romantic = "heart.circle.fill"
        static let missing = "heart.text.square.fill"
        static let excited = "star.fill"
        static let working = "laptopcomputer"
        static let relaxing = "leaf.fill"
        static let feelingBlue = "cloud.rain.fill"
        static let thatTimeOfMonth = "calendar.badge.clock"
        static let underTheWeather = "thermometer.medium"
    }
    
    // MARK: - UI & Interface Icons
    struct Interface {
        static let close = "xmark"
        static let back = "chevron.left"
        static let forward = "chevron.right"
        static let up = "chevron.up"
        static let down = "chevron.down"
        static let menu = "line.3.horizontal"
        static let more = "ellipsis"
        static let search = "magnifyingglass"
        static let filter = "line.3.horizontal.decrease.circle"
        static let sort = "arrow.up.arrow.down"
        static let add = "plus"
        static let edit = "pencil"
        static let delete = "trash"
        static let share = "square.and.arrow.up"
        static let copy = "doc.on.doc"
        static let check = "checkmark"
        static let info = "info.circle"
        static let warning = "exclamationmark.triangle"
        static let error = "xmark.circle"
        static let success = "checkmark.circle"
    }
    
    // MARK: - Communication Icons
    struct Communication {
        static let notification = "bell.fill"
        static let notificationOff = "bell.slash.fill"
        static let message = "message.fill"
        static let messageOutline = "message"
        static let call = "phone.fill"
        static let videoCall = "video.fill"
        static let email = "envelope.fill"
        static let chat = "bubble.left.and.bubble.right.fill"
    }
    
    // MARK: - Premium Features Icons
    struct Premium {
        static let crown = "crown.fill"
        static let star = "star.fill"
        static let diamond = "diamond.fill"
        static let sparkles = "sparkles"
        static let magic = "wand.and.stars"
        static let unlock = "lock.open.fill"
        static let upgrade = "arrow.up.circle.fill"
    }
    
    // MARK: - Character & Customization Icons
    struct Character {
        static let customize = "paintbrush.fill"
        static let colorPalette = "paintpalette.fill"
        static let accessory = "eyeglasses"
        static let expression = "face.smiling.fill"
        static let theme = "circle.lefthalf.striped.horizontal"
    }
    
    // MARK: - Connection & Network Icons
    struct Connection {
        static let connected = "wifi"
        static let disconnected = "wifi.slash"
        static let signal1 = "antenna.radiowaves.left.and.right"
        static let signal2 = "antenna.radiowaves.left.and.right"
        static let signal3 = "antenna.radiowaves.left.and.right"
        static let pairing = "qrcode"
        static let invite = "person.badge.plus"
    }
}

// MARK: - Icon Modifiers
extension View {
    func emberIcon(size: CGFloat = 16, weight: Font.Weight = .regular) -> some View {
        self
            .font(.system(size: size, weight: weight))
    }
    
    func emberIconSmall() -> some View {
        emberIcon(size: 12, weight: .medium)
    }
    
    func emberIconMedium() -> some View {
        emberIcon(size: 16, weight: .medium)
    }
    
    func emberIconLarge() -> some View {
        emberIcon(size: 20, weight: .semibold)
    }
    
    func emberIconXL() -> some View {
        emberIcon(size: 24, weight: .semibold)
    }
    
    func emberIconXXL() -> some View {
        emberIcon(size: 32, weight: .bold)
    }
    
    func emberIconHero() -> some View {
        emberIcon(size: 48, weight: .bold)
    }
}

// MARK: - Premium Icon Components
struct EmberIcon: View {
    let name: String
    let size: CGFloat
    let color: Color
    let weight: Font.Weight
    
    init(_ name: String, size: CGFloat = 16, color: Color = EmberColors.textPrimary, weight: Font.Weight = .regular) {
        self.name = name
        self.size = size
        self.color = color
        self.weight = weight
    }
    
    var body: some View {
        Image(systemName: name)
            .font(.system(size: size, weight: weight))
            .foregroundColor(color)
    }
}



// MARK: - Animated Icons
struct EmberAnimatedIcon: View {
    let icon: String
    let size: CGFloat
    let color: Color
    let isAnimating: Bool
    
    init(_ icon: String, size: CGFloat = 16, color: Color = EmberColors.textPrimary, isAnimating: Bool = false) {
        self.icon = icon
        self.size = size
        self.color = color
        self.isAnimating = isAnimating
    }
    
    var body: some View {
        EmberIcon(icon, size: size, color: color)
            .scaleEffect(isAnimating ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isAnimating)
    }
}

// MARK: - Helper Shape
struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        _path = shape.path(in:)
    }
    
    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}