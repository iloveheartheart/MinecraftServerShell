#!/bin/bash
echo "                        Minecraft Server Shell"
echo "                        MC一键开服面板 Ubuntu"
echo "                        Created By idkwhoim"
echo "    GitHub https://github.com/idkwhoim/MinecraftServerShell"
echo "                         [1]  安装服务器"
echo "                         [2]  服务器管理"
echo "                         [3]  服务器设置"
echo "                         [4]   查看日志"
FREEMEM=`free -m | grep Mem: | awk '{print $7}'`
SMIN=`expr $FREEMEM / 2`
SMAX=`expr $FREEMEM - 200`
DIRECTORY=`pwd`
read -p "请输入您的选项(1-3):" CHOICE1
if [ $USER=root ]
    then case $CHOICE1 in
         1)
             yum install wget java -y >> /dev/null
             read -p "请输入服务器创建目录(默认本目录)" DIRECTORY
             [ -z "$DIRECTORY" ] && DIRECTORY=`pwd`
             read -p "请输入游戏版本" GAMEVERSION
             read -p "请输入最小内存(默认建议内存为$SMIN):" MINMEM
             [ -z "$MINMEM" ] && MINMEM=$SMIN
             read -p "请输入最大内存(默认建议内存为$SMAX):" MAXMEM
             [ -z "$MAXMEM" ] && MAXMEM=$SMAX
             echo "正在下载服务端，请不要操作"
             wget -P $DIRECTORY https://s3.amazonaws.com/Minecraft.Download/versions/$GAMEVERSION/minecraft_server.$GAMEVERSION.jar -q
             touch $DIRECTORY\eula.txt
             echo "eula=true" >> $DIRECTORY\eula.txt
             nohup java -Xms$MINMEM\m -Xmx$MAXMEM\m -jar $DIRECTORY/minecraft_server.$GAMEVERSION.jar nogui &>> server.log &
             if [ $? -eq 0 ]
                 then echo "服务器开启成功，你可以关闭窗口了"
                 else echo "服务器开启失败!"
             fi
             ;;
         2) 
             SERVERPID=`pidof java`
             if [ -z "$SERVERPID" ]
                 then read -p "服务器未开启，输入1开启:" CHOICE2
                      if [ $CHOICE2 -eq 1 ]
                          then read -p "请输入服务器创建目录(默认本目录)" DIRECTORY                     
                               read -p "请输入最小内存(默认建议内存为$SMIN):" MINMEM
                               [ -z "$MINMEM" ] && MINMEM=$SMIN
                               read -p "请输入最大内存(默认建议内存为$SMAX):" MAXMEM
                               [ -z "$MAXMEM" ] && MAXMEM=$SMAX
                               ALLVERSION=`find -name "$DIRECTORY/minecraft_server.*.jar" | wc -l`
                               if [ $ALLVERSION -eq 1 ]
                                   then nohup java -Xms$MINMEM\m -Xmx$MAXMEM\m -jar $DIRECTORY/minecraft_server.*.jar nogui &>> server.log &
                                        if [ $? -eq 0 ]
                                            then echo "服务器开启成功，你可以关闭窗口了"
                                            else echo "服务器开启失败!"
                                        fi
                                   else if [ $ALLVERSION -eq 0 ]
                                           then echo "目录下未找到服务端"
                                           else echo "有多个服务端"
                                        fi
                               fi       
                          else read -p "服务器正在运行 输入1关闭服务器:" CHOICE3
                               if [ $CHOICE3 -eq 1 ]
                                   then kill $SERVERPID
                                        echo "关闭成功"
                                   else exit
                               fi
                      fi
             fi
             ;;
         3)
             read -p "请输入要配置的服务器目录(默认本目录)"
             vim $DIRECTORY/server.properties
             ;;
         4)
             read -p "请输入服务器创建目录(默认本目录)" DIRECTORY
             cat $DIRECTORY/server.log >> /dev/null
             if [ $? -eq 1 ]
                then echo "本目录下未找到日志 请使用cd命令转入服务器安装目录"
                else cat DIRECTORY/server.log
             fi
             ;;
         *)
             echo "请输入1-3的字符!"
             ;;
         esac
    else echo "请在root用户下使用本命令! (sudo -i)"
fi
