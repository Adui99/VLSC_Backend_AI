//CLI: npm install mongoose --save
const mongoose = require('mongoose');
const MyConstants = require('./MyConstants');
const uri = 'mongodb://' + MyConstants.DB_USER + ':' + encodeURIComponent(MyConstants.DB_PASS) + '@ac-sezvwza-shard-00-00.bjtzrj2.mongodb.net:27017,ac-sezvwza-shard-00-01.bjtzrj2.mongodb.net:27017,ac-sezvwza-shard-00-02.bjtzrj2.mongodb.net:27017/' + MyConstants.DB_DATABASE + '?ssl=true&replicaSet=atlas-ghedob-shard-0&authSource=admin&retryWrites=true&w=majority';
mongoose.connect(uri)
  .then(() => { console.log('Connected to ' + MyConstants.DB_SERVER + '/' + MyConstants.DB_DATABASE); })
  .catch((err) => { console.error(err); });
