using Godot;
using System;
using System.Threading;
using System.Threading.Tasks;
using Fenix;

public class sharp : Node2D
{
	public async override void _Ready()
	{
		var settings = new Settings();
		var socket = new Socket(settings);
		try
		{
			var uri = new Uri("ws://localhost:4000/socket/websocket");
			
			await socket.ConnectAsync(uri, new[] {("ok", "ok")});

			var channel = socket.Channel("chat:lobby", new {});
			
			channel.Subscribe("shout", (ch, payload) => {
				GD.Print(payload.Value<String>("body"));
			});
			
			var result = await channel.JoinAsync();
    		GD.Print($"Lobby JOIN: status = '{result.Status}', response: {result.Response}");
			
			await channel.SendAsync("shout", new {body = "uepa"});
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
