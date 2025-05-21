
module server;
import std::collections;
import std::io;
import std::net;
import std::thread;
import common;


const String VERSION = "";
const uint PORT = 8080;

Connection c;

fn void listen() {
	//c.server = tcp::listen("10.0.0.208", PORT, 10)!!;
	//c.server = tcp::listen("68.36.13.101", PORT, 10)!!;
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
			case VERSION:
				io::printfn("recieved VERSION %s", packet.data);
				c.socket.write((char[])"1.0.0")!!;
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
