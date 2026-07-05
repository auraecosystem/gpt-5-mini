import SwiftUI
import Combine
import Persist
import GitHubCopilotService

class CopilotMCPToolManagerObservable: ObservableObject {
    static let shared = CopilotMCPToolManagerObservable()

    @Published var availableMCPServerTools: [MCPServerToolsCollection] = []
    private var cancellables = Set<AnyCancellable>()

    private init() {
        // Initial load
        availableMCPServerTools = CopilotMCPToolManager.getAvailableMCPServerToolsCollections()
        
        // Setup notification to update when MCP server tools collections change
        NotificationCenter.default
            .publisher(for: .gitHubCopilotMCPToolsDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.refreshTools()
            }
            .store(in: &cancellables)
    }
    
    private func refreshTools() {
        self.availableMCPServerTools = CopilotMCPToolManager.getAvailableMCPServerToolsCollections()
        AppState.shared.cleanupMCPToolsStatus(availableTools: self.availableMCPServerTools)
        AppState.shared.createMCPToolsStatus(self.availableMCPServerTools)
    }
}
