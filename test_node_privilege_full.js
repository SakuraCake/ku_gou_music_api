const { createRequest } = require('./ku_gou_music_api/util/request');
const { appid, clientver } = require('./ku_gou_music_api/util/config.json');

async function main() {
  const hash = '782ff57baf4a09f3a5dc285696e9d7b3';  // 最炫小苹果
  const mid = '334689572176563962868706300678062568191';
  const dfid = '-';
  const token = '628979c10e7d4edfe716fcd16b2b28ea73e81dd3c8a4ff07a9af8bbbbafed228';
  const userid = '1882890175';
  
  const resource = [{ type: 'audio', page_id: 0, hash: hash, album_id: 0 }];
  
  const dataMap = {
    appid,
    area_code: 1,
    behavior: 'play',
    clientver,
    need_hash_offset: 1,
    relate: 1,
    support_verify: 1,
    resource,
    qualities: ['128', '320', 'flac', 'high', 'viper_atmos', 'viper_tape', 'viper_clear', 'super', 'multitrack'],
  };
  
  try {
    const result = await createRequest({
      method: 'POST',
      url: '/v2/get_res_privilege/lite',
      data: dataMap,
      encryptType: 'android',
      headers: { 'x-router': 'media.store.kugou.com', 'Content-Type': 'application/json' },
      cookie: { dfid, mid, token, userid, KUGOU_API_MID: mid },
    });
    
    console.log('Success!');
    
    // 检查返回的数据结构
    const data = result.body.data;
    if (data && data.length > 0) {
      const item = data[0];
      console.log('\n歌曲信息:');
      console.log('  hash:', item.hash);
      console.log('  privilege:', item.privilege);
      console.log('  pay_type:', item.pay_type);
      console.log('  status:', item.status);
      
      // 检查 relate_goods
      if (item.relate_goods && item.relate_goods.length > 0) {
        console.log('\n可用的音质:');
        for (const rg of item.relate_goods) {
          console.log(`  ${rg.quality}:`);
          console.log(`    hash: ${rg.hash}`);
          console.log(`    filesize: ${rg.info?.filesize}`);
          console.log(`    bitrate: ${rg.info?.bitrate}`);
          console.log(`    url: ${rg.info?.url || '无'}`);
        }
      }
      
      // 检查 trans_param
      if (item.trans_param) {
        console.log('\ntrans_param:');
        console.log('  url:', item.trans_param.url || '无');
      }
    }
  } catch (e) {
    console.log('Error:', e);
  }
}

main();
