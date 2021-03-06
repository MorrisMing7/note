# eureka

intelliJ -> new project -> spring initializer -> 创建eureka-server

#### yml配置

```
server:
  port: 1111
eureka:
  instance:
    hostname: localhost
  client:
    register-with-eureka: false  #不必向注册中心注册自身
    fetch-registry: false    #本身为注册中心，不需要检索服务
    service-url:
      defaultZone: http://localhost:1111/eureka/   
      #不加上面这一行，会出现：Eureka 注册中心一直报Connect to localhost:8761 time out 的问题
```

#### pom配置

```
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.1.7.RELEASE</version>                    <!-- 版本号需要注意 -->
        <relativePath/> <!-- lookup parent from repository -->
    </parent>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>Greenwich.SR2</version>                <!-- 版本号需要注意 -->
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
        </dependency>
    </dependencies>
```



    tip：https://stackoverflow.com/questions/51921033/project-build-error-dependencies-dependency-version-for-org-springframework-c
#### Application类注解

```
@EnableEurekaServer  //加上eureka
@SpringBootApplication
public class CloudtestApplication {...}
```



# 服务提供者 

注册一个服务提供者

#### 配置application.yml

```
spring:
  application:
    name: hello
eureka:
  client:
    service-url:
      defaultZone: http://localhost:1111/eureka
server:
  port: 2111
```


配置pom

```
<dependencies>
...
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-eureka</artifactId>
    </dependency>
    <dependency>
    	<groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>  <!--附加项-->
    </dependency>
</dependencies>
```



#### Application类注解

```
@EnableDiscoveryClient
@SpringBootApplication
public class CloudtestServiceprovider1Application {...}
```



# 注册中心的高可用 

创建application-peer1.yml与apllication-peer2.yml

```
server:
  port: 1111                #1112
spring:
  application:
  name: eureka1           #eureka2
eureka:
  instance:
    hostname: peer1         #peer2
	client:
	#    register-with-eureka: false
	#    fetch-registry: false                      #两个eureka相互注册，故注释掉这里
	  service-url:
	    defaultZone: http://peer2:1112/eureka/    #http://peer2:1112/eureka/
```



#### 启动eureka参数

​    java -jar xxxx.jar --spirng.profiles.active=peer1 
​    java -jar xxxx.jar --spirng.profiles.active=peer2 

#### 服务提供者hello中 yml的改动

```
eureka:
  client:
    service-url:
      defaultZone: http://peer1:1111/eureka, http://peer2:1112/eureka
```

访问http://peer1:1111/可以看到 DS Replicas中有peer2，反之亦然
这样即使peer1挂了，hello仍能被访问到

# 服务消费者

#### 起复数个hello

​    java -jar hello-xxx.jar server.port=2111
​    java -jar hello-xxx.jar server.port=2112

#### 消费者·服务调用者 +ribbon(负载均衡)

​    新建spring boot，包添加web eureka和ribbon

```
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-netflix-ribbon</artifactId>
    </dependency>
```

application.yml除端口外与服务提供者一致

#### Application类添加bean方法

```
        @Bean
        @LoadBalanced
        RestTemplate restTemplate(){return new RestTemplate();}
```

#### 服务调用controller

```
@RestController
public class ConsumerController {
    @Autowired
    RestTemplate restTemplate;
    @GetMapping(value = "/consumer")
    public String consumer(){ 
        return restTemplate.getForEntity("http://hello/hello",String.class).getBody();}
}
```

访问该端口的/consumer接口，即可调用hello/hello返回值

# 断路器

application
    添加 @EnableCircuitBreaker 或
        @SpringCloudApplication //三合一注解

#### 将对hello-service的调用放入一个service
```
@Service
public class HelloService {
    @Autowired
    private RestTemplate restTemplate;

    @HystrixCommand(fallbackMethod = "helloFallback")
    public String helloService(String tmp){
        return restTemplate.getForEntity(
        	"http://hello-service/hello" + "/" + tmp, String.class).getBody();
    }
    public String helloFallback(String tmp){	//要与helloService的签名格式一致
        return "fallback: error";
    }
}
```



















