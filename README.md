# A Proxy Cheat

一个转换 Surge 订阅配置文件的小工具。使用 Swift 和 Kitura 框架搭建，运行在最低 macOS 12.4 之上。

# Usage

## Configuration

在环境或 CWD 目录下的 `.env` 文件中设定如下环境变量：

| 变量         | 值                                                          | 必需                 |
| ------------ | ---------------------------------------------------------- | ------------------- |
| URL          | 原始订阅的 URL                                               | 是                  |
| FILE         | 基础的配置文件路径                                            | 是                   |
| PORT         | 监听端口                                                    | 否，默认为 `3000`     |
| HTTPS        | 用于设定 Surge 受管理订阅的 URL，填写 `true` 或 `false`         | 否，默认为 `false`    |
| （其它字段） | 可以用于填入自定义配置文件路径                                     | 否                  |

## Subscribe

可用的 URL param：

| 变量       | 值       | 描述                                            |
| --------- | -------- |----------------------------------------------- |
| ssl       | `on/off` | 用于设定 Surge 受管理订阅的 URL，并覆盖环境变量       |
| replacing | （字段名)  | 从订阅替换基础配置文件的部分，可以重复使用             |

如需要从机场更新 [Proxy] 和 [Proxy Group]，通过以下 URL 订阅：

``http://localhost:3000?replacing=Proxy&replacing=Proxy%20Group``
