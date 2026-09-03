require('../server/utils/MongooseUtil');
const { Admin } = require('../server/models/Models');

async function updateAdmin() {
  try {
    const result = await Admin.updateOne({ username: 'admin' }, { $set: { password: 'admin' } });
    console.log('Updated admin password to "admin":', result);
    process.exit(0);
  } catch (err) {
    console.error('Error updating admin:', err);
    process.exit(1);
  }
}

updateAdmin();
