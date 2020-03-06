
import SwiftUI

struct Foo: View {

    @Environment(\.fooStyle) private var style

    var body: some View {
        Text("")
    }
}

protocol FooStyle {
    associatedtype Body: View
    func makeBody() -> Body
}

struct CircleFooStyle: FooStyle {

    func makeBody() -> some View {
        Circle()
    }
}

extension View {

    func fooStyle<Style: FooStyle>(_ style: Style) -> some View {
        environment(\.fooStyle, AnyFooStyle(style: style))
    }
}

private struct AnyFooStyle {
    // Can this be done without using AnyView?
    let makeBody: () -> AnyView
    init<Style: FooStyle>(style: Style) {
        makeBody = { AnyView(style.makeBody()) }
    }
}

extension EnvironmentValues {

    // Because the fooStyle can change to any foo style, we can't use generics.
    // Is this how ButtonStyle et al are implemented under the hood?
    private struct FooStyleKey: EnvironmentKey {
        static let defaultValue = AnyFooStyle(style: CircleFooStyle())
    }

    fileprivate var fooStyle: AnyFooStyle {
        get { self[FooStyleKey.self] }
        set { self[FooStyleKey.self] = newValue }
    }
}
