using Godot;
using System;

public partial class main : Node2D
{
	private void _on_play_pressed()
	{
		GetTree().ChangeSceneToFile("res://src/scenes/world.tscn");
	}

	private void _on_exit_pressed()
	{
		GetTree().Quit();
	}
}
