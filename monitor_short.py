import requests
import json
import time
import hmac
import hashlib
import base64
import urllib.parse
import logging  # 导入日志模块


# 设置日志记录, 包含时间
log_file_path = "/home/w/work/command_line/etf_monitor.log"  # 日志文件路径
logging.basicConfig(
    filename=log_file_path,
    level=logging.INFO,  # 设置日志级别为 INFO
    format='%(asctime)s - %(levelname)s - %(message)s',  # 日志格式, 包含时间
    datefmt='%Y-%m-%d %H:%M:%S'  # 日期时间格式
)

def generate_dingtalk_signature(secret):
    """
    生成钉钉机器人签名。
    """
    timestamp = str(round(time.time() * 1000))
    secret_enc = secret.encode('utf-8')
    string_to_sign = '{}\n{}'.format(timestamp, secret)
    string_to_sign_enc = string_to_sign.encode('utf-8')
    hmac_code = hmac.new(secret_enc, string_to_sign_enc, digestmod=hashlib.sha256).digest()
    sign = urllib.parse.quote_plus(base64.b64encode(hmac_code))
    return timestamp, sign

def send_dingtalk_message(webhook, message):
    """
    发送钉钉消息，包含时间戳和签名。
    """
    # timestamp, sign = generate_dingtalk_signature(secret)
    # full_webhook = f"{webhook}×tamp={timestamp}&sign={sign}"

    full_webhook = webhook
    headers = {'Content-Type': 'application/json;charset=utf-8'}
    data = {
        "msgtype": "text",
        "text": {
            "content": message
        },
        "at": {
            "isAtAll": False  # 可以设置为 True 来 @所有人
        }
    }
    try:
        response = requests.post(full_webhook, headers=headers, data=json.dumps(data), timeout=10)
        response.raise_for_status()  # Raise HTTPError for bad responses (4xx or 5xx)
        result = response.json()
        if result.get('errcode') != 0:
            logging.error(f"钉钉消息发送失败: {result.get('errmsg')}") # 使用logging记录
            return False
        return True
    except requests.exceptions.RequestException as e:
        logging.error(f"钉钉消息发送失败: {e}") # 使用logging记录
        return False
    except Exception as e:
        logging.error(f"钉钉消息发送发生其他错误：{e}")  # 使用logging记录
        return False

def get_etf_data(page=1, page_size=100):
    """
    获取ETF数据，使用新的API接口。
    """
    url = "https://datacenter.eastmoney.com/stock/fundselector/api/data/get"

    params = {
        'type': 'RPTA_APP_FUNDSELECT',
        'sty': 'SECUCODE,SECURITY_CODE,SECURITY_INNER_CODE,CHANGE_RATE_1W,CHANGE_RATE_1M,CHANGE_RATE_3M,YTD_CHANGE_RATE,DEC_TOTALSHARE,DEC_NAV,SECURITY_NAME_ABBR,DERIVE_INDEX_CODE,INDEX_CODE,INDEX_NAME,NEW_PRICE,CHANGE_RATE,CHANGE,VOLUME,DEAL_AMOUNT,PREMIUM_DISCOUNT_RATIO,QUANTITY_RELATIVE_RATIO,HIGH_PRICE,LOW_PRICE',
        'extraCols': '',
        'source': 'FUND_SELECTOR',
        'client': 'APP',
        'filter': '(ETF_TYPE_CODE="ALL")(IS_TPLUS="1")',
        'p': page,
        'ps': page_size,
        'st': 'CHANGE_RATE,SECURITY_CODE',
        'sr': '-1,1'
    }

    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Referer': 'https://datacenter.eastmoney.com/'
    }

    try:
        r = requests.get(url, params=params, headers=headers, timeout=10)
        r.raise_for_status()
        data = r.json()

        if 'result' not in data or 'data' not in data['result']:
            logging.warning(f"第 {page} 页数据格式错误")  # 使用logging记录
            return None

        etf_list = data['result']['data']
        return etf_list

    except requests.exceptions.RequestException as e:
        logging.error(f"请求第 {page} 页错误: {e}")  # 使用logging记录
        return None
    except (json.JSONDecodeError, KeyError) as e:
        logging.error(f"第 {page} 页数据解析错误: {e}")  # 使用logging记录
        return None
    except Exception as e:
        logging.error(f"第 {page} 页发生其他错误: {e}")  # 使用logging记录
        return None

def get_multiple_pages_etf_data(num_pages=3, page_size=100):
    """
    获取多页ETF数据并合并。
    """
    all_etf_data = []
    for page in range(1, num_pages + 1):
        etf_data = get_etf_data(page=page, page_size=page_size)
        if etf_data:
            all_etf_data.extend(etf_data)
        else:
            logging.warning(f"第 {page} 页请求失败，跳过。") # 使用logging记录
            # break  #如果需要，可以取消注释

    return all_etf_data

