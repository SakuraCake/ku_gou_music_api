const { createRequest } = require('./ku_gou_music_api/util/request');
const { appid, clientver } = require('./ku_gou_music_api/util/config.json');

async function main() {
  const hash = '782ff57baf4a09f3a5dc285696e9d7b3';  // 最炫小苹果
  const mid = '334689572176563962868706300678062568191';
  const dfid = '-';
  const token = '628979c10e7d4edfe716fcd16b2b28ea73e81dd3c8a4ff07a9af8bbbbafed228';
  const userid = '1882890175';
  
  const resource = [{ type: 'audio', page_id: 0, hash: hash, album_id: 0 }];
  
  try {
    const result = await createRequest({
      method: 'POST',
      baseURL: 'https://gateway.kugou.com',
      url: '/v2/get_res_privilege/lite',
      data: {
        appid,
        area_code: 1,
        behavior: 'play',
        clientver,
        need_hash_offset: 1,
        relate: 1,
        support_verify: 1,
        resource,
        qualities: ['128', '320', 'flac', 'high', 'viper_atmos', 'viper_tape', 'viper_clear', 'super', 'multitrack'],
      },
      encryptType: 'android',
      headers: { 'x-router': 'media.store.kugou.com', 'Content-Type': 'application/json' },
      cookie: { dfid, mid, token, userid, KUGOU_API_MID: mid },
    });
    
    console.log('Success!');
    console.log(JSON.stringify(result.body, null, 2));
  } catch (e) {
    console.log('Error:', e);
    console.log('Body:', JSON.stringify(e.body, null, 2));
  }
}

main();
