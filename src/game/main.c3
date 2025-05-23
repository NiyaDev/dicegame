
module game;
import std::io;
import std::net;
import common;
import pleroma;


const String GAME_VERSION = "0.1.0";

Keybindings keybinds;

fn int main(String[] args) {
	raylib::init_window(1280,720,"test");
	raylib::set_target_fps(60);

	// Keybinds
	keybinds.set("test1", {.type=KEYBOARD,.kb=raylib::KEY_W});


	while (!raylib::window_should_close()) {
		if (keybinds.is_pressed("test1")) {
			TcpSocket socket = tcp::connect(common::IP_ADDRESS, common::PORT)!!;

			socket.send_packet(PING);
			socket.send_packet(VERSION);
			Packet p = socket.get_packet();
			assert(p.data.as_string() == GAME_VERSION, "Failed to recieve correct version number [%s]", (String)p.data);
			socket.send_packet(QUIT);
			

			socket.close()!!;
		}

		raylib::begin_drawing();
		raylib::clear_background(color::GRAY);

		raylib::end_drawing();
	}

	//

	//Packet packet = {PING,{}};
	
	//char[] data = packet.as_data();
	//socket.write(data)!!;
	//free(data);

	
	//Packet quit_packet = {QUIT,{}};

	//data = quit_packet.as_data();
	//socket.write(data)!!;
	//free(data);

	//socket.close()!!;

	//socket.write("fugandulu\0")!!;
	//socket.write("quit\0\0\0\0\0\0")!!;

	return 0;
}

