import SwiftUI
import ServiceManagement

@main
struct MemBarApp: App {
    @StateObject private var monitor = MemoryMonitor()

    init() {
        registerAsLoginItemIfNeeded()
    }

    var body: some Scene {
        MenuBarExtra {
            MemoryMenuView(monitor: monitor)
        } label: {
            HStack(spacing: 4) {
                Text(monitor.menuBarDisplayText)
                    .monospacedDigit()
            }
        }
        .menuBarExtraStyle(.window)
    }

    private var pressureColor: Color {
        switch monitor.pressureLevel {
        case .normal: return .green
        case .warning: return .yellow
        case .critical: return .red
        }
    }

    private func registerAsLoginItemIfNeeded() {
        guard #available(macOS 13.0, *) else { return }

        let service = SMAppService.mainApp
        if service.status == .notRegistered || service.status == .notFound {
            try? service.register()
        }
    }
}
