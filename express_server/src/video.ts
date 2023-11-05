// const io = new Server(server);

// // Store active live streams and connected viewers
// const liveStreams = new Map<
// 	string,
// 	{ username: string; stream_name: string; viewers: Set<string> }
// >();

// // Middleware for JSON parsing
// app.use(express.json());

// app.get("/ping", (req: Request, res: Response) => {
// 	return res.send("pong");
// });

// // User authentication endpoint
// app.post("/login", (req: Request, res: Response) => {
// 	// Authenticate user credentials
// 	const { username, password } = req.body;
// 	// Implement your authentication logic here

// 	// Return authentication result
// 	const isAuthenticated = true; // Replace with actual authentication check
// 	if (isAuthenticated) {
// 		res.json({ message: "Authentication successful" });
// 	} else {
// 		res.status(401).json({ message: "Authentication failed" });
// 	}
// });

// // Create live stream endpoint
// app.post("/livestream", (req: Request, res: Response) => {
// 	// Authenticate user and create live stream
// 	const { username, streamName: stream_name } = req.body;
// 	// Implement your authentication and live stream creation logic here

// 	// Store live stream details
// 	const stream = {
// 		username,
// 		stream_name: stream_name,
// 		viewers: new Set<string>(),
// 	};
// 	liveStreams.set(stream_name, stream);

// 	res.json({ message: "Live stream created successfully" });
// });

// // Socket.IO connection event
// io.on("connection", (socket: Socket) => {
// 	log("🤝 user connected");

// 	// Join live stream
// 	socket.on("join_stream", (stream_name: string) => {
// 		// Retrieve live stream details
// 		const stream = liveStreams.get(stream_name);

// 		// Add viewer to the stream
// 		if (stream) {
// 			stream.viewers.add(socket.id);
// 			socket.join(stream_name);
// 			log("😄 user joined stream");
// 			// io.to(stream_name).emit('viewerCount', stream.viewers.size);
// 		}
// 	});

// 	// Leave live stream
// 	socket.on("leave_stream", (stream_name: string) => {
// 		// Retrieve live stream details
// 		const stream = liveStreams.get(stream_name);

// 		// Remove viewer from the stream
// 		if (stream) {
// 			stream.viewers.delete(socket.id);
// 			socket.leave(stream_name);
// 			log("🤒 user joined stream");
// 			// io.to(stream_name).emit("viewerCount", stream.viewers.size);
// 		}
// 	});

// 	socket.on("chat_message", (message: string) => {
// 		console.log(`💬 received chat message: ${message}`);
// 		// Broadcast the chat message to all connected clients
// 		io.emit("chat_message", message);
// 	});

// 	socket.on("disconnect", () => {
// 		console.log("💔 user disconnected");
// 	});
// });

// // Set up WebSocket broadcast function
// function broadcast(stream_name: string, data: any) {
// 	io.to(stream_name).emit("stream_data", data);
// }

// // Configure the media server
// const config = {
// 	// rtmp: {
// 	// 	port: 4001,
// 	// 	chunk_size: 60000,
// 	// 	gop_cache: true,
// 	// 	ping: 30,
// 	// 	ping_timeout: 60,
// 	// },
// 	server: {
// 		secret: process.env.MEDIA_SERVER_SECRET,
// 	},
// 	rtmp: {
// 		port: 4002,
// 		chunk_size: 60000,
// 		gop_cache: true,
// 		ping: 60,
// 		ping_timeout: 30,
// 	},
// 	http: {
// 		port: 4001,
// 		mediaroot: "./videos",
// 		allow_origin: "*",
// 	},
// 	trans: {
// 		ffmpeg: "/opt/homebrew/bin/ffmpeg",
// 		tasks: [
// 			{
// 				app: "live",
// 				hls: true,
// 				hlsFlags:
// 					"[hls_time=2:hls_list_size=3:hls_flags=delete_segments]",
// 				dash: true,
// 				dashFlags: "[f=dash:window_size=3:extra_window_size=5]",
// 			},
// 		],
// 	},
// };

// // Create an instance of the NodeMediaServer
// const media_server = new NodeMediaServer(config);

// // Set up event handlers for the media server
// media_server.on("prePublish", (id: string, stream_path: string, args: any) => {
// 	// Handle pre-publish event
// 	// You can validate stream keys, authenticate users, or perform any necessary operations before allowing the stream to start
// 	// Broadcast the stream data to connected viewers
// 	const streamName = stream_path.split("/")[2];
// 	const streamData = { id, streamPath: stream_path, args }; // Customize the data as per your needs
// 	broadcast(streamName, streamData);
// });

// media_server.on("postPublish", (id: string, stream_path: string, args: any) => {
// 	// Handle post-publish event
// 	// Perform any additional operations after the stream has started
// });

// media_server.on("donePublish", (id: string, stream_path: string, args: any) => {
// 	// Handle done-publish event
// 	// Perform any necessary cleanup or logging after the stream has ended
// });

// // Start the media server
// media_server.run();
