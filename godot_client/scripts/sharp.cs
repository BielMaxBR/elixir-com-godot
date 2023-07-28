using Godot;
using System;
using System.Threading;
using System.Threading.Tasks;
using Phoenix;
public class sharp : Node2D
{
    private Socket socket;
    private Channel channel;
    public override void _Ready()
    {
        var socketOptions = new Socket.Options(new JsonMessageSerializer());
        var socketAddress = "ws://localhost:4000/socket";
        var socketFactory = new Phoenix.WebSocketImpl.DotNetWebSocketFactory();

        socket = new Socket(socketAddress, null, socketFactory, socketOptions);

        socket.OnOpen += onOpenCallback;
        socket.OnMessage += onMessageCallback;
        socket.OnError += onErrorCallback;
        socket.OnClose += onCloseCallback;

        socket.Connect();

        channel = socket.Channel("chat:lobby");

        channel.OnError(message => {
            GD.Print(message.Payload);
        });
        channel.OnClose(message => {
            GD.Print(message.Payload);
        });
        
        Push push = channel.Join();
        push.Receive(ReplyStatus.Timeout, reply => GD.Print("parado"))
            .Receive(ReplyStatus.Ok, reply => GD.Print("OK"))
            .Receive(ReplyStatus.Error, reply => GD.Print("Errou"));
    }

    private void onCloseCallback(ushort code, string message)
    {
        GD.Print("closed: ", code, message);
    }

    private void onErrorCallback(string message)
    {
        GD.Print("erro: ", message);
    }

    private void onMessageCallback(Message message)
    {
        GD.Print("recebido", message.Payload);
    }
    private void onOpenCallback()
    {
        GD.Print("entrando");
    }

    //  // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(float delta)
    {
        if (Input.IsActionJustPressed("ui_right"))
        {

            channel.Push("move", new {body = 10});
        }
    }

}
