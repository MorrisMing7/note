#  常用命令

#### 文件夹

-   cd x

    ```
    ~ 家
    - 上一个工作目录
    . 为当前目录
    .. 为上层目录
    ```

-   pwd [-P真实路径即非链接表示的路径]输出当前目录

-   ls -al 通常alias为 ll

-   mkdir [-p建立上层] dir3
            mkdir -m 777 dir4

-   rm xxx 

-   rmdir [-p删除也为空的上层] 删除空文件夹

-   mv fromdir todir

-   cp sourcefile targetFileOrDirection
            [--parent] 连带父目录一同复制 cp --parent a/b/c/x.txt directionX 会在目标文件夹下复制目录a/b/c

-   chmod a+x filename

    -   a为all 还可以是u=user，g=group，o=other
                    +为增加权限还可以-
                    x为执行还可以是r=read，w=write

    -   chmod [-R] 777 file
                    r=4,w=2,x=1
                    -R 为递归

-   ln 实体链接

    -   ln fileA fileB 文件A必须存在 文件B必须不存在

        从此AB是一个文件的不同入口，修改同步，名字不同，删除一个另一个仍会存在

        ll fileA fileB 会显示两个相同的iNode

    -    ln -s fileA fileASymolickLink A若是被删除，则符号链接无法打开，A也可以是目录
                    新建目录的link数为2，新建目录时，该目录的上层目录的link+1
                        /tmp/test    link到本身
                        /tmp/test/.  link到本身
                        /tmp/tets/.. link到tmp

-   du -sh 目录的占容量，文件夹大小
                du -s * | sort -nr | head 

#### 文件            

-   cat一次显示 more逐行显示 less上下翻页（/搜索nN上下一个，gG头尾），
-   head与tail -n number filename
            tail -fn30 #监视文件最后30行
-   touch建立空文件，或修改文件时间
            file filename 文件信息
-   find / -name passwd
            find / -name "*passwd"
-   tar -xzvf xxx.tar.gz
                -czvf xxx.tar.gz Afile Bfile Cfile ....

#### 磁盘 分区 挂载

-   df -h 磁盘使用情况

    ​        -i iNode使用情况

-   lsblk 列出磁盘列表

-   blkid 列出磁盘uuid

-   parted /dev/sdb1 print 列出磁盘的分区表类型与分区信息

-   gdisk fdisk 分区工具 MBR用fdisk GPT用gdisk

-   fdisk 

    -   -l 查看磁盘
    -   fdisk /dev/sdb 进入分区工具
        -   m查看帮助 
        -   p打印当前分区表 
        -   n新建(首个扇区默认即可，末尾扇区默认为全部分配，若需设置记得前面加上+号如+7.3T)
                    tip: 硬盘大于 2TB不能直接新建分区需要先增加一个GPT标签，输入【g】回车

-   mkfs 建立文件系统 即格式化
                mkfs.xfs mkfs.ext4...

-   mount [-t 文件系统种类] 装置名 挂载点
                -o iocharset=utf8 编码类型
                -t 几乎不需要指明类型，已经可以自己判断       

    ​            mount -a 的配置文件/etc/fstab

# vim



-   进入命令模式
            : / ?

#### 光标移动

-   左下上右hjkl
                20j向下移动20行
                n[enter]
            跳转到本行第n个字符
                n[space]
-   行内首尾
                0 或 [home]键
                尾
                [end] 或 $
-   翻页
                Ctrl+f 等价 [PageDown]  ; Ctrl+d 向下半页
                Ctrl+b 等价 [PageUp]    ; Ctrl+u 向上半页
-   屏幕位置
                最上方  H
                中央    M
                最下方  L
-   文件位置
                nG 文件第n行
                gg 文件第一行
                G 文件尾
-   搜索
                /word 向光标以后寻找word
                ?word 向光标之前寻找word
                n N 下一个 上一个

#### 编辑模式

-   插入      

    ​        i a o r

    ​    o 下一行插入新行    O 上一行插入新行 

    ​    r 替代一个字符   R 持续替代字符相当于word里的 insert键

