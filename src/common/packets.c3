
module common;



struct Packet {
  PacketType type;
  char[] data;
}

enum PacketType : char {
  EMPTY,

  PING,

  VERSION_REQ,
  VERSION_SRV,

  USERNAME,
  PASSWORD,
  LOGIN,

  CONFIRM,
  DENY,

  QUIT,
}

<* Converts packet to char array to be sent over socket *>
fn char[] Packet.as_data(&self) {
  char[] dat = mem::temp_array(char, self.data.len + 2);
  dat[0] = self.type.ordinal;
  dat[1] = (char)self.data.len;
  if (self.data.len > 0) mem::copy(&dat[2], self.data, self.data.len);

  return dat;
}



module common::packet;
import std::io;
import std::net;

<* Send a packet to server *>
fn void Socket.send_packet(&self, PacketType type, char[] data = {}) {
  Packet p = new(type, data);
  self.write(p.as_data())!!;

  switch (type) {
    case PING:     io::printfn("Sent PING");

    case VERSION_REQ: io::printfn("Requested VERSION");
    case VERSION_SRV: io::printfn("Sent VERSION");

    case USERNAME: io::printfn("Sent USERNAME [%s]", (String)data);
    case PASSWORD: io::printfn("Sent PASSWORD [%s]", (String)data);
    case LOGIN:    io::printfn("Sent Login request");

    case CONFIRM:  io::printfn("Sent CONFIRM");
    case DENY:     io::printfn("Sent DENY");

    case QUIT:     io::printfn("Sent QUIT");

    default:
  }
}
<* Recieve packet from server *>
fn Packet Socket.get_packet(&self) {
  char[] header = mem::temp_array(char, 2);
  char[] data;
  self.read(header)!!;

  if (header[1] > 0) {
    data = mem::temp_array(char, header[1]);
    self.read(data)!!;
  }

  Packet output;
  output.type = PacketType.from_ordinal(header[0]);
  
  switch (output.type) {
    case PING:
      io::printfn("Recieved PING");

    case VERSION_REQ:
      io::printfn("Recieved VERSION_REQUEST");
    case VERSION_SRV:
      output.data = data;
      io::printfn("Recieved VERSION [%s]", (String)data);

    case USERNAME:
      output.data = mem::temp_array(char, header[1]);
      mem::copy(output.data, data, header[1]);
      io::printfn("Recieved USERNAME [%s]-[%d]", (String)output.data,header[1]);
    case PASSWORD:
      output.data = mem::temp_array(char, header[1]);
      mem::copy(output.data, data, header[1]);
      io::printfn("Recieved PASSWORD [%s]", (String)output.data);
case LOGIN:
      io::printfn("Recieved LOGIN");

    case CONFIRM:
      io::printfn("Recieved CONFIRM");
    case DENY:
      io::printfn("Recieved DENY");

    case QUIT:
      io::printfn("Severed connection");

    default:
  }

  return output;
}
<* Create new packet *>
fn Packet new(PacketType type, char[] data = {}) {
  Packet output;
  output.type = type;
  output.data = data;

  return output;
}

<**>
fn String String.cut_trailing(&self) {
  int count;
  for (int i; i < self.len; i++) {
    if (((char[])*self)[i] != '\0') count++;
  }
  char[] new = mem::temp_array(char, count);
  mem::copy(&new, self, count);
  return (String)new;
}

