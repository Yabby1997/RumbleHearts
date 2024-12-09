import SwiftGodot

@Godot
class Character: CharacterBody2D {
    #signal("speed_change", arguments: ["new_speed": Double.self])
    
    @Export var speed: Double = 100 {
        willSet { emit(signal: Self.speedChange, newValue) }
    }
    
    var flagSpeed: Double = 100
    var isDragging = false
    var targetPosition: Vector2? = nil
    
    @SceneTree(path: "NavigationAgent2D") var navigationAgent: NavigationAgent2D?
    @SceneTree(path: "AnimatedSprite2D") var animatedSprite: AnimatedSprite2D?
    
    let stateMachine = CharacterStateMachine()

    public override func _ready() {
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
    
    @Callable
    func move(position: Vector2) {
        isDragging = false
        navigationAgent?.pathPostprocessing = .corridorfunnel
        targetPosition = position
    }
    
    @Callable
    func onVelocityComputed(velocity: Vector2) {
        self.velocity = velocity
    }
    
    @Callable
    func updateFlagSpeed(flagSpeed: Double) {
        self.flagSpeed = flagSpeed
    }
}