-   更动
    -   替换
                    :x,ys/word1/word2/g[c] 将x到y行间的word1替换为word2
                        y可以是$,表示最后一行
                        最后可选的c表示让用户确认是否替代
                光标所在处为当前闪烁字符的左侧
    -   删除
                    x   相当于[delete]
                    X   相当于[backspace]
                    nx  向后删除n个字符
                    dd  删除整行
                    ndd 删除n行
                    d1  G删除光标所在至第一行
                    dG  删除光标所在至最后
                    d0  行内删除到第一个字符
                    d$  行内删除到最后一个字符
                    c20j
                    c21l 用c删除后就进入插入模式了
    -   复制
                    yy 当前行
                    nyy 当前行向下n行（包括当前行）
                    y1G 当前一行至第一行    
                    yG  当前一行至最后一行
                    y0  行内复制到行首
                    y$  行内复制
    -   可视模式
                    v 行内选择
                    V 行选择
                    Ctrl+v 长方形选择
                    y 选中部分复制
                    d         删除   
                    p 可以方形复制
    -   粘贴
                    p下一行     行内粘贴时粘贴到当前字符右侧
                    P到上一行   行内粘贴时粘贴到光标处
    -   撤销与重做
                    u 撤销
                    Ctrl+r 重做    
                    . 重复上一个动作

#### 保存退出

​        :w 写入
​        :w! 强行写入
​        :q 
​        :q! 离开并不存储
​        :wq 存储并离开
​        ZZ  自动离开 更动则存储 
​        :w [filename] 另存为
​        :r [filename] 将此文件中的内容加到光标所在行的下一行
​        :n1,n2 w [filename] 将n1到n2的内容保存为一个文件
​        :! command 暂时离开vi 执行command 显示结果
​        :set [nu|nonu]  设置或取消行号

#### 多窗口

​        :sp [filename]
​        Ctrl+w, j/k 切换窗口
​        Ctrl+w, q 退出

#### 自动补全

​        Ctrl+x,Ctrl+n 以正在编辑的文字为关键字补齐
​        Ctrl+x,Ctrl+o 以文件拓展名语法补齐
​        Ctrl+x,Ctrl+f 以当前目录下的文件名为补齐目标

#### 转换编码

​        file fileName 查看文件编码
​        iconv -f big5 -t utf8 filename [-o newfile]
​        iconv --list 列出支持的语系

#### 回车符转换

​        dos2unix 
​        unix2dos [-kn] file [newfile]
​            -n保留旧文件转换内容到新文件
​            -k保留文件原本的mtime时间

# 开始bash

#### 命令行编辑

​        Ctrl+ae 移动光标到行首尾
​        Ctrl+uk 删除光标前后内容

#### 变量

-   由字母与数字与下划线组成，开头不可是数字

-   =直接赋值，左右不可由空格，如var1=xxx

-   取用变量使用$符号，如 echo $var1; 输出xxx

-   双引号内的东西有其原有特性，

    ​        如var2="var1 is $var1" ;echo $var2;其结果是var is xxx

    ​		若是单引号，则表示为普通字符串 var4='var1 is not $var1';echo $var4;结果为var1 is not $var1

-   跳脱字符\，如var3=var2\ haha3;echo var3; 其结果var2 haha3。可以用作换行
            若变量设置时需要一些命令的结果可以用

    ```
    `command` 或者 $(command) 
    	如var5="print working dir:`pwd`";
    	结果为print working dir: /home/morris
    ```

-   拓展变量内容 PATH=${PATH}:/home/bin或者PATH="$PATH":home/bin

-   unset var5取消var5的设置 set 命令可以展示现有变量

-   $本身也是变量，表示shell的PID。echo $$输出15983

-   ?也是变量，表示上个指令的回传值，成功的指令为0

-   read 接受键盘输入的一行字符到一个变量中去

-   declare 宣告变量类型，没有参数时=set
                -a 数组
                -i 数字，整数，bash内的运算只能是整数1/2=0
                -x 等同于export，将变量变为环境变量
                -r 只读类型，不可更改且不能unset
            数组 var[1]=aaa var[2]=bbb var[3]=ccc  echo ${var[1]}        

#### 命令别名

​	    type ls #查询ls是否內建 找出执行档
​	    alias ll='ls -alF'  #将ls -alF别名设为ll（默认的）
​	    aliad lm='ls -al | more'
​	    unalias lm

