# runtime-gpu

## Introduction
本リポジトリは、GPUを利用したSIGNATE Runtimeのデバッグをするために記述されたDockerfileです。runtime-gpuは、Runtime機能に依存するため、詳しくは[こちら](https://signate.jp/features/runtime/detail)か、もしくは該当するコンペティション詳細をご確認ください。

### SIGNATE Runtimeとは

[SIGNATE](https://signate.jp)で開催されるAIコンペティションで提供される実用的なモデルの作成を目的として精度に加え推論時間の計測も行う機能です。本機能が利用できるコンペティションでは、通常の予測結果ファイルの代わりに、作成したモデル自体と推論部分のソースコードを投稿します。投稿すると自動で予測結果ファイルの作成・評価（精度と推論時間）・結果通知が行われます。

## Dependencies
- Docker Engine バージョン19.03以降
  - GPUを使用するため、 Docker EngineをGPU対応させてください。

※ Docker Engine バージョン19.03未満でも、GPU対応させればデバッグ可能となりますが、コンテナの起動コマンドがお使いのGPUによっては動作しない場合がございます。

## Usage

### コンテナの起動
下記のコマンドを実行することで、コンテナを起動し、Runtimeのデバッグをすることができます。  
このコマンドではカレントディレクトリ以下が `/opt/ml` にマウントされbashを実行します。  
bashを終了するとコンテナが停止します。
```
$ docker run -it -v $(pwd):/opt/ml --gpus all signate/runtime-gpu:latest bash
```

### コンテナの確認
コンテナは、 `docker ps -a` で確認することができます。

例：
```
$ docker ps -a
CONTAINER ID        IMAGE                 COMMAND             CREATED             STATUS                          PORTS               NAMES
e600d6e89eb3        signate/runtime-gpu   "bash"              5 minutes ago       Exited (0) About a minute ago                       upbeat_meitner
```

### コンテナの再開
停止したコンテナを再開させたい場合は、 `docker start -i [COMTAINER ID]` で再開させることができます。

例：
```
$ docker ps -a
CONTAINER ID        IMAGE                 COMMAND             CREATED             STATUS                          PORTS               NAMES
e600d6e89eb3        signate/runtime-gpu   "bash"              5 minutes ago       Exited (0) About a minute ago                       upbeat_meitner

$ docker start -i e600d6e89eb3
```

### コンテナの削除
コンテナの削除を行いたい場合は、 `docker rm [COMTAINER ID]` で削除することができます。

例：
```
$ docker ps -a
CONTAINER ID        IMAGE                 COMMAND             CREATED             STATUS                          PORTS               NAMES
e600d6e89eb3        signate/runtime-gpu   "bash"              5 minutes ago       Exited (0) About a minute ago                       upbeat_meitner

$ docker rm e600d6e89eb3
```

### Dockerイメージの削除
Dockerイメージ自体を削除したい場合は、下記のコマンドを実行してください。
```
$ docker rmi signate/runtime-gpu:latest
```

## MIT License

Copyright (c) 2020 SIGNATE Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
