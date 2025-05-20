
module common;


struct Packet {
  PacketType type;
  char[] data;
}

enum PacketType : char {
  PING,
  MULTIPACKET_HEADER,
  QUIT,
}

<* Converts packet to char array to be sent over socket *>
fn char[] Packet.as_data(&self) {
  char[] dat = mem::new_array(char, 20);
  dat[0] = self.type.ordinal;
  if (self.data.len == 19) mem::copy(&dat[1], self.data, 19);

  return dat;
}

