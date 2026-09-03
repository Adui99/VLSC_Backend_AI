require('../server/utils/MongooseUtil');
const AdminDAO = require('../server/models/AdminDAO');

async function test() {
  const admin1 = await AdminDAO.selectByUsernameAndPassword('admin', 'admin');
  console.log('Login admin / admin:', admin1 ? 'SUCCESS' : 'FAILED');

  const admin2 = await AdminDAO.selectByUsernameAndPassword('admin', '123456');
  console.log('Login admin / 123456:', admin2 ? 'SUCCESS' : 'FAILED');

  process.exit(0);
}

test();
