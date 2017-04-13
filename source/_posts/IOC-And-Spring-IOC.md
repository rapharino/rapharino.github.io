---
title: IOC And Spring IOC
categories:
  - coder
  - spring
date: 2017-04-13 23:05:22
tags:
---
## 摘要

> 从基本概念出发,由浅入深的了解 IOC 和 Spring IOC.

---

<!-- more -->

IOC
---

### Don`t call us,we will call you

好莱坞原则.中文大意为 别来调用我,我来调用你. 恰如其分的说明了 IOC(Inversion of Controll) 的本质. 举个通俗的例子,人们想喝酒, 通常需要自己去选择品种,去取并装杯.但如果是去酒吧,你只需要和柜台服务人员,描述你想喝什么,甚至是一个眼神,就会得到你想喝的酒.这就是控制反转.将 对象的控制权,转移至外部容器,实现与复杂对象的解耦.从主动的 "拉" (创建对象),转为了 "推"(依赖注入).

依赖注入DI(Dependency Injection) 方式

* 构造注入:实例构造方法中,选择并注入所需依赖对象.
* setter 注入:依赖对象对应的setter方法中,选择并注入所需依赖对象.
* 接口注入:易用性和扩展性较差.逐渐淘汰.

### IOC Service Provider

作为一个抽象角色,担当IOC场景下的核心职责,主要包括:

* 对象的构建管理
* 对象的依赖绑定

主流产品包括有 Spring,Google Guice 等, 对于对象的构建管理和依赖绑定主要为三种方式

* 直接编码
* 配置文件
* 元数据

Spring IOC
---

### Spring - IOC Service Provider

Spring 的 IOC 是 IOC Service Provider 的一个实现,并且是一个包含了 AOP,对象查找等高级特性的 一个IOC超集.因此被称为 Spring 的 IOC Container (容器),其关系如下:

