const crypto = require('crypto');
const { createRequest } = require('./ku_gou_music_api/util/request');
const { appid, clientver } = require('./ku_gou_music_api/util/config.json');

function cryptoMd5(input) {
  return crypto.createHash('md5').update(input).digest('hex');
}

async function main() {
  const hash = '1335F720C701863F127FB14CCC9C08A2';
  const token = '628979c10e7d4edfe716fcd16b2b28ea73e81dd3c8a4ff07a9af8bbbbafed228';
  const userid = '1882890175';
  const mid = '334689572176563962868706300678062568191';
  const dfid = '-';
  
  const clienttimeMs = Date.now();
  
  const trackerKey = cryptoMd5(`${hash}185672dd44712f60bb1736df5a377e82${appid}${mid}${userid}`);
  console.log('tracker_key:', trackerKey);
  
  const body = {
    appid: appid,  // 1005
    clientver: clientver,
    area_code: '1',
    behavior: 'play',
    qualities: ['128', '320', 'flac', 'high', 'super'],
    resource: {
      album_audio_id: 0,
      collect_list_id: '3',
      collect_time: clienttimeMs,
      hash: hash.toLowerCase(),
      id: 0,
      page_id: 1,
      type: 'audio',
    },
    token: token,
    dfid: dfid,
    mid: mid,
    tracker_param: {
      all_m: 1,
      auth: '',
      is_free_part: 0,
      key: trackerKey,
      module_id: 0,
      need_climax: 1,
      need_xcdn: 1,
      open_time: '',
      pid: '411',
      pidversion: '3001',
      priv_vip_type: '6',
      viptoken: '',
    },
    userid: userid,
    vip: 0,
  };
  
  console.log('Request body:');
  console.log(JSON.stringify(body, null, 2));
  
  try {
    const result = await createRequest({
      method: 'POST',
      baseURL: 'http://tracker.kugou.com',
      url: '/v6/priv_url',
      data: body,
      clearDefaultParams: true,
      notSignature: true,
      cookie: { dfid, token, userid, KUGOU_API_MID: mid },
    });
    
    console.log('\nSuccess!');
    console.log(JSON.stringify(result, null, 2));
  } catch (e) {
    console.log('\nError:', e);
    console.log(JSON.stringify(e.body, null, 2));
  }
}

main();
