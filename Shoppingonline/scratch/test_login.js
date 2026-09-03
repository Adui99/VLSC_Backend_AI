require('../server/utils/MongooseUtil');
const AdminDAO = require('../server/models/AdminDAO');

async function test() {
  const admin1 = await AdminDAO.selectByUsernameAndPassword('admin', 'admin');
  console.log('Test with username="admin", password="admin":', admin1 ? 'SUCCESS' : 'FAILED');

  const admin2 = await AdminDAO.selectByUsernameAndPassword('admin', 'pbkdf2$120000$ddd103c4f427e58f33392b801e0843e3$218866e2a9d10c2633690196d3a4d4176d82f0d41abc3e237a483afb382329f937baefe50cd2fb0b865fa52b940a23e2700ff30d931f4816671fe914f56aac77');
  console.log('Test with username="admin", password="pbkdf2...":', admin2 ? 'SUCCESS' : 'FAILED');
  process.exit(0);
}

test();
