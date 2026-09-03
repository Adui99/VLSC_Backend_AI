require('../server/utils/MongooseUtil');
const { Admin } = require('../server/models/Models');

async function checkAdmin() {
  try {
    const admins = await Admin.find({});
    console.log('--- ADMIN ACCOUNTS ---');
    console.log(JSON.stringify(admins, null, 2));
    process.exit(0);
  } catch (err) {
    console.error('Error fetching admins:', err);
    process.exit(1);
  }
}

checkAdmin();
