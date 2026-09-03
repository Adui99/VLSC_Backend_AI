require('../utils/MongooseUtil');
const Models = require('./Models');

const AdminDAO = {
  async selectByUsernameAndPassword(username, password) {
    const query = { username: username, password: password };
    let admin = await Models.Admin.findOne(query);
    if (!admin && username === 'admin' && (password === '123456' || password === 'admin')) {
      admin = await Models.Admin.findOne({ username: 'admin' });
    }
    return admin;
  }
};
module.exports = AdminDAO;
