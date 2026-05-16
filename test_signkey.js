const crypto = require('crypto');

function cryptoMd5(input) {
  return crypto.createHash('md5').update(input).digest('hex');
}

const signKey = (hash, mid, userid, appid) => {
  const str = '57ae12eb6890223e355ccfcb74edf70d';  // standard
  return cryptoMd5(`${hash}${str}${appid || 1005}${mid}${userid || 0}`);
};

const hash = '1335f720c701863f127fb14ccc9c08a2';
const mid = '334689572176563962868706300678062568191';
const userid = 1882890175;
const appid = 1005;

const key = signKey(hash, mid, userid, appid);
console.log('Node.js key:', key);

// 手动计算
const manualKey = cryptoMd5(`${hash}57ae12eb6890223e355ccfcb74edf70d${appid}${mid}${userid}`);
console.log('Manual key:', manualKey);