![](https://ww4.sinaimg.cn/large/006tKfTcgy1fei4g2c7l7j30sq0lqdiz.jpg)

### BeanFactory

Spring IOC容器的核心接口, 主要的UML如下

![](https://ww2.sinaimg.cn/large/006tKfTcgy1fekbx9sbw8j30kx0dkab7.jpg)

1. BeanFactory: 

   提供了完整的 IOC 服务支持.典型的工厂类,负责对象(POJO)的创建(注册),依赖绑定,查找 等功能.

   ```java
   public interface BeanFactory {
       // 根据名称获取 Bean
       Object getBean(String name) throws BeansException;
     	// 根据类型获取 Bean
       <T> T getBean(Class<T> requiredType) throws BeansException;
   	// 是否为单实例  
       boolean isSingleton(String name) throws NoSuchBeanDefinitionException;
     	// 是否为多实例
       boolean isPrototype(String name) throws NoSuchBeanDefinitionException;
       // 根据实例的名字获取类型 
       Class<?> getType(String name) throws NoSuchBeanDefinitionException;
     	// 根据名称获取别名组
       String[] getAliases(String name);
       ......
   }
   ```

   ​

2. AutowireCapableBeanFactory：

   在BeanFactory基础上实现对已存在实例的管理,提供自动装配(AutoWire,是 Srping 依赖注入的 一种方式.以约定规则进行依赖关系的绑定)等功能性方法.实际开发中较少，像ApplicationContext就未实现该接口。主要用于动态加入 Bean并自动装配 至容器中.

   ```java
   // 部分核心代码
   public interface AutowireCapableBeanFactory extends BeanFactory {

       int AUTOWIRE_NO = 0;//不使用自动装配 
       int AUTOWIRE_BY_NAME = 1;//通过名称自动装配 
       int AUTOWIRE_BY_TYPE = 2;//通过类型自动装配  
       int AUTOWIRE_CONSTRUCTOR = 3;//构造器装配 
     
       // 根据给定的类型和指定的装配策略，创建一个新的Bean实例
       Object createBean(Class<?> beanClass, int autowireMode, boolean dependencyCheck) throws BeansException;
       //为已存在Bean 自动装配
       void autowireBeanProperties(Object existingBean, int autowireMode, boolean dependencyCheck) throws BeansException; 
       //为指定类和名称 自动装配
       void applyBeanPropertyValues(Object existingBean, String beanName) throws BeansException;
       //初始化一个Bean
       Object initializeBean(Object existingBean, String beanName) throws BeansException;
       //初始化之前执行BeanPostProcessors
       Object applyBeanPostProcessorsBeforeInitialization(Object existingBean, String beanName) throws BeansException;
       //初始化之后执行BeanPostProcessors
       Object applyBeanPostProcessorsAfterInitialization(Object existingBean, String beanName) throws BeansException;
       //销毁一个Bean
       void destroyBean(Object existingBean);
       //分解指定的依赖
       Object resolveDependency(DependencyDescriptor descriptor, String beanName,
               Set<String> autowiredBeanNames, TypeConverter typeConverter) throws BeansException;
   }
   ```

   ​

3. HierarchicalBeanFactory：

   提供父容器的访问支持.

   ```java
   public interface HierarchicalBeanFactory extends BeanFactory {
     	// 获取父的BeanFactory
   	BeanFactory getParentBeanFactory();
   	// 在本地容器查找是否存在指定名称的 Bean.
   	boolean containsLocalBean(String name);

   }
   ```

   ​

4. ListableBeanFactory：

   主要是 提供了批量获取Bean的方法.

   ```java
   public interface ListableBeanFactory extends BeanFactory {
   	// 根据类型查找 Bean 的名称数组
       String[] getBeanNamesForType(Class<?> type); 
   	// 根据类型查找 Bean 的Map
       <T> Map<String, T> getBeansOfType(Class<T> type) throws BeansException; 
       //根据注解查找相关Bean 名称数组
       String[] getBeanNamesForAnnotation(Class<? extends Annotation> annotationType); 
       //根据注解查找相关Bean的 Map
       Map<String, Object> getBeansWithAnnotation(Class<? extends Annotation> annotationType) throws BeansException; 
       //查找一个Bean上的注解
       <A extends Annotation> A findAnnotationOnBean(String beanName, Class<A> annotationType) throws NoSuchBeanDefinitionException; 
   }
   ```

### BeanDefinitionRegistry

该类的作用主要是向注册表中注册 BeanDefinition 实例，完成 注册的过程。

```java
public interface BeanDefinitionRegistry extends AliasRegistry {

    // 往注册表中注册一个新的 BeanDefinition 实例 
    void registerBeanDefinition(String beanName, BeanDefinition beanDefinition)throws BeanDefinitionStoreException;
    // 移除注册表中已注册的 BeanDefinition 实例
    void removeBeanDefinition(String beanName) throws NoSuchBeanDefinitionException;
    // 从注册中取得指定的 BeanDefinition 实例
    BeanDefinition getBeanDefinition(String beanName) throws NoSuchBeanDefinitionException;
    // 判断 BeanDefinition 实例是否在注册表中（是否注册）
    boolean containsBeanDefinition(String beanName);
    // 取得注册表中所有 BeanDefinition 实例的 beanName（标识）
    String[] getBeanDefinitionNames();
    // 返回注册表中 BeanDefinition 实例的数量
    int getBeanDefinitionCount();
    // beanName（标识）是否被占用
    boolean isBeanNameInUse(String beanName);
}
```

### BeanDefinition

用于保存容器中受管对象的所有必要信息.包括类型,构造参数,属性参数,以及 Bean生命周期相关参数 等等.往往由BeanDefinitionReader 来完成BeanDefinition的解析和创建.

### DefaultListableBeanFactory

作为Spring IOC 的鼻祖,一个真正可用的一个 BeanFactory的是一个实现.(现在应用较少). 继承了BeanFactory,BeanDefinitionRegistry. 举个例子我们可以大致了解雏形了.

```java
public static void main(String[] args)  {
    // 创建 BeanFactory
    DefaultListableBeanFactory beanRegistry = new DefaultListableBeanFactory();   
    // 创建 BeanDefinition
    AbstractBeanDefinition userDefinition = new RootBeanDefinition(User.class,true);   
    AbstractBeanDefinition carDefinition = new RootBeanDefinition(Car.class,true);   
    // 注册到 BeanFactory
    beanRegistry.registerBeanDefinition("user", userDefinition);   
    beanRegistry.registerBeanDefinition("car", carDefinition);
    // 1.通过构造注入 方式
    ConstructorArgumentValues argValues = new ConstructorArgumentValues();   
    argValues.addIndexedArgumentValue(0, carDefinition); 
    userDefinition.setConstructorArgumentValues(argValues);
    // 2. 或者通过setter方法注入方式   
    MutablePropertyValues propertyValues = new MutablePropertyValues();   
    propertyValues.addPropertyValue(new ropertyValue("car",carDefinition)); 
    userDefinition.setPropertyValues(propertyValues);
  
  	// 完成构建,应用
    beanRegistry.getBean("user").getCar();
} 
```

可以看出来,BeanDefinition 是整个 容器的核心.描述了对象创建和依赖绑定的 必要信息.

原生硬编码的方式,需要手动定义BeanDefinition,并且需要设置依赖注入关系.编码成本较高. 而上文我们提到 IOS Service Provide 包活 直接编码,配置文件,元数据 等方式实现. Spring BeanDefinitionReader 接口就是提供了配置文件方式构建容器.截至 Spring 4.x ,实现类有 GroovyBeanDefinitionReader,PropertiesBeanDefinitionReader,XmlBeanDefinitionReader.以 XML 为例

```java
public static void main(String[] args)  {
  // 创建 BeanFactory
  DefaultListableBeanFactory beanRegistry = new DefaultListableBeanFactory(); 
  // 创建 XmlBeanDefinitionReader
  XmlBeanDefinitionReader reader = new XmlBeanDefinitionReader(registry);  
  // 配置资源解析
  reader.loadBeanDefinitions("classpath:spring.xml");  
  // 获取 Bean
  User user = (User)container.getBean("user");  
  user.getCar();
}   
```

