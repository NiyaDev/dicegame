
module game;
import std::io;
import std::net;
import common;
import pleroma;


Keybindings keybinds;

fn int main(String[] args) {
	raylib::init_window(1280,720,"test");

	// Keybinds
	keybinds.set("test1", {.type=KEYBOARD,.kb=raylib::KEY_W});


	while (!raylib::window_should_close()) {
		if (keybinds.is_pressed("test1")) {
			TcpSocket socket = tcp::connect("10.0.0.208", 8080)!!;

			Packet p = packet::new(PING)!!;
			char[] data = p.as_data();
			socket.write(data)!!;
			io::printn("Sent PING");
			free(data);
			
			Packet v = packet::new(VERSION)!!;
			data = v.as_data();
			socket.write(data)!!;
			io::printn("Sent VERSION");
			free(data);

			data = mem::new_array(char, 20);
			socket.read(data)!!;
			io::printfn("Recieved [%s]", (String)data);
			free(data);

			Packet u = packet::new(USERNAME)!!;
			u.data = mem::new_array(char, 19);
			mem::copy(u.data, "USERNAME", 8);
			data = u.as_data();
			socket.write(data)!!;
			io::printn("Sent USERNAME");
			free(data);

			Packet q = packet::new(QUIT)!!;
			data = q.as_data();
			socket.write(data)!!;
			io::printn("Sent QUIT");
			free(data);

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