def find_etfs_by_codes(etf_data_list, codes):
    """
    根据证券代码列表查找ETF数据。
    """
    found_etfs = []
    for etf_data in etf_data_list:
        if etf_data.get('SECURITY_CODE') in codes:
            # 提取所需字段，并进行负值转换
            found_etfs.append({
                'code': etf_data.get('SECURITY_CODE'),
                'name': etf_data.get('SECURITY_NAME_ABBR'),
                'premium_ratio': etf_data.get('PREMIUM_DISCOUNT_RATIO', 0) * -1
            })

    for etf in found_etfs:
        print(f"ETF代码: {etf['code']}, 名称: {etf['name']}, 溢价率: {etf['premium_ratio']}%")

    return found_etfs

def get_etf_data_by_code(etf_data_list, code):
    """
    根据单个证券代码查找ETF数据。
    """
    for etf_data in etf_data_list:
        if etf_data.get('SECURITY_CODE') == code:
            return {
                'code': etf_data.get('SECURITY_CODE'),
                'name': etf_data.get('SECURITY_NAME_ABBR'),
                'premium_ratio': etf_data.get('PREMIUM_DISCOUNT_RATIO', 0) * -1
            }
    return None


def read_codes_from_file(filepath="/home/w/work/command_line/code_short.txt"):
    """
    从文件中读取证券代码列表, 并使用绝对路径。
    """
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            codes = [line.strip() for line in f]
            return codes
    except FileNotFoundError:
        logging.error(f"文件 '{filepath}' 未找到。")
        return []  # Return an empty list if file not found
    except Exception as e:
        logging.error(f"读取文件 '{filepath}' 时发生错误: {e}")
        return []
def main():
    # 钉钉机器人配置, 替换为你的webhook
    dingtalk_webhook = "https://oapi.dingtalk.com/robot/send?access_token=0c8ac9d89428bcfc0328513575f4da77c60a9f643ef322614c849d9dfffe18d5"

    # 获取前3页的ETF数据
    num_pages_to_fetch = 3
    all_etf_data = get_multiple_pages_etf_data(num_pages=num_pages_to_fetch)

    if not all_etf_data:
        logging.error("无法获取ETF数据。")  # 使用logging记录
        return

    # 要查找的ETF代码列表
    etf_codes_to_find = ['513030','159561','159329','520830','513080','513350','159518']
    found_etfs = find_etfs_by_codes(all_etf_data, etf_codes_to_find)

    # 打印所有找到的ETF数据
    for etf in found_etfs:
        logging.info(f"ETF代码: {etf['code']}, 名称: {etf['name']}, 溢价率: {etf['premium_ratio']}%") # 使用logging

    if not found_etfs:
        logging.info(f"未找到列表 {etf_codes_to_find} 中的任何ETF数据。") # 使用logging
        return

    # 从文件中读取已持仓的ETF代码
    held_etf_codes = read_codes_from_file()
    logging.info(f"已持仓的ETF代码: {held_etf_codes}")

    # 找出符合条件的ETF并存储
    switch_etfs = []
    for etf in found_etfs:
        # 检查是否在已持仓列表中，如果不在，则进行溢价率判断
        if etf['code'] not in held_etf_codes:
            if float(etf['premium_ratio']) < 5:
                switch_etfs.append(etf)
    #
    # 按溢价率排序 (从小到大)
    switch_etfs.sort(key=lambda x: x['premium_ratio'])
    #
    # 根据是否有符合条件的结果, 决定是否发送消息, 并使用 logging 记录
    logging.info("******************************") # 使用logging
    logging.info("\n") # 使用logging

    if switch_etfs:
        logging.info("\n老板，建仓啦！ (溢价率小于5%, 且不在已持仓列表中):") # 使用logging
        message_lines = ["\n老板，建仓啦！ (溢价率小于5%, 且不在已持仓列表中):"]

        for etf in switch_etfs:
            print(f"   {etf['code']} ({etf['name']})")  # 添加打印语句
            logging.info(f"   {etf['code']} ({etf['name']})")  # 使用logging
            print(f"    {etf['code']} 溢价率: {etf['premium_ratio']}%")  # 添加打印语句
            logging.info(f"    {etf['code']} 溢价率: {etf['premium_ratio']}%")  # 使用logging
            print("-" * 30)  # 添加打印语句
            logging.info("-" * 30)  # 使用logging


            message_lines.append(f"   建仓 {etf['code']} ({etf['name']})")
            message_lines.append(f"    {etf['code']} 溢价率: {etf['premium_ratio']}%")
            message_lines.append("-" * 30)

        # 发送钉钉消息
        message = "\n".join(message_lines)
        send_dingtalk_message(dingtalk_webhook, message)
    else:
        logging.info("没有找到符合建仓条件的ETF。")  # 使用logging


if __name__ == "__main__":
    main()