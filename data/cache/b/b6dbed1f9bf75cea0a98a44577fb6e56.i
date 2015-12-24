a:5:{i:0;a:3:{i:0;s:14:"document_start";i:1;a:0:{}i:2;i:0;}i:1;a:3:{i:0;s:6:"plugin";i:1;a:4:{i:0;s:13:"markdownextra";i:1;a:2:{i:0;i:1;i:1;s:0:"";}i:2;i:1;i:3;s:10:"<markdown>";}i:2;i:1;}i:2;a:3:{i:0;s:6:"plugin";i:1;a:4:{i:0;s:13:"markdownextra";i:1;a:2:{i:0;i:3;i:1;s:6833:"<h1><center>vagrant开发使用技巧</center></h1>

<h2>添加新的box</h2>

<p>随着我们的开发需求，环境有可能会发生变化，在一个同学开发完成一个功能，并且在开发环境中安装了其他软件或者工具时，需要报告负责box更新的同学，纳入box的更新记录。发布一个新的版本时，添加一个新的box操作：</p>

<p>如发布1.0.4版本的box为例，打开gitbash</p>

<p>centos-6.4-i386-2014.08.18.1.0.4-jinritemai-dev.box</p>

<pre><code>$mkdir dev-1.0.4
#将新box拷贝到dev-1.0.4的目录，这一步就手动，非命令
$cd dev-1.0.4

$vagrant box add Centos-6.4-i386-1.0.4 centos-6.4-i386-2014.08.18.1.0.4-jinritemai-dev.box

$vagrant init Centos-6.4-i386-1.0.4

$vi Vagrantfile
#config.vm.network :private_network, ip: "192.168.33.10"
去掉这一行的#

$vagrant up
</code></pre>

<p>1.如果vagrant up出错，192.168.33.10网卡没有起来的解决方法</p>

<p>如果出现</p>

<p>The following SSH command responded with a non-zero exit status.
Vagrant assumes that this means the command failed!</p>

<p>ARPCHECK=no /sbin/ifup eth1 2> /dev/null</p>

<p>Stdout from the command:</p>

<p>Device eth1 does not seem to be present, delaying initialization.</p>

<p>Stderr from the command:</p>

<p>按照下面的步骤：</p>

<pre><code>$vagrant ssh

$sudo su -

#rm /etc/udev/rules.d/70-persistent-net.rules

#exit

$exit

$vagrant reload
</code></pre>

<p>2.注意目前不能同时启动两个以上开发环境，因为我们的网卡配置是固定了，多个环境同时运行，测试运行代码时会出现冲突</p>

<p>3.开发环境访问</p>

<p>访问慢、无响应，首先检查网络是否通畅：</p>

<p>ping 192.168.33.10</p>

<p>网络不通</p>

<p>vagrant ssh</p>

<p>ifconfig</p>

<p>网卡是否成功启动并设置相应的IP</p>

<p>网络通了，查看共享目录是否正常</p>

<p>df -h</p>

<p>空白页，nginx timeout</p>

<p>查看PHP的错误日志</p>

<p>如果域名访问直接是nginx的默认页面</p>

<p>nginx host配置文件设置不当</p>

<p>vi /data/server/nginx/vhosts/xxx.conf</p>

<h2>设置虚拟机DNS</h2>

<p>开发环境的虚拟机配置DNS的问题，直接表象是php curl很慢</p>

<p>由于虚拟机第一块网卡是DHCP的，所以DNS会自动设置，这样会导致虚拟机解析域名有问题，现在DNS的配置文件+i属性，不让DHCP修改，解决DNS的问题。</p>

<pre><code>$vagrant ssh

$sudo su -

#vi /etc/resolv.conf

;删除所有内容，写入
nameserver 114.114.114.114
nameserver 8.8.8.8
保存

#chattr +i /etc/resolv.conf 

#/etc/init.d/network 
</code></pre>

<h2>vagrant共享目录</h2>

<p>config.vm.synced_folder "../data", "/vagrant_data"</p>

<p>同根把数据库目录抽取出来了</p>

<h2>休眠与恢复</h2>

<pre><code>$vagrant suspend

$vagrant resume

$vagrant status
</code></pre>

<p>执行vagrant的大部分指令都需要配置文件Vagrantfile配置文件</p>

<h2>各个服务的重启</h2>

<pre><code>$/etc/init.d/nginx start|restart|stop
$/etc/init.d/memcached start|restar|stop
$/etc/init.d/mysqld start|restart|stop
$/etc/init.d/php-fpm start|restart|stop
$/etc/init.d/redis start|restart|stop
</code></pre>

<p>确保服务重启与关闭成功切换到root，切换指令sudo su -</p>

<h2>错误排查</h2>

<p>登录虚拟机，我们的开发环境运行相关的日志都在/data/server/var下面</p>

<pre><code>├── applog  // 今日特卖2.0应用日志目录
│   └── PlatformMe // jinritaimai.me下的商户及客服后台应用日志
│       └── Exception // jinritaimai.me全局未捕获异常的日志文件
│       └── User // （假设有User模块），对应User模块的日志
├── mysql // mysql日志
│   ├── mysql.log // mysql普通日志  
│   ├── mysql_error.log // mysql错误日志  
│   └── slow.log // 慢查询日志
├── nginx
│   ├── access.log // nginx access log
│   └── error.log // nginx 错误日志
├── php
│   ├── php_error.log  // php错误日志
│   ├── php-fpm.log // php-fpm日志
│   ├── session // 文件形式的会话数据
│   │   ├── sess_2bf9rv0ir3o7so6lqmnd0h8j51
│   ├── www.access.log // php-fpm www进程池access log日志
│   └── www.log.slow // php-fpm慢执行日志
├── redis
│   ├── dump.rdb 
└── run
    ├── memcached.pid
    ├── php-fpm.pid
    ├── redis
    ├── redis.pid
    └── xhprof // xhprof性能分析数据目录
        ├── IndexDbTest-1408439719224.PlatformMe.xhprof
</code></pre>

<p>另外mysqld使用的配置是/etc/my.cnf，其中有一项配置，目前各位环境中是这样的：</p>

<p>log = /data/server/var/mysql.log</p>

<p>需要改为：</p>

<p>log = /data/server/var/mysql/mysql.log</p>

<p>不然会因为权限问题，而导致mysql的普通日志无法写入</p>

<h2>关于配置文件的位置</h2>

<p>通常的配置文件，没有特殊需求，配置文件都在/data/server/etc目录下</p>

<h3>PHP配置文件</h3>

<p>/data/server/etc/php.ini 主配置文件</p>

<p>/data/server/etc/php.d/  模块配置文件目录</p>

<p>/data/server/etc/php-fpm.conf php-fpm配置文件</p>

<h3>MySQL配置文件</h3>

<p>/etc/my.cnf</p>

<h3>nginx配置文件</h3>

<p>/data/server/nginx/nginx.conf</p>

<p>/data/server/nginx/vhosts/ 虚拟主机host配置文件目录（.conf结尾的配置文件会include）</p>

<h3>redis配置文件</h3>

<p>/data/server/etc/redis.conf</p>

<h2>已安装的开发工具位置</h2>

<p>/data/目录</p>

<pre><code>└── www
    ├── Global
    ├── jinritemai.me
    ├── phpMyAdmin
    ├── phpRedisAdmin
    ├── xhprof
    └── yaf.simple
</code></pre>

<h2>tail -f的使用</h2>

<p>数据库普通日志、PHP的错误日志、应用日志</p>

<h2>xhprof</h2>

<p>性能分析工具</p>

<h2>redis</h2>

<p>redis图形管理工具</p>

<h2>/etc/hosts</h2>

<h2>dbpma.dev</h2>

<h2>firephp</h2>

<p>配合firebug调试PHP程序</p>

<h2>今日特卖2.0学习</h2>

<p>platform.jinritemai.me</p>

<p>order.api.jinritemai.me</p>

<p>www.jinritemai.me</p>

<p>需要说明上述三个域名是用来学习，了解今日特卖2.0框架。</p>

<p>命名空间</p>

<p><a href="http://php.net/manual/zh/language.namespaces.php">http://php.net/manual/zh/language.namespaces.php</a></p>

<p>Yaf基本手册</p>

<p><a href="http://www.laruence.com/manual/">http://www.laruence.com/manual/</a></p>

<p><link rel="stylesheet" href="http://yandex.st/highlightjs/7.5/styles/monokai_sublime.min.css"><script src="http://yandex.st/highlightjs/7.5/highlight.min.js"></script></p>

<script>
hljs.initHighlightingOnLoad();
</script>
";}i:2;i:3;i:3;s:6144:"
#<center>vagrant开发使用技巧</center>


##添加新的box

随着我们的开发需求，环境有可能会发生变化，在一个同学开发完成一个功能，并且在开发环境中安装了其他软件或者工具时，需要报告负责box更新的同学，纳入box的更新记录。发布一个新的版本时，添加一个新的box操作：

如发布1.0.4版本的box为例，打开gitbash

centos-6.4-i386-2014.08.18.1.0.4-jinritemai-dev.box
	
```
$mkdir dev-1.0.4
#将新box拷贝到dev-1.0.4的目录，这一步就手动，非命令
$cd dev-1.0.4

$vagrant box add Centos-6.4-i386-1.0.4 centos-6.4-i386-2014.08.18.1.0.4-jinritemai-dev.box

$vagrant init Centos-6.4-i386-1.0.4

$vi Vagrantfile
#config.vm.network :private_network, ip: "192.168.33.10"
去掉这一行的#

$vagrant up
```

1.如果vagrant up出错，192.168.33.10网卡没有起来的解决方法

如果出现

The following SSH command responded with a non-zero exit status.
Vagrant assumes that this means the command failed!

ARPCHECK=no /sbin/ifup eth1 2> /dev/null

Stdout from the command:

Device eth1 does not seem to be present, delaying initialization.


Stderr from the command:

按照下面的步骤：

```
$vagrant ssh

$sudo su -

#rm /etc/udev/rules.d/70-persistent-net.rules

#exit

$exit

$vagrant reload
```
2.注意目前不能同时启动两个以上开发环境，因为我们的网卡配置是固定了，多个环境同时运行，测试运行代码时会出现冲突

3.开发环境访问

访问慢、无响应，首先检查网络是否通畅：

ping 192.168.33.10

网络不通

vagrant ssh

ifconfig

网卡是否成功启动并设置相应的IP

网络通了，查看共享目录是否正常

df -h

空白页，nginx timeout

查看PHP的错误日志

如果域名访问直接是nginx的默认页面

nginx host配置文件设置不当

vi /data/server/nginx/vhosts/xxx.conf


##设置虚拟机DNS


开发环境的虚拟机配置DNS的问题，直接表象是php curl很慢

由于虚拟机第一块网卡是DHCP的，所以DNS会自动设置，这样会导致虚拟机解析域名有问题，现在DNS的配置文件+i属性，不让DHCP修改，解决DNS的问题。

```
$vagrant ssh

$sudo su -

#vi /etc/resolv.conf

;删除所有内容，写入
nameserver 114.114.114.114
nameserver 8.8.8.8
保存

#chattr +i /etc/resolv.conf 

#/etc/init.d/network 
```

##vagrant共享目录

config.vm.synced_folder "../data", "/vagrant_data"

同根把数据库目录抽取出来了


##休眠与恢复

```
$vagrant suspend

$vagrant resume

$vagrant status
```

执行vagrant的大部分指令都需要配置文件Vagrantfile配置文件

##各个服务的重启

```
$/etc/init.d/nginx start|restart|stop
$/etc/init.d/memcached start|restar|stop
$/etc/init.d/mysqld start|restart|stop
$/etc/init.d/php-fpm start|restart|stop
$/etc/init.d/redis start|restart|stop
```
确保服务重启与关闭成功切换到root，切换指令sudo su -

##错误排查

登录虚拟机，我们的开发环境运行相关的日志都在/data/server/var下面

```
├── applog  // 今日特卖2.0应用日志目录
│   └── PlatformMe // jinritaimai.me下的商户及客服后台应用日志
│       └── Exception // jinritaimai.me全局未捕获异常的日志文件
│       └── User // （假设有User模块），对应User模块的日志
├── mysql // mysql日志
│   ├── mysql.log // mysql普通日志  
│   ├── mysql_error.log // mysql错误日志  
│   └── slow.log // 慢查询日志
├── nginx
│   ├── access.log // nginx access log
│   └── error.log // nginx 错误日志
├── php
│   ├── php_error.log  // php错误日志
│   ├── php-fpm.log // php-fpm日志
│   ├── session // 文件形式的会话数据
│   │   ├── sess_2bf9rv0ir3o7so6lqmnd0h8j51
│   ├── www.access.log // php-fpm www进程池access log日志
│   └── www.log.slow // php-fpm慢执行日志
├── redis
│   ├── dump.rdb 
└── run
    ├── memcached.pid
    ├── php-fpm.pid
    ├── redis
    ├── redis.pid
    └── xhprof // xhprof性能分析数据目录
        ├── IndexDbTest-1408439719224.PlatformMe.xhprof
```

另外mysqld使用的配置是/etc/my.cnf，其中有一项配置，目前各位环境中是这样的：

log = /data/server/var/mysql.log

需要改为：

log = /data/server/var/mysql/mysql.log

不然会因为权限问题，而导致mysql的普通日志无法写入

##关于配置文件的位置

通常的配置文件，没有特殊需求，配置文件都在/data/server/etc目录下

###PHP配置文件

/data/server/etc/php.ini 主配置文件

/data/server/etc/php.d/  模块配置文件目录

/data/server/etc/php-fpm.conf php-fpm配置文件

###MySQL配置文件

/etc/my.cnf

###nginx配置文件

/data/server/nginx/nginx.conf

/data/server/nginx/vhosts/ 虚拟主机host配置文件目录（.conf结尾的配置文件会include）

###redis配置文件

/data/server/etc/redis.conf

##已安装的开发工具位置

/data/目录

```
└── www
    ├── Global
    ├── jinritemai.me
    ├── phpMyAdmin
    ├── phpRedisAdmin
    ├── xhprof
    └── yaf.simple
```

##tail -f的使用

数据库普通日志、PHP的错误日志、应用日志

##xhprof

性能分析工具

##redis

redis图形管理工具

##/etc/hosts


##dbpma.dev


##firephp

配合firebug调试PHP程序

##今日特卖2.0学习

platform.jinritemai.me

order.api.jinritemai.me

www.jinritemai.me

需要说明上述三个域名是用来学习，了解今日特卖2.0框架。

命名空间

[http://php.net/manual/zh/language.namespaces.php](http://php.net/manual/zh/language.namespaces.php)

Yaf基本手册

[http://www.laruence.com/manual/](http://www.laruence.com/manual/)


<link rel="stylesheet" href="http://yandex.st/highlightjs/7.5/styles/monokai_sublime.min.css"><script src="http://yandex.st/highlightjs/7.5/highlight.min.js"></script><script>
hljs.initHighlightingOnLoad();
</script>



";}i:2;i:11;}i:3;a:3:{i:0;s:6:"plugin";i:1;a:4:{i:0;s:13:"markdownextra";i:1;a:2:{i:0;i:4;i:1;s:0:"";}i:2;i:4;i:3;s:11:"</markdown>";}i:2;i:6155;}i:4;a:3:{i:0;s:12:"document_end";i:1;a:0:{}i:2;i:6155;}}