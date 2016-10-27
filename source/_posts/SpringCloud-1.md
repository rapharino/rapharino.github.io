---
title: SpringCloud 第一弹 - Spring-cloud-config
date: 2016-10-25 19:40:35
categories :
  - coder
tags:
  - Java
  - 分布式
  - 微服务
---
## 摘要
> 在一个高可用的`微服务架构`中,配置中心 是一个不可或缺的服务,用以集中管理应用程序在 运行时 所需的外部配置.避免了分布式系统所造成的配置无序,繁杂等问题.可配合版本管理系统,实现配置参数的实时推拉的方式刷新,并无需重启.典型应用如`Zookeeper`,百度的`DisConf`,淘宝的`Diamond`,`Spring Cloud Config` …

<!-- more -->
## 选型
之所以选择 `Spring Cloud Config`:
- 社区活跃,更新频繁.
- 无痕衔接 Spring 4 属性管理 API
- 极高的定制化能力.
- 基于`SpringBoot`,天生的适合云服务的开发和部署.

## Spring 属性管理：
其实是在 Spring3.1 就提供了新的属性管理API,功能强大,设计极其具有美感.
### 常见 API
- `PropertySource`：属性源，key-value属性对抽象，比如用于配置数据
- `PropertyResolver`：属性解析器，用于解析相应key的value
- `Environment`：环境，本身是一个PropertyResolver，但是提供了`Profile`特性，即可以根据环境得到相应数据（即激活不同的Profile，可以得到不同的属性数据，比如用于多环境场景的配置（正式机、测试机、开发机DataSource配置））
- `Profile`：剖面，只有激活的剖面的组件/配置才会注册到Spring容器，类似于maven中profile

## 开始构建
### 目录结构
推荐使用 Maven 作为项目构建工具.([如若不了解 SpringBoot](http://www.bysocket.com/?p=1124))
目录如下:
![](http://oextu0tw4.bkt.clouddn.com/14773239279405.jpg)
### Pom 文件
```xml pom.xml
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-config-server</artifactId>
        </dependency>
```

### 创建Main-Class
```java Application.java
/**
 * @see org.springframework.boot.autoconfigure.SpringBootApplication  Annotate SpringBoot Application
 * @see org.springframework.cloud.config.server.EnableConfigServer    Annotate ConfigServer Application
 *
 * Created by Rapharino on 2016/10/02.
 */
@SpringBootApplication
@EnableConfigServer
public class Application {

    private static final Logger LOGGER = LoggerFactory.getLogger(Application.class);

    public static void main(String[] args) {

        ConfigurableApplicationContext configurableApplicationContext = SpringApplication
                .run(Application.class, args);
        Environment environment = configurableApplicationContext.getEnvironment();

        LOGGER.info("Server with active profiles:{} is running at http://{}:{}",environment.getActiveProfiles(),environment.getProperty("server.address"), environment.getProperty("server.port"));
    }
}
```
### 仓储配置
推荐使用 git 作为配置文件的版本管理.
![](http://oextu0tw4.bkt.clouddn.com/14773243182721.jpg)

在 SpringCloud 家族中推荐,YAML 作为外部配置文件的声明语法. 
[推荐阮一峰老师的关于 YAML 的简介](http://www.ruanyifeng.com/blog/2016/07/yaml.html?f=tt)
#### 配置读取顺序
`SpringBoot` 配置使用一个特别的顺序进行合理的配置和覆盖.允许开发者通过配置服务,静态文件,环境变量,命令行参数,注解类等,用以外化配置.覆盖顺序如下:
1. 命令行参数
2. 来自于 java:comp/env 的 JNDI 属性
3. 操作系统环境变量
4. 在打包的 jar 外的配置文件(包括 propertis,yaml,profile变量.)
5. 在打包的 jar 内的配置文件(包括 propertis,yaml,profile变量.)
6. @Configuration 类的@PropertySource 注解
7. 应用框架默认配置

并且可通过新的 Api 进行配置的优雅注入.如:

```java
    @Bean
    @Primary
    @ConfigurationProperties(prefix = "spring.datasource")
    public DataSource dataSource() {
        return new DruidDataSource();
    }
```
## 结尾
代码由 https://github.com/Gexin-Team/cloud-in-action 托管. 出自 Gexin 团队.
### 相关连接
[http://docs.spring.io/spring-boot/docs/1.4.0.RELEASE/reference/html/](http://docs.spring.io/spring-boot/docs/1.4.0.RELEASE/reference/html/)
[http://cloud.spring.io/spring-cloud-static/spring-cloud-config/1.2.0.M1/](http://cloud.spring.io/spring-cloud-static/spring-cloud-config/1.2.0.M1/)
[https://segmentfault.com/a/1190000005029218](https://segmentfault.com/a/1190000005029218)

