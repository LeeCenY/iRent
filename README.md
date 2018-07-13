# iRent
登记房客信息与收租列表（Perfect框架）


- 编译运行
下列命令行可以克隆并在8080和8181端口编译并启动 HTTP 服务器：
```
git clone https://github.com/LeeCenY/iRent.git
cd iRent
swift build
swift package generate-xcodeproj
```

如果没有问题，输出应该看起来像是这样：
```
[INFO] Starting HTTP server localhost on 0.0.0.0:8181
[INFO] Starting HTTP server localhost on 0.0.0.0:8080
```
这表明服务器已经准备好并且等待连接了。请访问http://localhost:8181/ 来查看欢迎信息。

## 待办事项清单
- iOS 推送消息（APNs）
- 房间图表 API

## License

iRent is available under the MIT license. See the LICENSE file for more info.
