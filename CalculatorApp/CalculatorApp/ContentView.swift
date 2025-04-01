import SwiftUI

enum Operation {
    case add, subtract, multiply, divide, none
}

struct ContentView: View {
    @State private var display = "0"
    @State private var currentNumber: Double = 0
    @State private var previousNumber: Double = 0
    @State private var operation: Operation = .none
    @State private var performingMath = false

    let buttonRows = [
        ["C", "%", "+/-", "#"],
        ["7", "8", "9", "/"],
        ["4", "5", "6", "x"],
        ["1", "2", "3", "-"],
        ["0", ".", "=", "+"]
    ]

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text(display)
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()

            ForEach(buttonRows, id: \ .self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \ .self) { button in
                        Button(action: { self.buttonTapped(button) }) {
                            Text(button)
                                .frame(width: 70, height: 70)
                                .background(isOperator(button) ? Color.red : Color.gray.opacity(0.7))
                                .foregroundColor(.white)
                                .font(.title)
                                .cornerRadius(35)
                        }
                    }
                }
            }
        }
        .padding()
    }

    func isOperator(_ symbol: String) -> Bool {
        return symbol == "+" || symbol == "-" || symbol == "x" || symbol == "/" || symbol == "="
    }

    func formatNumber(_ number: Double) -> String {
        if floor(number) == number {
            return "\(Int(number))"
        } else {
            let rounded = Double(round(10000 * number) / 10000)
            return "\(rounded)"
        }
    }

    func buttonTapped(_ button: String) {
        if button == "." {
            if !display.contains(".") {
                display += "."
            }
        } else if let _ = Int(button) {
            if performingMath {
                display = button
                performingMath = false
            } else {
                display = display == "0" ? button : display + button
            }
        } else if button == "C" {
            display = "0"
            currentNumber = 0
            previousNumber = 0
            operation = .none
        } else if button == "=" {
            currentNumber = Double(display) ?? 0
            switch operation {
            case .add:
                currentNumber = previousNumber + currentNumber
            case .subtract:
                currentNumber = previousNumber - currentNumber
            case .multiply:
                currentNumber = previousNumber * currentNumber
            case .divide:
                if currentNumber == 0 {
                    display = "Error"
                    performingMath = false
                    return
                }
                currentNumber = previousNumber / currentNumber
            default:
                break
            }
            display = formatNumber(currentNumber)
            performingMath = false
        } else {
            previousNumber = Double(display) ?? 0
            switch button {
            case "+": operation = .add
            case "-": operation = .subtract
            case "x": operation = .multiply
            case "/": operation = .divide
            default: operation = .none
            }
            performingMath = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
