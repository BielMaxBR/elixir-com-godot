using Godot;
using System;

public class KinematicBody2D : Godot.KinematicBody2D {
	private int jump_force = 500;
	private float speed = 313;
	private Vector2 velocity = Vector2.Zero;
	private int gravity = 1200;
	
	public void getInput() {
		velocity.x = Input.GetAxis("ui_left","ui_right");

		if (IsOnFloor()) {
			velocity.y = 0;
			if (Input.IsActionJustPressed("ui_up")) {
				velocity.y -= jump_force;
			}
		}
	}
	
	public void movePlayer(float delta) {
		velocity.y += gravity * delta;
		velocity.x *= speed;

		velocity = MoveAndSlide(velocity, Vector2.Up);
	}
	public override void _PhysicsProcess(float delta) {
		getInput();
		movePlayer(delta);		
	}
}