#### 用户资源限制 ulimit

​	    -a 列出所有限制
​	    -SH 警告设定与限制设定 -u 最大process数量
​	    -f 最大文件容量        -d 程序可使用最大内存分段segment
​	    -l 用于锁定的内存量    -t 最大cpu时间单位秒
​	    -c 核心文件(当程序出错，系统可以将内存中的信息写成文件)的最大容量

#### 变量编辑

-   删除
    	#,##从左向右删除到指定字符 单个的表示只匹配最短                

    ​				path=$PATH;  echo ${path#/*:} ; echo ${path##/*:};百分号则反向匹配
    ​	%,%%从右向左删除 两个的表示匹配最长
    ​                echo ${path%%:/usr*} 

-   替换
                ${path//morris/Morris} 可以把Morris去掉用以删除，同样的可以用单个/表示只删除一个

#### 命令历史 history

-   history 10 最近10条
            -c 清除当前shell中的history
        history [-arw] xxxfile
            -a 当前新增的加入到xxx中去 没有指定xxx则写入~/.bash_history
            -r 读取xxx中的内容到history中
            -w 当前history写入到文件
        !xxx 向前搜索开头为xxx的命令并执行
        !!   相当于按↑再回车

#### 欢迎界面文字

-   文件：/etc/issue

    ```
        \d本地端时间的日期;     \l显示第几个终端机接口;  \m显示硬件的等级 (i386/i486/i586/i686...);
        \n显示主机的网络名称;   \O显示 domain name;     \r操作系统的版本 (相当于 uname -r)
        \t显示本地端时间的时间; \S操作系统的名称;        \v操作系统的版本
    ```

#### bash环境配置文件               

-   login shell 即需要登陆密码的shell

    加载/etc/profile中的系统整体设定

    ```
    PATH:依据 UID 决定 PATH 变量要不要含有 sbin ;
    MAIL:依据账号设定好使用者的 mailbox到 /var/spool/mail/账号名; 
    USER:根据用户的账号设定此一变量内容;
    HOSTNAME:依据主机的 hostname 指令决定此一变量内容; 
    HISTSIZE:历史命令记录笔数。
    umask:包括 root 默认为 022 而一般用户为 002 等!
    ```

     ~/.bash_login或~/.profile 中则为用户的设定，登录某用户，加载对应设定

-   no-login shell

#### 终端环境

-   stty -a  #显示终端环境的设定
    	stty intr ^C  #将中断设置为Ctrl+C（默认就是这个）

#### 特殊字符

-   ```
    []*? [-] [^] 正则符号
    # 注释
    \ 转义
    | 管道
    ; 连续指令分割
    ~ 用户家目录
    $ 取变量
    & 工作控制，将指令变为背景下工作 使用jobs查看正在背景中执行的任务
    ! 逻辑非
    > >> < << 数据流重导向
    '' 符号$在其中作为文本
    "" 保留$在其中的功能
    `` 先执行指令
    () 子shell的起始与结束
    {} 命令区块组合 
    ```



#### 数据流  

-   三种流
    -   标准输入 (stdin) :代码为 0 ,使用 < 或 << ;
    -   标准输出 (stdout):代码为 1 ,使用 > 或 >> ;文件不存在则建立
    -   标准错误输出(stderr):代码为 2 ,使用 2> 或 2>>

-   垃圾黑洞 /dev/null 如xxcommand xxarg 2> /dev/null将错误信息丢弃

-   单个符号表示覆盖，多个表示累加
        例 ll /etc > ~/rootfilelist  

    ​    find /home -name .bashrc > list_right 2> list_error 

-   正确与错误信息分别输入不同文件
         写入同一个文件的特殊语法:可以使用 2>&1 也可以使用 &>
         常规写法 xxxx > list 2> list
         特殊写法 xxxx > list 2>&1
                          xxxx &> list
          写入同一个文件由于两股数据留交叉，会造成次序混乱

-   键盘输入创建文件
        cat > catfile 
         [输入内容，ctrl+D结束]
        cat > catfile <<"eof"
         [输入内容，以"eof"结束]

#### 连续指令

​    不相干	sync; sync; shutdown -h now
​    正确则继续  cd ~ && cat .bashrc   
​    不成功则继续  ls abc.txt || touch abc.txt

#### 管线  

-   cmd1 | cmd2 

​    cmd1的stdout成为cmd2的stdin        
​    管线命令仅会处理 standard output,对于 standard error output 会予以忽略
​    管线命令必须要能够接受来自前一个指令的数据成为 standard input 继续处理才行

-   '-'可以 表示stdin与stdout
        tar -cvf - /home | tar -x - -C /tmp/homebackup        
    
-   xarg #为不支持管线的指令提供参数
        很多指令其实并不支持管线命令,因此我们可以透过 xargs使该指令可以使用stdin
        cut -d ':' -f 1 /etc/passwd | xargs -te'sync' -n 1 id
    
-   截取
        cut 截取出行内我们想要的数据
            cut -d '分隔字符' -f '数字表示的段,逗号间隔'
            cut -c 12-20 以字符为单位列出第12到第20
                不太适合处理多空格相连的数据
        grep 分析行信息，只取需要的行<a name="grep"></a>
            grep [-acinv] [--color=auto] '搜寻字符串' filename
    	    a 将binary文件以text方式搜寻
    	    c 计算次数  i 忽略大小写  n 输出行号  v 反向选择
            last | grep 'morris' |cut -d ' ' -f 1 #最近登录的账户
            -An 即After除本行外后续的n行也显示出来
            -Bn 即Before除本行外前面的n行也显示
    
-   排序
    
    -   ​    sort [-f..] [file or stdin]
        ​    -f : 忽略大小写的差异,例如 A 与 a 视为编码相同;
        ​    -b : 忽略最前面的空格符部分;
        ​    -M: 以月份的名字来排序,例如 JAN, DEC 等等的排序方法;
        ​    -n : 使用『纯数字』进行排序(默认是以文字型态来排序的);
        ​    -r : 反向排序;
        ​    -u : 就是 uniq ,相同的数据中,仅出现一行代表;
        ​    -t :分隔符,预设是用 [tab] 键来分隔;
        ​    -k :以那个区间 (field) 来进行排序的意思
    -   uniq 去重 -i忽略大小写 -c 计数
    -   wc 字数统计 -l 列出行数 -w 列出单词英数 -m 字符数
    
-   双向重导向                                           stdin -> tee -> stdout
        即将输出导向到两处地方                                 |  

    ​    例                                                                        V
    ​        last | tee last.list |cut -d " " -f 1               file

-   字符转换

    -   tr -d '要删除的串' 
               -s 取代掉重复字符
    -   col -x 将tab转换为对等的字符
    -   expand -t tab转成指定数额的空格
    -   join -t '分割字符(默认tab)' -1 n1 firFileName -2 n2 secFileName
                -1 -2 设置第1第2个文件的用以比对的字段序数
                将两个文件的行中对应字段相同的链接成一行，对应字段需已排序
    -   paste [-d] file1 file2
                直接将两个文件的行连在一起 -d 分隔符默认为tab, 
                file部分写为-，则表示来自stdin

-   大文件分割
        split [-bl] file Prefix
            -b 按大小划分 -l 按行数划分 Prefix为前缀即划分后保存文件名的前缀

# 正则表达式

LANG=C
    编码顺序会对正则有影响[A-Z]在一些语系中会包含小写字母
grep
    见上 <a href="#grep"> grep </a>
    -v 反选  如 xxx | grep -v '^$' #不要空行
    除使用管线外，还可以直接使用文件
        grep 'pattern' fileA fileB ...

#### 语法

-   `[]` 匹配一个其中内容表示的集合中的字符，
        除下述的形式外，更一般的使用[mnpq]表示集合，`[^abc]`匹配不是abc的字符
        ```
    [:alnum:] 0-9a-bA-B     [:alpha:] a-bA-B        [:blank:] 空格与tab
    [:digit:] 0-9           [:xdigit:] 16进制数字符   [:gragh:] 除去空格与tab外的所有
    [:lower:] a-b           [:punct:] 标点           [:space:] 任何产生空格的字符
    [:upper:] A-B           [:cntrl:] CR..等控制字符  [:print:] 任何可以被打印的字符
        ```
    
    `[:digit:]` 代表0-9。故需要匹配数字时需要写成`[[:digit:]]`。其他的同理

-   行首行尾
        ^ $ 注：会有dos与unix的断行方式的干扰
-   单个字符的重复
        `.` 表示任意一个字符
        `*` 表示重复左边的字符0次或多次
        `+` 表示字符出现至少一次
        `?` 表示字符至多出现一次
            `a*b`匹配     b，ab，aaaaaaab ……
            `a+b`匹配     ab，aaab ……
            `a?b`匹配     ab，b。
        {n}，{n,}，{n,m} 重复n次，n次以上，n到m次
            由于{}在shell中有特殊含义，故需要\来转义

-   匹配组
        `(pattern)`      匹配并获取此匹配到匹配组集合
        `(?:pattern)`  匹配 pattern 但不获取匹配结果，
                在匹配“abc或abd”两种之一时，可以写为abc|abd ，使用这里的方式可简写为ab(?:c|d)
        `(?=pattern)`   正向肯定预查，Morris(?=1|2|7) 会查到Morris1，Morris2与Morris7
                并且只匹配Morris，不包含127，且不会匹配后面不是127的Morris
        `(?!pattern)`   正向否定预查
        `(?<=pattern)` 反向肯定预查，(?<=Morris)[127]，同上例，这次只查1 2 7，
        `(?<!pattern)` 反向否定预查，(?<!Morris)[127]，即查前面不是Morris的1 2 7

-   sed
        -n 使用后，只有被处理的一行才会显示出来；默认情况是全都显示
        -f filename 写入文件
        ''内函数
            d删除2到5行
                xxx | sed '2,5d' 
            a i新增 在2行后新增一行,2a后的内容还可以用\来进行多行插入，i替换a表示前一行
                xxx | sed '2a nothing is everything' 
            c 行取代
                xxx | sed '2,5c No.2-No.5 lines gone'
            p 打印 与-n一同使用，打印某行内容，不加-n指定的行会重复打印两次
                xxx | sed '2,4p'
            s/xxx/aaa/g 替代 ，aaa去掉则为删除
                /sbin/ifconfig eth0 | grep 'inet ' | sed 's/^.*inet //g'
        -i 直接修改文件
            sed -i 's/xxx/aaa/g' xxxx.file
-   print
        \a 警告声音输出  \b 退格键(backspace)  \f 清除屏幕 (form feed)
        \n 输出新的一行  \r 亦即 Enter 按键    \t 水平的 [tab] 按键
        \v 垂直的 [tab] 按键   \xNN NN 为两位数的数字,可以转换数字成为字符。
        %ns 那个 n 是数字, s 代表 string ,亦即多少个字符;
        %ni 那个 n 是数字, i 代表 integer ,亦即多少整数字数;
        %N.nf 那个 n 与 N 都是数字, f 代表 floating (浮点),如果有小数字数,
-   awk   
        NF 每一行 ($0) 拥有的字段总数
        NR 目前 awk 所处理的是『第几行』数据
        FS 目前的分隔字符,默认是空格键
        使用$n表示行内第n个字段
            last -n 5| awk '{print $1 "\t lines: " NR "\t columns: " NF}'
            cat /etc/passwd | awk '{FS=":"} $3 < 10 {print $1 "\t " $3}'
            cat XXX.txt | \
            > awk 'NR==1{printf "%10s %10s %10s %10s %10s\n",$1,$2,$3,$4,"Total" }
            > NR>=2{total = $2 + $3 + $4 #这里用了\[enter]也可以使用;作为{}中多个命令的间隔
            > printf "%10s %10d %10d %10d %10.2f\n", $1, $2, $3, $4, total}'

# Shell脚本

-   第一行
        #!/bin/bash
        宣告本shell脚本使用的bash
-   exit 0 #正确退出
-   read 读取用户键盘输入
        read -p "please input xxx: " -t n argName  #等待时间单位秒
-   数值计算 var=$((${firstnu}*${secnu}))
            echo "2.20*2.2" |bc #精确度为字符串中的最长小数点后位数
            计算圆周率
            echo "scale=80; 4*a(1)" | bc -lq  # a(1)是bc中的一个函数表示arctan

#### source与bash的执行方式

-   source 在当前shell中执行，变量会被保留        
		例如常用的不注销系统而要让某些写入 ~/.bashrc 的设定生效时使用的『 source ~/.bashrc 』
-   bash xxx.sh 在子程序中执行，变量除非被export，否则不会被保留

#### 各种判断

-   空判断与赋值
    
    `var=${str[:][+-=?]expr}`
    
    ```
    str  表示是否str没有定义
    str: 表示是否str没有定义或定义为空字符串
    +	是则为str，否则为expr
    -	与+相反
    =	是则str赋值为expr，否则str不变，后在var=str
	?	是则expr输出至stderr，否则var=str
	
	```
	
-   名字
                `-e` exist此名存在         `-f` file这是个文件   `-d` dir这是个目录
                `-b` blockdevice装置    `-c` character装置    `-S` Socket文件
                `-p` pipe先进先出文件  `-L` 链接档

-   权限
                `-r` `-w` `-x`   `-u` SUID属性  `-g` SGID属性  `-k` Sticky bit属性   `-s` 非空文件

-   文件
                `-nt` newThan `-ot` oldThan `-ef` 是否为同一文件用于hardlink的判断

-   整数
                `-eq` `-ne` `-gt` `-lt` `-ge` `-le`

-   字符串
                `-z` 空字符串 `-n` 非空 `==` 相等 `!=` 不等

-   多条件
                `-a` and   `-o` or   `!` 非

-   判断符号[]
                `[ -z $home ]`
                **注意**：`[ xx -x yy ]`其中有四处空格分割

#### 默认变量 

​    对于一行命令，如 command aa bb cc xx

    $0=command $1=aa $2=bb ...
    $# 表示参数总数，不算0号
    $@ 表示【 "$1" "$2" "$3" "$4" 】
    $* 表示【 "$1c$2c$3c$4" 】其中c默认是空格
    shift命令：变量偏移，可加数字参数，表示从左开始偏移变量，默认1，表示从左到右移除掉n个参数
#### 条件

        if [ xxxxx ]; then
            # do something
        elif [ xxx ]; then
            # do xx
        else
            # do
        fi
        if的条件可以用多个部分 [ "${a}" -eq "a" -a "${b}" -eq "b"]就相当于
            [ "${a}" -eq "a" ] && [ "${b}" -eq "b"]
switch

        case $arg in
            "aa")
                # do
                ;;      #跳出
            "bb")
                # do
                ;;
            *)          #其他情况
                # do
                exit 1
                ;;
        esac

