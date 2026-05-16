const { createRequest } = require('./ku_gou_music_api/util/request');
const { appid, clientver } = require('./ku_gou_music_api/util/config.json');
const crypto = require('crypto');

function cryptoMd5(input) {
  return crypto.createHash('md5').update(input).digest('hex');
}

function signParamsKey(clienttime) {
  const salt = 'NVPh5oo715z5DIWAeQlhMDsWXXQV4hwt';
  return cryptoMd5(`${appid}${salt}${clienttime}${clientver}`);
}

async function main() {
  const hash = '782ff57baf4a09f3a5dc285696e9d7b3';  // 最炫小苹果
  const mid = '334689572176563962868706300678062568191';
  const dfid = '-';
  const token = '628979c10e7d4edfe716fcd16b2b28ea73e81dd3c8a4ff07a9af8bbbbafed228';
  const userid = '1882890175';
  const clienttime = Date.now();
  
  const dataMap = {
    appid,
    clienttime,
    clientver,
    data: [{ hash: hash, audio_id: 0 }],
    dfid,
    key: signParamsKey(clienttime),
    mid,
    token,
    userid,
  };
  
  console.log('Request data:');
  console.log(JSON.stringify(dataMap, null, 2));
  
  try {
    const result = await createRequest({
      method: 'POST',
      baseURL: 'http://kmr.service.kugou.com',
      url: '/v1/audio/audio',
      data: dataMap,
      encryptType: 'android',
      headers: { 'x-router': 'kmr.service.kugou.com', 'Content-Type': 'application/json' },
      cookie: { dfid, mid, token, userid, KUGOU_API_MID: mid },
    });
    
    console.log('\nSuccess!');
    console.log(JSON.stringify(result.body, null, 2));
  } catch (e) {
    console.log('\nError:', e);
    console.log('Body:', JSON.stringify(e.body, null, 2));
  }
}

main();
