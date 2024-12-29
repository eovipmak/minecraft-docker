
# Minecraft Server running in a container!!! Why not?

## 1. Why docker?

- Simplify the "step-by-step configuration" problem.

- Compatible across different environments.

## 2. Requipments

Of course, you need to have docker first, my friend.

| OS  |  |
| ----------- |:-------------:|
| Ubuntu or other Debian-based        | :white_check_mark:     |
| CentOS or other Redhat-based        | :white_check_mark:     |
| Redhat-based                        | :white_check_mark:     |
| Other Linux Distro                      | Not tested     |
| Windows | :x: |

## 3. Getting started

### a. Setting up docker-compose.yml

First, pick your desired server type at [release](https://github.com/eovipmak/minecraft-docker/releases/tag/minecraft-server-docker) then unzip it.

Then run the ```generate-config.sh``` file with the version of minecraft you want:

```
bash generate-config.sh 1.21.3
```

If you need the exact build, please include it

```
bash generate-config.sh 1.21.3 2358
```

If you run the file without any parameters, the script will default to the latest version and build available.

```
bash generate-config.sh
```

### b. Start your minecraft server

Your job now is just to run the command and let docker do its job

```
docker compose up -d --build
```

You can send commands to the server using
```
docker attach <Contaier ID>
```
Then type commands without the / sign.

>If you want to exit, just press **Ctrl + P** and **Crtl + Q**. Never press **Ctrl + C** or your server will be shut down immediately.

And that's it, have fun
