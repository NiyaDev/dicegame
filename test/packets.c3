

import common;

fn void creation() @test {
  Packet zero_p = packet::new(PING);
  Packet sixteen_max_p = packet::new(USERNAME, {'t','e','s','t'});

  char[] zero_data = zero_p.as_data();
  assert(zero_data.len == 2, "Length of PING incorrect");
  assert(zero_data[0] == PacketType.PING.ordinal, "Type of PING incorrect");
  assert(zero_data[1] == 0, "Length of PING data incorrect");

  char[] sixteen_max_data = sixteen_max_p.as_data();
  assert(sixteen_max_data.len == 6, "Length of USERNAME incorrect");
  assert(sixteen_max_data[0] == PacketType.USERNAME.ordinal, "Type of USERNAME incorrect");
  assert(sixteen_max_data[1] == 4, "Length of USERNAME data incorrect");
  assert(sixteen_max_data[2:4] == {'t','e','s','t'}, "Data of USERNAME incorrect");
}

