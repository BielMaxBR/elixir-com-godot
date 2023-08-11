using Godot;
using System;
using System.Threading;
using System.Threading.Tasks;
using Phoenix;
using Newtonsoft.Json.Linq;

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

        channel.OnError(message =>
        {
            GD.Print(message.Payload.Unbox<JObject>());
        });
        channel.OnClose(message =>
        {
            GD.Print(message.Payload.Unbox<JObject>());
        });

        channel.On("init", body =>
        {
            InitData data = body.Payload.Unbox<InitData>();
            foreach (Player playerData in data.Online_players)
            {
                if (playerData.id == data.YourId) playerData.is_local = true;
                SpawnPlayer(playerData);
            }
        });

        channel.On("joined", body =>
        {
            Player playerData = body.Payload.Unbox<Player>();
            SpawnPlayer(playerData);
        });

        channel.On("move", body =>
        {
            Player playerData = body.Payload.Unbox<Player>();
            MovePlayer(playerData);
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
        // mensagens globais, não específico de canal
        // GD.Print("recebido ", message.Event, " ", message.Payload.Unbox<JObject>());
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

            channel.Push("move", new
            {
                body = new { x = 1, y = 1 }
            });
        }
    }

    private void SpawnPlayer(Player playerData)
    {
        var player = ResourceLoader.Load<PackedScene>("res://entities/player.tscn").Instance<Player>();

        player.Position = playerData.Position;
        player.id = playerData.id;
        player.is_local = playerData.is_local;

        AddChild(player);
    }
    internal void SendPosition(Vector2 position)
    {
        channel.Push("move", new
        {
            position = new { position.x, position.y }
        });
    }

    private void MovePlayer(Player playerData)
    {
        Player player = GetNode<Player>("player-" + playerData.id);
        player.Position = playerData.Position;

    }

    private class InitData
    {
        public string YourId { get; set; }
        public Player[] Online_players { get; set; }
    }
}