#### 循环

        while [ xxx ];do 
            #
        done
        方式二
        until [ xxx ];do 
            #
        done
        方式三
        for var in x1 x2 x3 ...;do
            #
        done
        方式四
        for (( i=1; i<=${nu}; i=i+1 )); do
            s=$((${s}+${i}))
        done
#### 函数

​    同样靠 $1 $2来使用参数，fname aa bb; 来调用并传参

        function fname(){
            # do something
        }
debug

    sh [-nvx] xxx.sh
    -n 仅检查语法 -v 执行前打印script -x 打印使用到的scirpt
# 账号与权限

#### 登录

​            id morris 查看系统中morris账户的有无以及uid、gid
​            ll -d /home/morris 根据文件夹记录的uid、gid去/etc/passwd文件中查找对应账户的名字

- 登录过程
根据输入账号查找/etc/passwd，取出uid，根据uid查找/etc/shadow核对密码，成功则进入shell
- /etc/passwd -rw-r--r--  以“:”分割每行信息分别为
账户名、密码(显示为x)、UID(0管理员1-999系统账户1000及以上给一般使用者、GID(与/etc/group有关)、用户信息说明、家目录、Shell
- /etc/shadow -rw-------或----------  以“:”分割每行信息分别为
账户名、加密后的密码及盐值($(1|5|6)$salt$xxxxx)、最近密码更动日期(自1970年1月1日累加)、             密码不可更动天数、密码需要更新天数、更新前警告天数、过期后(登录会强制要求改密)宽限天数、账户失效日期(19700101天数)、保留
  - $1使用md5 $5使用SHA256 $6使用SHA512
                    authconfig --test | grep hashing 查看shadow的加密机制
- 忘记密码
    -   普通用户通过root用户使用passwd
    -   root用户重启进入单人维护模式、或以liveCD开机进入根目录修改/etc/shadow将root的密码字段清空

#### 账号

​    id morris

-   用户添加 添加用户 useradd 
            [-u UID] [-g 初始群组] [-G 次要群组] [-mM]
                    [-c 说明栏] [-d 家目录绝对路径] [-s shell] 使用者账号名
                M表示不要建立家目录，默认为m相反
    -   先在/etc/passwd中建立新的一行，再建立shadow文件中一行填入相关参数，
                        再在group中加入新的一个一模一样的组名，最后在/home下建立其家目录
                    -r 会建立系统账户，即uid在1-999之间
    -   参考档  useradd -D
                    GROUP=100 ，100即为users这个群组，
                        私有群组机制：建立与账户名相同的群组给用户，自家目录权限700
                        公有群组机制：使用users作为初始群组，自家目录权限755
                    HOME=/home 家目录位置
                    EXPIRE= 账户失效日期 shadow的第8字段
                    SHELL=/bin/bash 默认shell程序
                    SKEL=/etc/skel 家目录参考，将其中内容复制到用户家目录
                    CREATE_MAIL_SPOOL=yes 建立使用者邮箱  
                        默认mailbox文件在/var/spool/mail/morris
    -   usermod
                    与ueradd 命令参数相同，多了 -aG添加群组，-L -U 即passwd中的-l-u
    -   userdel morris
                    -r 删除家目录
-   密码修改
            passwd  所有人均可以使用此更改个人密码
                --stdin 通过管线接收密码输入 echo "xxx" | passwd --stdin morris
                -l 锁定，在shadow文件第二字段加入!使其失效
                -u 解除锁定
                -S shadow文件中的密码相关信息
                -n 不可更动天数 -x 必须更改的天数 -w 密码过期前警告天数 -i 密码失效期
            change -l morris 查看morris的密码信息
                -d -m -M -W -I -E分别对应passwd的3-8字段
            chpasswd
                echo "morris:abcdef" |chpasswd

#### 群组

-   /etc/group    以“:”分割每行信息分别为
            组名、群组管理员用密码此处为x已移步到gshadow文件、GID、群组支持账户','间隔
-   有效群组与初始群组
            初始群组：即passwd文件中的GID，用户登入系统立即拥有此群组权限，
                且由于是初始群组，不需要再group文件中的第四字段写入该账户
            有效群组
                groups 命令可以获取本用户的所有群组，其首个即为有效群组
                newgrp 命令可以进行有效群组切换
                    必须是本用户支持的群组，且是以另一个shell来提供功能的
            加入另外的群组
                usermod root命令
                gpasswd 群组管理员命令
-   /etc/gshadow
            组名:密码(若开头为!或为空则表示无群组管理员):群组管理员账号:群组成员(与group文件相同)
        新增删除
            groupadd -g gid [-r] gname
                -r 系统群组
            groupmod -g gid -n　newname gname
            groupdel gname 只有在没有任何一个账户以该组最为初始组时才能删除
        管理员
            gpasswd (root动作)
                -A user1 gname 将gname的控制交给user1
                -M user1,user2 ganme 将user1，user2 加入ganme
                -r gname 移除密码
                -a user3 gname 添加某人
                -d user1 gname 删除某人

# ========







# 常见

### 时间

-   服务状态
            systemctl status firewalld
            firewall-cmd --state
            service firewalld start/restart/stop
        查询端口是否开放
            firewall-cmd --query-port=8080/tcp
        开放80端口
            firewall-cmd --permanent --add-port=80/tcp
        移除端口
            firewall-cmd --permanent --remove-port=8080/tcp
        重启防火墙(修改配置后要重启防火墙)
            firewall-cmd --reload

#### yum代理

-   外网机器
    yum install squid
    cd /etc/squid/
    cp squid.conf squid.conf_bak #备份文件
    vi squid.conf
    	修改 把`http_access deny all`修改为`http_access allow all`
    #启动
    	squid -k parse
		squid -z
		service squid start
-   内网机器
    vi /etc/profile
    	增加 `export http_proxy="http://[外网机ip]:3128"`
    source /etc/profile
    vi /etc/yum.conf
    	增加 `proxy=http://[外网机ip]:3128`































