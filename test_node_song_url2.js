const { createRequest } = require('./ku_gou_music_api/util/request');

async function main() {
  const hash = '782ff57baf4a09f3a5dc285696e9d7b3';  // 最炫小苹果
  const mid = '334689572176563962868706300678062568191';
  const dfid = '-';
  const token = '628979c10e7d4edfe716fcd16b2b28ea73e81dd3c8a4ff07a9af8bbbbafed228';
  const userid = '1882890175';
  
  try {
    const result = await createRequest({
      method: 'GET',
      baseURL: 'http://trackercdn.kugou.com',
      url: '/v5/url',
      params: {
        hash: hash,
        album_id: 0,
        album_audio_id: 0,
        quality: 128,
        area_code: 1,
        ssa_flag: 'is_fromtrack',
        version: 11430,
        page_id: 151369488,
        behavior: 'play',
        pid: 2,
        cmd: 26,
        pidversion: 3001,
        IsFreePart: 0,
        ppage_id: '463467626,350369493,788954147',
        cdnBackup: 1,
        module: '',
        clientver: 11430,
      },
      encryptType: 'android',
      encryptKey: true,
      notSignature: true,
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
