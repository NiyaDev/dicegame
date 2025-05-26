
module game;
import std::io;
import std::net;
import common;
import pleroma;


const String GAME_VERSION = "0.1.0";
const String USERNAME = "Username";
const String PASSWORD = "Password";
const String CONFIRM = "Login";

Keybindings keybinds;
String username, password;
bool username_edit, password_edit;

fn int main(String[] args) {
	raylib::init_window(1280,720,"test");
	raylib::set_target_fps(60);

	// Keybinds
	keybinds.set("test1", {.type=KEYBOARD,.kb=raylib::KEY_W});

	// 
	username = (String)mem::new_array(char, 16);
	password = (String)mem::new_array(char, 16);

	// Get server version
	TcpSocket socket = tcp::connect(common::IP_ADDRESS, common::PORT)!!;
	socket.send_packet(VERSION_REQ);
	Packet version = socket.get_packet();
	assert(version.data.as_string() == GAME_VERSION, "Failed to recieve correct version number [%s]", (String)version.data);
	socket.send_packet(QUIT);
	socket.close()!!;


	while (!raylib::window_should_close()) {
		if (keybinds.is_pressed("test1")) {
			/*
			socket = tcp::connect(common::IP_ADDRESS, common::PORT)!!;

			//socket.send_packet(PING);
			socket.send_packet(USERNAME, {'t','e','s','t'});
			socket.send_packet(PASSWORD, {'b','e','s','t'});
			socket.send_packet(LOGIN);
			socket.send_packet(QUIT);
			

			socket.close()!!;
			*/
		}

		raylib::begin_drawing();
		raylib::clear_background(color::DARKGRAY);
		if (raygui::text_box({50, 50,150,40},&((char[])username)[0],16,username_edit)) username_edit = !username_edit;
		if (raygui::text_box({50,100,150,40},&((char[])password)[0],16,password_edit)) password_edit = !password_edit;
		if (raygui::button({50,150,100,40},"Login")) {
			socket = tcp::connect(common::IP_ADDRESS, common::PORT)!!;

			socket.send_packet(USERNAME, (char[])(username.cut_trailing()));
			socket.send_packet(PASSWORD, (char[])(password.cut_trailing()));
			socket.send_packet(LOGIN);

			Packet cod = socket.get_packet();
			if (cod.type == CONFIRM) {
				io::printn("LOGGED IN!!!");
			} else if (cod.type == DENY) {
				io::printn("LOGIN FAILED!!");
			}

			socket.send_packet(QUIT);
			socket.close()!!;
		}

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

