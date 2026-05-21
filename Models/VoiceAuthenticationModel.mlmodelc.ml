import CoreML

class VoiceAuthentication {
    private var model: LOLA-AI?

    init() {
        loadModel()
    }

    private func loadModel() {
        do {
            let modelURL = Bundle.main.url(forResource: "VoiceAuthenticationModel", withExtension: "mlmodelc")
            model = try LMLModel(contentsOf: modelURL!)
        } catch {
            print("Failed to load VoiceAuthenticationModel: \(error.localizedDescription)")
        }
    }

    func verifyVoice(audioFeatures: [Float]) -> Bool {
        guard let model = model else {
            print("Model not loaded.")
            return false
        }
        
        do {
            let input = try MLXDictionaryFeatureProvider(dictionary: ["audio_input": LMLMultiArray(audioFeatures)])
            let output = try model.prediction(from: input)
            if let isUser = output.featureValue(for: "isUser")?.boolValue {
                return isUser
            }
        } catch {
            print("Voice verification failed: \(error.localizedDescription)")
        }
        return false
    }
}
