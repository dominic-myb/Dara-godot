using Godot;
using System;

public partial class Player : CharacterBody2D
{
	public const float Speed = 1000.0f;
	public const float JumpVelocity = -500.0f;
	private AnimationPlayer _anim;

	public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();
	public override void _Ready()
	{
		_anim = GetNode<AnimationPlayer>("AnimationPlayer");
	}
	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;

		if (!IsOnFloor())
			velocity.Y += gravity * (float)delta;

		if (Input.IsActionJustPressed("ui_accept") && IsOnFloor())
			velocity.Y = JumpVelocity;

		Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
		if (direction != Vector2.Zero)
		{
			velocity.X = direction.X * Speed;
			if(velocity.Y == 0){
				_anim.Play("Move");
			}
		}
		else
		{
			velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
			if(velocity.Y == 0){
				_anim.Play("Idle");
			}
		}
		if(direction.X == -1){
			GetNode<AnimatedSprite2D>("AnimatedSprite2D").FlipH = true;
		}
		else if(direction.X == 1){
			GetNode<AnimatedSprite2D>("AnimatedSprite2D").FlipH = false;
		}
		_anim.Play();
		Velocity = velocity;
		MoveAndSlide();
	}
}
