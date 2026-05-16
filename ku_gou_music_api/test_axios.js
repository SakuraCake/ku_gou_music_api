const crypto = require('crypto');
const axios = require('axios');

function cryptoMd5(input) {
  return crypto.createHash('md5').update(input).digest('hex');
}

function signatureAndroidParams(params, data) {
  const str = 'OIlwieks28dk2k092lksi2UIkp';
  const paramsString = Object.keys(params)
    .sort()
    .map((key) => `${key}=${typeof params[key] === 'object' ? JSON.stringify(params[key]) : params[key]}`)
    .join('');
  return cryptoMd5(`${str}${paramsString}${data || ''}${str}`);
}

async function main() {
  const clienttime = Math.floor(Date.now() / 1000);
  const mid = '334689572176563962868706300678062568191';

  const params = {
    albumhide: 0,
    iscorrection: 1,
    keyword: '周杰伦',
    nocollect: 0,
    page: 1,
    pagesize: 3,
    platform: 'AndroidFilter',
    dfid: '-',
    mid: mid,
    uuid: '-',
    appid: 1005,
    clientver: 20489,
    clienttime: clienttime,
  };

  const signature = signatureAndroidParams(params, '');
  params.signature = signature;

  console.log('=== 请求参数 ===');
  console.log(JSON.stringify(params, null, 2));

  const headers = {
    'User-Agent': 'Android15-1070-11083-46-0-DiscoveryDRADProtocol-wifi',
    'dfid': '-',
    'clienttime': clienttime.toString(),
    'mid': mid,
    'kg-rc': '1',
    'kg-thash': '5d816a0',
    'kg-rec': '1',
    'kg-rf': 'B9EDA08A64250DEFFBCADDEE00F8F25F',
    'x-router': 'complexsearch.kugou.com',
  };

  console.log('\n=== 请求头 ===');
  console.log(JSON.stringify(headers, null, 2));

  try {
    const response = await axios({
      method: 'GET',
      baseURL: 'https://gateway.kugou.com',
      url: '/v3/search/song',
      params: params,
      headers: headers,
    });

    console.log('\n=== 响应 ===');
    console.log('status:', response.data.status);
    console.log('error_code:', response.data.error_code);
    console.log('error_msg:', response.data.error_msg);
    if (response.data.data) {
      console.log('data.total:', response.data.data.total);
      if (response.data.data.lists && response.data.data.lists.length > 0) {
        console.log('First song:', response.data.data.lists[0].songname);
      }
    }
  } catch (error) {
    console.log('Error:', error.message);
    if (error.response) {
      console.log('Response status:', error.response.status);
      console.log('Response data:', error.response.data);
    }
  }
}

main();
