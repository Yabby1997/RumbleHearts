import SwiftGodot

@Godot
class Character: CharacterBody2D {
    // MARK: - Signals
    
    #signal("characterDidChangeSpeed", arguments: ["newSpeed": Double.self])
    var characterDidChangeSpeed: GenericSignal<Double> { GenericSignal<Double> (target: self, signalName: "characterDidChangeSpeed") }
    
    // MARK: - Dependencies
    
    @SceneTree(path: "NavigationAgent2D") var navigationAgent: NavigationAgent2D?
    @SceneTree(path: "AnimatedSprite2D") var animatedSprite: AnimatedSprite2D?
    let stateMachine = CharacterStateMachine()
    
    // MARK: - Properties
    
    @Export var speed: Double = 100 { didSet { emit(signal: Self.characterDidChangeSpeed, speed) } }
    var flagSpeed: Double = 100
    var isDragging = false
    var targetPosition: Vector2? = nil

    // MARK: - Lifecycle
    
    override func _ready() {
        navigationAgent?.velocityComputed.connect(onVelocityComputed)
        stateMachine.changeState(IdleState(character: self))
    }
    
    override func _unhandledInput(event: InputEvent?) {
        guard let event,
              let mouseEvent = event as? InputEventMouseButton,
              mouseEvent.buttonIndex == MouseButton.left else { return }
        if event.isPressed() {
            guard getGlobalTransform().origin.distanceTo(getGlobalMousePosition()) < 10 else { return }
            isDragging = true
            navigationAgent?.pathPostprocessing = .edgecentered
        } else if !event.isPressed(), isDragging {
            isDragging = false
            targetPosition = getGlobalMousePosition()
        }
    }
    
    override func _physicsProcess(delta: Double) {
        stateMachine.update(delta: delta)
        moveAndSlide()
    }
    
    // MARK: - Methods
    
    func move(position: Vector2) {
        isDragging = false
        navigationAgent?.pathPostprocessing = .corridorfunnel
        targetPosition = position
    }
    
    // MARK: - Signal callbacks
    
    func onVelocityComputed(velocity: Vector2) {
        self.velocity = velocity
    }
}
