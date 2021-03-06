## jvm参数

-   标准参数 ```-```  所有的JVM实现都必须实现这些参数的功能，而且向后兼容；

    ```
    -verbose:class 输出jvm载入类的相关信息，当jvm找不到类或者类冲突时可此进行诊断
    -verbose:gc    输出每次GC的相关情况。
    -verbose:jni   输出native方法调用的相关情况，一般用于诊断jni调用错误信息。
    ```

-    非标准参数  ```-X``` ，默认jvm实现这些参数的功能，但是并不保证所有jvm实现都满足，且不保证向后兼容

    ```
    -Xms512m  设置JVM促使内存为512m。此值可以设置与-Xmx相同， 
              以避免每次垃圾回收完成后JVM重新分配内存。
    -Xmx512m  设置JVM最大可用内存为512M。
    -Xmn200m  设置年轻代大小为200M。整个堆大小=年轻代 + 年老代 + 持久代。
              持久代一般固定大小为64m，所以增大年轻代后，将会减小年老代大小。
              此值对系统性能影响较大，Sun官方推荐配置为整个堆的3/8。
    -Xss128k  设置每个线程的栈大小。JDK5.0以后每个线程栈大小为1M，之前每个线程栈大小为256K。
              不应大于2M
    ```

-   非Stable参数```-XX```，此类参数各个jvm实现会有所不同，将来可能会随时取消，需要慎重使用；

    ```
    -XX:NewSize=1024m：设置年轻代初始值为1024M。
    -XX:MaxNewSize=1024m：设置年轻代最大值为1024M。
    -XX:PermSize=256m：设置持久代初始值为256M。
    -XX:MaxPermSize=256m：设置持久代最大值为256M。
    -XX:NewRatio=4：设置年轻代（包括1个Eden和2个Survivor区）与年老代的比值。
                    表示年轻代比年老代为1:4。
    -XX:SurvivorRatio=6：设置年轻代中Eden区与Survivor区的比值。表示2个Survivor区
        （JVM堆内存年轻代中默认有2个大小相等的Survivor区）与1个Eden区的比值为2:6，
        即1个Survivor区占整个年轻代大小的1/8。
    -XX:MaxTenuringThreshold=7：表示一个对象如果在Survivor区（救助空间）移动了7次还没有被垃圾回收
        就进入年老代。如果设置为0的话，则年轻代对象不经过Survivor区，直接进入年老代，
        对于需要大量常驻内存的应用，这样做可以提高效率。如果将此值设置为一个较大值，
        则年轻代对象会在Survivor区进行多次复制，这样可以增加对象在年轻代存活时间，
        增加对象在年轻代被垃圾回收的概率，减少Full GC的频率，这样做可以在某种程度上提高服务稳定性。
        如果将此值设置为一个较大值，则年轻代对象会在Survivor区进行多次复制，这样可以增加对象再年轻代的存活时间，增加在年轻代即被回收的概率。根据被海量访问的动态Web应用之特点，其内存要么被缓存起来以减少直接访问DB，要么被快速回收以支持高并发海量请求，因此其内存对象在年轻代存活多次意义不大，可以直接进入年老代，根据实际应用效果，在这里设置此值为0。
    -XX:-CITime：打印消耗在JIT编译的时间。
    -XX:ErrorFile=./hs_err_pid.log：保存错误日志或数据到指定文件中。
    -XX:HeapDumpPath=./java_pid.hprof：指定Dump堆内存时的路径。
    -XX:-HeapDumpOnOutOfMemoryError：当首次遭遇内存溢出时Dump出此时的堆内存。
    -XX:OnError=";"：出现致命ERROR后运行自定义命令。
    -XX:OnOutOfMemoryError=";"：当首次遭遇内存溢出时执行自定义命令。
    -XX:-PrintClassHistogram：按下 Ctrl+Break 后打印堆内存中类实例的柱状信息，
        同JDK的 jmap -histo 命令。
    -XX:-PrintConcurrentLocks：按下 Ctrl+Break 后打印线程栈中并发锁的相关信息，
        同JDK的 jstack -l 命令。
    -XX:-PrintCompilation：当一个方法被编译时打印相关信息。
    -XX:-PrintGC：每次GC时打印相关信息。
    -XX:-PrintGCDetails：每次GC时打印详细信息。
    -XX:-PrintGCTimeStamps：打印每次GC的时间戳。
    -XX:-TraceClassLoading：跟踪类的加载信息。
    -XX:-TraceClassLoadingPreorder：跟踪被引用到的所有类的加载信息。
    -XX:-TraceClassResolution：跟踪常量池。
    -XX:-TraceClassUnloading：跟踪类的卸载信息。
    ```

## 内存模型

-   程序计数器：下一行字节码指令的位置，执行本地方法时此处为空
-   虚拟机栈：  栈帧的进栈与出栈对应这方法的调用与返回，
                    栈帧中：局部变量表，操作数栈，动态链接方法出口，等
                    方法需要的局部变量表大小是已经确定的。
    -    局部变量表：boolean,byte,char,short,int,float,long,double,以及reference
                        和returnAddress(一条字节码指令的地址)
-   本地方法栈：与虚拟机栈相似，为非java字节码服务
-    java堆：线程共享的，存放对象实例
-   方法区：线程共享的，存放已被加载的类信息，常量，静态变量，即时编译器编译的代码。
    -   常量池：属于方法区，class文件中包含类的版本，字段，方法，接口的描述信息，
                    还有就是常量池，用于存放编译期生成的各种字面量和符号引用，此项信息在
                    类加载后进入方法区。
                    String的intern方法也可能将新常量加入此处
-    直接内存：NIO类中基于通道channel与缓冲区buffer的I/O方式，使用本地方法直接分配
                堆外内存

### 对象头

-   对象头信息参加notes/java/concurrent/concurrent.md

## 垃圾回收

#### 对象已死

-   引用计数
-   可达分析：GCRoot对象：
    虚拟机栈或本地方法栈中本地变量表中的对象，
    方法区静态变量或常量引用的对象，

#### 引用类型

-   强引用：Object obj=new Object()
-   软引用：在内存溢出之前，二次回收这种引用关联的对象
-   弱引用：下次垃圾回收直接回收
-   虚引用：不会对生存时间构成影响，有没有没关系

#### 垃圾回收算法

-   标记清除：统一标记再清除，会产生大量内存碎片
-   标记整理：先标记，再将所有存活对象向内存的一端移动
-   复制：划分相等的两块区域，先使用其中一块，当此块用完，即将存活的对象复制到
    另一块中，清除当前一整块。

#### GC

-   GC日志

    ```
[GC (Allocation Failure) [PSYoungGen: 7097K->992K(9216K)] 7097K->4977K(19456K), 0.0051296 secs]
[Full GC (Ergonomics) [PSYoungGen: 9184K->0K(9216K)] [ParOldGen: 10232K->9790K(10240K)] 19416K->9790K(19456K), [Metaspace: 2509K->2509K(1056768K)], 0.1063027 secs] [Times: user=0.40 sys=0.00, real=0.11 secs] 
    ```

Full GC表示发生了stop-the-world, ()中是触发GC的源头，如(System)表示System.gc()
    [PSYoungGen:表示发生GC的区域。与回收器相关，此处是Parallel Scanvenge收集器在新生代

## 双亲委派

![image-20200304105136822](jvm.assets/双亲委派.png)

被不同加载器加载的类即使完全相同也会被认为是不同的类

#### 作用

-   防止重复加载同一个类
-   保证核心类不被篡改






















