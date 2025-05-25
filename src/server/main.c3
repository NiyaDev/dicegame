
module server;
import std::collections;
import std::io;
import std::net;
import std::thread;
import common;


const String GAME_VERSION = "0.1.0";

Connection c;

fn void listen() {
	c.server = tcp::listen(common::IP_ADDRESS, common::PORT, 10)!!;
	c.socket = tcp::accept(&c.server)!!;
}

fn int main() {
	login::load_users();
	listen();

	while (true) {
		Packet packet = c.socket.get_packet();

		switch (packet.type) {
			case VERSION_REQ:
				c.socket.send_packet(VERSION_SRV, (char[])GAME_VERSION);

			case USERNAME:
				c.username = ((String)packet.data).copy(allocator::heap());
			case PASSWORD:
				c.password = ((String)packet.data).copy(allocator::heap());
			case LOGIN:
				bool? res = login::users.contains(c.username, c.password);
				if (try res && res) {
					c.socket.send_packet(CONFIRM);
				} else { c.socket.send_packet(DENY); } 

			case QUIT:
				c.close();
				login::users.save();
				listen();
				login::load_users();
				continue;
			default:
		}
	}

	//return 0;
}



