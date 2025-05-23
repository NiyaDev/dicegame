

import server::login;


fn void saving_loading() @test {
  char[] test_value = {
    't','e','s','t','u','s','e','r','n','a','m','e','\0','\0','\0','\0',
    't','e','s','t','p','a','s','s','w','o','r','d','\0','\0','\0','\0',
    0,0,0,0,
    10,0,0,0,
  };

  User u = test_value.to_user();
  assert(u.username == "testusername", "Failed to parse username [%s] != [%s]", u.username, "testusername");
  assert(u.password == "testpassword", "Failed to parse password [%s] != [%s]", u.password, "testpassword");
  assert(u.elo      == 0,              "Failed to parse elo [%d] != [%d]", u.elo, 0);
  assert(u.currency == 10,             "Failed to parse currency [%d] != [%d]", u.currency, 10);

  char[] saved_user = u.to_array();

  assert(test_value == saved_user, "Failed to properly save User\n%s\n%s",test_value,saved_user);
}

