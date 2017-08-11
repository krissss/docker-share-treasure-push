<?php
if (!function_exists('env')) {
    function env($key, $default = null)
    {
        $value = getenv($key);
        if ($value === false) {
            return $default;
        }
        return $value;
    }
}

if (!function_exists('host2Ip')) {
    function host2Ip($host)
    {
        if(filter_var($host, FILTER_VALIDATE_IP)){
            return $host;
        }
        return gethostbyname($host);
    }
}

$config = [
    // 服务注册地址
    'registerAddress' => env('REGISTER_ADDRESS', '127.0.0.1:1238'),

    // worker 名称
    'workerName' => 'dashboard_worker',
    // bussinessWorker 进程数量,等于CPU数
    'workerCount' => env('WORKER_COUNT', 2),

    // gateway 协议
    'gatewayUrl' => 'websocket://0.0.0.0:7272',
    // gateway 名称
    'gatewayName' => 'gateway',
    // gateway 数量,等于CPU数
    'gatewayCount' => env('GATEWAY_COUNT', 2),
    // 本机ip，分布式部署时使用内网ip
    'gatewayLanIp' => host2Ip(env('LAN_IP', '127.0.0.1')),
    // 内部通讯起始端口，假如$gateway->count=4，起始端口为4000
    // 则一般会使用4000 4001 4002 4003 4个端口作为内部通讯端口
    'gatewayStartPort' => 4000,

    // 是否启用心跳检测
    'gatewayPing' => true,
    // 心跳间隔
    'gatewayPingInterval' => 60,

    // 是否检查网站域名
    'checkOrigin' => env('CHECK_ORIGIN', false),
    // 只允许建立 web socket 的网站域名
    'HTTP_ORIGIN' => env('HTTP_ORIGIN', 'http://127.0.0.1'),

    // 是否是注册服务节点，非注册服务节点 start_register.php 不需要执行
    'is_register_node' => env('IS_REGISTER_NODE', true),
];

return $config;
