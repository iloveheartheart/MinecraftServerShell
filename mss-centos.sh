#!/bin/bash
echo "                        Minecraft Server Panel"
echo "                        MC一键开服面板 Ubuntu"
echo "                        Created By idkwhoim"
echo "    GitHub https://github.com/idkwhoim/MinecraftServerPanel"
echo "                         [1]  安装服务器"
echo "                         [2]  服务器控制"
echo "                         [3]  服务器设置"
FREEMEM=`free -m | grep Mem: | awk '{print $7}'`
SMIN=`expr $FREEMEM / 2`
SMAX=`expr $FREEMEM - 200`
DIRECTORY=`pwd`
read -p "请输入您的选项(1-3):" CHOICE1
if [ $USER=root ]
    then case $CHOICE1 in
         1)           
             FREEMEM=`free -m | grep Mem: | awk '{print $7}'`
             SMIN=`expr $FREEMEM / 2`
             SMAX=`expr $FREEMEM - 200`
             yum install wget java -y
             read -p "请输入服务器创建目录(默认本目录)" DIRECTORY
             [ -z "$DIRECTORY" ] && DIRECTORY=`pwd`
             read -p "请输入游戏版本" GAMEVERSION
             read -p "请输入最小内存(建议内存为$SMIN):" MINMEM
             [ -z "$MINMEM" ] && MINMEM=$SMIN
             read -p "请输入最大内存(建议内存为$SMAX):" MAXMEM
             [ -z "$MAXMEM" ] && MAXMEM=$SMAX
             wget -P $DIRECTORY https://s3.amazonaws.com/Minecraft.Download/versions/$GAMEVERSION/minecraft_server.$GAMEVERSION.jar -q
             touch eula.txt
             echo "eula=true" >> eula.txt
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
                      ALLVERSION=`find -name "minecraft_server.*.jar" | wc -l`
                      if [ $ALLVERSION -eq 1 ]
                          then case $CHOICE2 in
                               1)
                                   nohup java -Xms$MINMEM\m -Xmx$MAXMEM\m -jar minecraft_server.*.jar nogui &>> server.log &
                                   if [ $? -eq 0 ]
                                       then echo "服务器开启成功，你可以关闭窗口了"
                                       else echo "服务器开启失败!"
                                   fi
                                   ;;
                               *)
                                   exit
                                   ;;
                               esac
                          else if [ $ALLVERSION -eq 0 ]
                                   then echo "本目录下未找到服务端"
                                   exit
                               fi
                               read -p "有多个版本 请输入版本:" MULTIVERSION
                               nohup java -Xms$MINMEM\m -Xmx$MAXMEM\m -jar minecraft_server.$MULTIVERSION.jar nogui &>> server.log &
                                   if [ $? -eq 0 ]
                                       then echo "服务器开启成功，你可以关闭窗口了"
                                       else echo "服务器开启失败!"
                                   fi
                      fi
                 else read -p "服务器正在运行 输入1关闭服务器:" CHOICE3
                      case $CHOICE3 in
                          1)
                              kill $SERVERPID
                              echo "服务器关闭成功"
                              ;;
                          *)
                              exit
                              ;;
                      esac
             fi
             ;;
         3)
             read -p "请输入要配置的服务器目录(默认本目录)"
             vim $DIRECTORY/server.properties
             ;;
         *)
             echo "请输入1-3的字符!"
             ;;
         esac
    else echo "请在root用户下使用本命令! (sudo -i)"
fi
