# Panda看书

一款 Flutter 写的小说 App
---

## Show

### gif
<image src="https://github.com/q805699513/flutter_books/blob/master/doc/g1.gif?raw=true" width="300px"/>  <image src="https://github.com/q805699513/flutter_books/blob/master/doc/g2.gif?raw=true" width="300px"/>

### image

<image src="https://github.com/q805699513/flutter_books/blob/master/doc/image1.png?raw=true" width="250px"/>  <image src="https://github.com/q805699513/flutter_books/blob/master/doc/image2.png?raw=true" width="250px"/>  <image src="https://github.com/q805699513/flutter_books/blob/master/doc/image3.png?raw=true" width="250px"/>

<image src="https://github.com/q805699513/flutter_books/blob/master/doc/image4.png?raw=true" width="250px"/>  <image src="https://github.com/q805699513/flutter_books/blob/master/doc/image5.png?raw=true" width="250px"/>  <image src="https://github.com/q805699513/flutter_books/blob/master/doc/image6.png?raw=true" width="250px"/>

<image src="https://github.com/q805699513/flutter_books/blob/master/doc/image7.png?raw=true" width="250px"/>  <image src="https://github.com/q805699513/flutter_books/blob/master/doc/image8.png?raw=true" width="250px"/>  <image src="https://github.com/q805699513/flutter_books/blob/master/doc/image9.png?raw=true" width="250px"/>

---

## Usage

### git

```groovy
https://github.com/q805699513/flutter_books.git

```
### 项目结构

<image src="https://github.com/q805699513/flutter_books/blob/master/doc/lib.png?raw=true" width="330px"/>

| 目录        |                    描述                                | 
| -----------| --------------------------------- | 
| data       |  网络请求封装 [Dio](https://github.com/flutterchina/dio)   | 
| db         | 书架数据库封装 [sqflite](https://github.com/tekartik/sqflite)   |
| event      | 事件总线 [dart-event-bus](https://github.com/marcojakob/dart-event-bus)   |
| res        | 将 colors、dimens、style 等写在该目录下   |
| ui          | ui 界面   |
| ui.bookshelf | 书架页面   |
| ui.details   | 小说详情、章节、内容页   |
| ui.home      | 首页 tab 书城页面   |
| ui.me        | 首页 tab 我的页面  |
| ui.search    | 小说搜索页面   |
| ui.splash    | 小说启动引导页   |
| util   | 工具类   |
| widget   | 自定义 view   |

### 下载

[点击下载](http://lshappdemo.file.alimmdn.com/video/books.apk)

#### 二维码下载（Android）

<image src="https://github.com/q805699513/flutter_books/blob/master/doc/download.png?raw=true" width="200px"/>

### 版本记录

#### v1.0.0：2019-08-06
*  小说 app 初始版

### TODO

  更换另一个爬虫小说源，目前暂时使用的[追书api](https://juejin.im/entry/593a3fdf61ff4b006c737ca4)。（进行中）
  
  
## License
```text

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```



