using Godot;
using System;
using Fenix;

public class sharp : Node2D
{
	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";

	// Called when the node enters the scene tree for the first time.
	public async override void _Ready()
	{
		// Defaults should be ok, but you can tweak some options, e.g. tur on logging, max retries etc.. 
		var settings = new Settings();
		var socket = new Socket(settings);
		try
		{
			var uri = new Uri("ws://localhost:4000/socket/websocket");
			// "token" is not required, but below is demo how to pass parameteters while connecting
			await socket.ConnectAsync(uri, new[] {("ok", "ok")});
			var channel = socket.Channel("chat:lobby", new {});
			channel.Subscribe("", (ch, payload) => {
				GD.Print(payload.Value<String>("body"));
			});
		}
		catch (Exception ex)
		{
			Console.WriteLine($"Error: [{ex.GetType().FullName}] \"{ex.Message}\"");
		}
	}

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
