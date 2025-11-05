import SwiftUI

// MARK: - Ember Text Field
struct EmberTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var isFocused: Bool
    @State private var isSecureVisible = false
    
    init(_ title: String = "", placeholder: String, text: Binding<String>, isSecure: Bool = false, keyboardType: UIKeyboardType = .default) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !title.isEmpty {
                Text(title)
                    .emberLabel()
            }
            
            HStack(spacing: 12) {
                Group {
                    if isSecure && !isSecureVisible {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                            .keyboardType(keyboardType)
                    }
                }
                .emberBody()
                .focused($isFocused)
                
                if isSecure {
                    Button(action: { isSecureVisible.toggle() }) {
                        Image(systemName: isSecureVisible ? "eye.slash" : "eye")
                            .font(.system(size: 16))
                            .foregroundColor(EmberColors.textSecondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(height: 48)
            .background(EmberColors.adaptiveSurface(for: colorScheme))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 1)
        }
    }
    
    private var borderColor: Color {
        if isFocused {
            return EmberColors.roseQuartz
        }
        return EmberColors.adaptiveBorder(for: colorScheme)
    }
    
    private var shadowColor: Color {
        if isFocused {
            return EmberColors.roseQuartz.opacity(0.1)
        }
        return Color.clear
    }
    
    private var shadowRadius: CGFloat {
        isFocused ? 3 : 0
    }
}

// MARK: - Ember Toggle Switch
struct EmberToggle: View {
    let title: String
    @Binding var isOn: Bool
    
    @State private var animateToggle = false
    
    var body: some View {
        HStack {
            Text(title)
                .emberBody()
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isOn.toggle()
                    animateToggle.toggle()
                }
            }) {
                ZStack {
                    // Background
                    Capsule()
                        .fill(isOn ? EmberColors.roseQuartz : EmberColors.border)
                        .frame(width: 52, height: 32)
                    
                    // Thumb
                    Circle()
                        .fill(Color.white)
                        .frame(width: 28, height: 28)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        .offset(x: isOn ? 10 : -10)
                        .scaleEffect(animateToggle ? 1.1 : 1.0)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Ember Search Field
struct EmberSearchField: View {
    let placeholder: String
    @Binding var text: String
    let onSearchTapped: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var isFocused: Bool
    
    init(placeholder: String = "Search...", text: Binding<String>, onSearchTapped: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self._text = text
        self.onSearchTapped = onSearchTapped
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(EmberColors.textSecondary)
            
            TextField(placeholder, text: $text)
                .emberBody()
                .focused($isFocused)
                .onSubmit {
                    onSearchTapped?()
                }
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(EmberColors.textSecondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(height: 44)
        .background(EmberColors.adaptiveSurface(for: colorScheme))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(borderColor, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
    
    private var borderColor: Color {
        if isFocused {
            return EmberColors.roseQuartz
        }
        return EmberColors.adaptiveBorder(for: colorScheme)
    }
}

// MARK: - Ember Badge
struct EmberBadge: View {
    let text: String
    let style: BadgeStyle
    
    init(_ text: String, style: BadgeStyle = .default) {
        self.text = text
        self.style = style
    }
    
    var body: some View {
        Text(text)
            .emberText(.labelSmall, color: textColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
    
    private var backgroundColor: Color {
        switch style {
        case .default:
            return EmberColors.coralPop
        case .success:
            return EmberColors.success.opacity(0.2)
        case .warning:
            return EmberColors.warning.opacity(0.2)
        case .error:
            return EmberColors.error.opacity(0.2)
        case .info:
            return EmberColors.info.opacity(0.2)
        }
    }
    
    private var textColor: Color {
        switch style {
        case .default:
            return EmberColors.roseQuartz
        case .success:
            return EmberColors.success
        case .warning:
            return EmberColors.warning
        case .error:
            return EmberColors.error
        case .info:
            return EmberColors.info
        }
    }
}

extension EmberBadge {
    enum BadgeStyle {
        case `default`
        case success
        case warning
        case error
        case info
    }
}

// MARK: - Ember Slider
struct EmberSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    
    init(_ title: String, value: Binding<Double>, in range: ClosedRange<Double>, step: Double = 1) {
        self.title = title
        self._value = value
        self.range = range
        self.step = step
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .emberLabel()
                
                Spacer()
                
                Text("\(Int(value))")
                    .emberText(.labelMedium, color: EmberColors.roseQuartz)
            }
            
            Slider(value: $value, in: range, step: step, label: {
                EmptyView()
            }, minimumValueLabel: {
                Text("\(Int(range.lowerBound))")
                    .emberText(.labelSmall, color: EmberColors.textSecondary)
            }, maximumValueLabel: {
                Text("\(Int(range.upperBound))")
                    .emberText(.labelSmall, color: EmberColors.textSecondary)
            })
            .tint(EmberColors.roseQuartz)
        }
    }
}

// MARK: - Ember Picker
struct EmberPicker<SelectionValue: Hashable, Content: View>: View {
    let title: String
    @Binding var selection: SelectionValue
    let content: Content
    
    init(_ title: String, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) {
        self.title = title
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .emberLabel()
            
            Picker(title, selection: $selection) {
                content
            }
            .pickerStyle(.segmented)
            .tint(EmberColors.roseQuartz)
        }
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 24) {
            EmberTextField("Email", placeholder: "Enter your email", text: .constant(""))
            
            EmberTextField("Password", placeholder: "Enter password", text: .constant(""), isSecure: true)
            
            EmberSearchField(text: .constant(""))
            
            EmberToggle(title: "Enable notifications", isOn: .constant(true))
            
            HStack {
                EmberBadge("New")
                EmberBadge("Success", style: .success)
                EmberBadge("Warning", style: .warning)
                EmberBadge("Error", style: .error)
            }
            
            EmberSlider("Volume", value: .constant(50), in: 0...100)
            
            EmberPicker("Theme", selection: .constant("Light")) {
                Text("Light").tag("Light")
                Text("Dark").tag("Dark")
                Text("Auto").tag("Auto")
            }
        }
        .padding()
    }
}
