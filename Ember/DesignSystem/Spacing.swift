import SwiftUI

// MARK: - Ember Premium Spacing System
struct EmberSpacing {
    // MARK: - Base Spacing Scale (8pt grid system)
    static let xxxs: CGFloat = 2    // 2pt
    static let xxs: CGFloat = 4     // 4pt
    static let xs: CGFloat = 8      // 8pt
    static let sm: CGFloat = 12     // 12pt
    static let md: CGFloat = 16     // 16pt
    static let lg: CGFloat = 20     // 20pt
    static let xl: CGFloat = 24     // 24pt
    static let xxl: CGFloat = 32    // 32pt
    static let xxxl: CGFloat = 40   // 40pt
    static let xxxxl: CGFloat = 48  // 48pt
    static let xxxxxl: CGFloat = 64 // 64pt
    
    // MARK: - Semantic Spacing
    struct Component {
        static let padding = md          // 16pt - Standard component padding
        static let margin = lg           // 20pt - Standard component margin
        static let gap = sm             // 12pt - Standard gap between elements
        static let gapLarge = xl        // 24pt - Large gap between sections
    }
    
    struct Layout {
        static let screenPadding = xl    // 24pt - Screen edge padding
        static let cardPadding = lg      // 20pt - Card internal padding
        static let sectionSpacing = xxxl // 40pt - Spacing between major sections
        static let groupSpacing = xl     // 24pt - Spacing between related groups
    }
    
    struct Typography {
        static let lineSpacing = xxs     // 4pt - Additional line spacing
        static let paragraphSpacing = md // 16pt - Spacing between paragraphs
        static let headlineSpacing = lg  // 20pt - Spacing after headlines
    }
    
    // MARK: - Interactive Element Spacing
    struct Interactive {
        static let buttonPadding = md    // 16pt - Button internal padding
        static let buttonSpacing = sm    // 12pt - Spacing between buttons
        static let inputPadding = md     // 16pt - Input field padding
        static let touchTarget: CGFloat = 44      // 44pt - Minimum touch target size
    }
    
    // MARK: - Premium Layout Spacing
    struct Premium {
        static let heroSpacing = xxxxxl  // 64pt - Hero section spacing
        static let featureSpacing = xxxxl // 48pt - Feature section spacing
        static let contentSpacing = xxxl  // 40pt - Content section spacing
        static let cardSpacing = xxl      // 32pt - Card spacing
    }
}

// MARK: - Spacing Modifiers
extension View {
    // MARK: - Padding Modifiers
    func emberPadding(_ spacing: CGFloat = EmberSpacing.md) -> some View {
        self.padding(spacing)
    }
    
    func emberPadding(_ edges: Edge.Set, _ spacing: CGFloat = EmberSpacing.md) -> some View {
        self.padding(edges, spacing)
    }
    
    func emberScreenPadding() -> some View {
        self.padding(.horizontal, EmberSpacing.Layout.screenPadding)
    }
    
    func emberCardPadding() -> some View {
        self.padding(EmberSpacing.Layout.cardPadding)
    }
    
    func emberComponentPadding() -> some View {
        self.padding(EmberSpacing.Component.padding)
    }
    
    // MARK: - Spacing Modifiers
    func emberSpacing(_ spacing: CGFloat = EmberSpacing.md) -> some View {
        VStack(spacing: spacing) {
            self
        }
    }
    
    func emberSectionSpacing() -> some View {
        VStack(spacing: EmberSpacing.Layout.sectionSpacing) {
            self
        }
    }
    
    func emberGroupSpacing() -> some View {
        VStack(spacing: EmberSpacing.Layout.groupSpacing) {
            self
        }
    }
    
    // MARK: - Frame Modifiers
    func emberMinTouchTarget() -> some View {
        self.frame(minWidth: EmberSpacing.Interactive.touchTarget, 
                  minHeight: EmberSpacing.Interactive.touchTarget)
    }
    
    func emberButtonFrame() -> some View {
        self
            .padding(.horizontal, EmberSpacing.Interactive.buttonPadding)
            .padding(.vertical, EmberSpacing.sm)
            .frame(minHeight: EmberSpacing.Interactive.touchTarget)
    }
}

// MARK: - Layout Helpers
struct EmberVStack<Content: View>: View {
    let spacing: CGFloat
    let content: Content
    
    init(spacing: CGFloat = EmberSpacing.md, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: spacing) {
            content
        }
    }
}

struct EmberHStack<Content: View>: View {
    let spacing: CGFloat
    let content: Content
    
    init(spacing: CGFloat = EmberSpacing.md, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            content
        }
    }
}

struct EmberLazyVGrid<Content: View>: View {
    let columns: [GridItem]
    let spacing: CGFloat
    let content: Content
    
    init(columns: [GridItem], spacing: CGFloat = EmberSpacing.md, @ViewBuilder content: () -> Content) {
        self.columns = columns
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            content
        }
    }
}

// MARK: - Responsive Spacing
extension EmberSpacing {
    struct Responsive {
        static func padding(for sizeClass: UserInterfaceSizeClass?) -> CGFloat {
            switch sizeClass {
            case .compact:
                return md
            case .regular:
                return xl
            default:
                return lg
            }
        }
        
        static func margin(for sizeClass: UserInterfaceSizeClass?) -> CGFloat {
            switch sizeClass {
            case .compact:
                return lg
            case .regular:
                return xxl
            default:
                return xl
            }
        }
        
        static func sectionSpacing(for sizeClass: UserInterfaceSizeClass?) -> CGFloat {
            switch sizeClass {
            case .compact:
                return xxxl
            case .regular:
                return xxxxxl
            default:
                return xxxxl
            }
        }
    }
}

// MARK: - Responsive Modifiers
extension View {
    func emberResponsivePadding() -> some View {
        GeometryReader { geometry in
            let sizeClass = geometry.size.width > 768 ? UserInterfaceSizeClass.regular : UserInterfaceSizeClass.compact
            self.padding(EmberSpacing.Responsive.padding(for: sizeClass))
        }
    }
    
    func emberResponsiveMargin() -> some View {
        GeometryReader { geometry in
            let sizeClass = geometry.size.width > 768 ? UserInterfaceSizeClass.regular : UserInterfaceSizeClass.compact
            self.padding(.horizontal, EmberSpacing.Responsive.margin(for: sizeClass))
        }
    }
}