
module server;
import std::collections;
import std::io;
import std::net;
import std::thread;
import common;


const String GAME_VERSION = "0.1.0";
const uint PORT = 8080;

Connection c;

fn void listen() {
	c.server = tcp::listen("10.0.0.208", PORT, 10)!!;
	c.socket = tcp::accept(&c.server)!!;
}

fn int main() {
	listen();

	while (true) {
		Packet? packet = c.read();
		if (catch packet) continue;
		
		switch (packet.type) {
			case PING:
				io::printfn("Recieved PING");
				//Packet ping = packet::new(PING);
			case VERSION:
				io::printfn("Recieved VERSION request\nSent Version [%s]", GAME_VERSION);
				c.socket.send_packet(VERSION, (char[])GAME_VERSION);
				//c.socket.write((char[])GAME_VERSION)!!;
			case USERNAME:
				io::printfn("Recieved USERNAME [%s]", (String)packet.data);
			case QUIT:
				io::printfn("Recieved QUIT");
				c.close();
				listen();
				continue;
			default:
		}
	}
	//return 0;
}
