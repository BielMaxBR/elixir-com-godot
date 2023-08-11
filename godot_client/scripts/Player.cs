using Godot;
using System;

public class Player : Godot.KinematicBody2D
{
    public bool is_local = false;
    public float Speed = 200f;
    public string id;
    public override void _Ready()
    {
        Name = "player-" + id;
    }

    public override void _PhysicsProcess(float delta)
    {
        Vector2 lastPosition = Position;
        if (is_local)
        {
            Vector2 direction = Input.GetVector("left", "right", "up", "down");
            
            
            MoveAndSlide(direction * Speed, Vector2.Zero);
        }
        if (lastPosition != Position) GetParent<sharp>().SendPosition(Position);
    }

    public void Send_message_timer()
    {
    }
}
