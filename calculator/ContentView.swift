import SwiftUI

struct ContentView: View {
    @State private var currentValue = "0"
    @State private var currentOperation: Operation? = nil
    @State private var previousValue = "0"
    @State private var isTypingNumber = false

    enum Operation {
        case add, subtract, multiply, divide
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 12) {
                    Spacer()
                    
                    Text(currentValue)
                        .font(.system(size: 76, weight: .light))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, 20)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .foregroundColor(.white)
                    
                    Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                        GridRow {
                            CalculatorButton(title: "C", color: .gray) { clear() }
                            CalculatorButton(title: "+/-", color: .gray) { toggleSign() }
                            CalculatorButton(title: "%", color: .gray) { percentage() }
                            CalculatorButton(title: "÷", color: .orange) { setOperation(.divide) }
                        }
                        GridRow {
                            CalculatorButton(title: "7") { appendNumber("7") }
                            CalculatorButton(title: "8") { appendNumber("8") }
                            CalculatorButton(title: "9") { appendNumber("9") }
                            CalculatorButton(title: "×", color: .orange) { setOperation(.multiply) }
                        }
                        GridRow {
                            CalculatorButton(title: "4") { appendNumber("4") }
                            CalculatorButton(title: "5") { appendNumber("5") }
                            CalculatorButton(title: "6") { appendNumber("6") }
                            CalculatorButton(title: "-", color: .orange) { setOperation(.subtract) }
                        }
                        GridRow {
                            CalculatorButton(title: "1") { appendNumber("1") }
                            CalculatorButton(title: "2") { appendNumber("2") }
                            CalculatorButton(title: "3") { appendNumber("3") }
                            CalculatorButton(title: "+", color: .orange) { setOperation(.add) }
                        }
                        GridRow {
                            CalculatorButton(title: "0") { appendNumber("0") }
                                .gridCellColumns(2)
                            CalculatorButton(title: ".") { appendDecimal() }
                            CalculatorButton(title: "=", color: .orange) { calculate() }
                        }
                    }
                    .padding()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }

    func appendNumber(_ number: String) {
        if isTypingNumber {
            currentValue += number
        } else {
            currentValue = number
            isTypingNumber = true
        }
    }

    func setOperation(_ operation: Operation) {
        if currentOperation != nil {
            calculate()
        }
        previousValue = currentValue
        currentOperation = operation
        isTypingNumber = false
    }

    func calculate() {
        guard let operation = currentOperation else { return }
        guard let previousNumber = Double(previousValue),
              let currentNumber = Double(currentValue) else { return }

        let result: Double

        switch operation {
        case .add:
            result = previousNumber + currentNumber
        case .subtract:
            result = previousNumber - currentNumber
        case .multiply:
            result = previousNumber * currentNumber
        case .divide:
            result = previousNumber / currentNumber
        }

        currentValue = String(format: "%g", result)
        currentOperation = nil
        isTypingNumber = false
    }

    func clear() {
        currentValue = "0"
        previousValue = "0"
        currentOperation = nil
        isTypingNumber = false
    }

    func toggleSign() {
        if let value = Double(currentValue) {
            currentValue = String(format: "%g", -value)
        }
    }

    func percentage() {
        if let value = Double(currentValue) {
            currentValue = String(format: "%g", value / 100)
        }
    }

    func appendDecimal() {
        if !currentValue.contains(".") {
            currentValue += "."
            isTypingNumber = true
        }
    }
}

struct CalculatorButton: View {
    let title: String
    let color: Color
    let action: () -> Void

    init(title: String, color: Color = Color(red: 0.2, green: 0.2, blue: 0.2), action: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 32, weight: .medium))
                .frame(width: 80, height: 80)
                .background(color)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 16 Pro"))
            .previewDisplayName("iPhone 16 Pro")
    }
}

