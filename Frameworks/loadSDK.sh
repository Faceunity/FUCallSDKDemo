#!/bin/sh
#

# 加载各个模块SDK
# 版本号如下
echo "|-------------------------------sdk version--------------------------------|"
ILiveSDKVersion="ILiveSDK_1.8.4.13487"
TILCallSDKVersion="TILCallSDK_1.1.0.13506"
IMSDKSDKVersion="IMSDK_2.5.6.11389.11327"
AVSDKVersion="AVSDK_1.9.8.8.36687"

echo $ILiveSDKVersion
echo $IMSDKSDKVersion
echo $AVSDKVersion
echo $TILCallSDKVersion

#清除现有文件
echo "|-------------------------------clear sdk dir...--------------------------------|"
# 移除 除了LoadSDK.sh这个文件以外的所有文件
#  ls |grep -v LoadSDK.sh |xargs rm -rf

# 移除SDK相关文件夹
rm -rf AVSDK
rm -rf ILiveSDK
rm -rf IMSDK
rm -rf TILCallSDK

#下载sdk zip文件
echo "|-------------------------------download AVSDK----------------------------------|"
curl -o AVSDK.zip "http://dldir1.qq.com/hudongzhibo/ILiveSDK/$AVSDKVersion.zip" --max-time 600 --retry 5
echo "|-------------------------------download IMSDK----------------------------------|"
curl -o IMSDK.zip "http://dldir1.qq.com/hudongzhibo/ILiveSDK/$IMSDKSDKVersion.zip" --retry 5
echo "|-------------------------------download ILiveSDK-------------------------------|"
curl -o ILiveSDK.zip "http://dldir1.qq.com/hudongzhibo/ILiveSDK/$ILiveSDKVersion.zip" --retry 5
echo "|-------------------------------download TILCallSDK-------------------------------|"
curl -o TILCallSDK.zip "http://dldir1.qq.com/hudongzhibo/ILiveSDK/$TILCallSDKVersion.zip" --retry 5

echo "|-------------------------------download Successful-----------------------------|"

#解压zip文件
echo "|-------------------------------unzip ILiveSDK----------------------------------|"
unzip ILiveSDK.zip -x __MACOSX/*
echo "|-------------------------------unzip IMSDK-------------------------------------|"
unzip IMSDK.zip -x __MACOSX/*
echo "|-------------------------------unzip AVSDK-------------------------------------|"
unzip AVSDK.zip -x __MACOSX/*
echo "|-------------------------------unzip TILCallSDK---------------------------------|"
unzip TILCallSDK.zip -x __MACOSX/*

#移除zip文件
echo "|-------------------------------remove zip--------------------------------------|"
rm -rf AVSDK.zip
rm -rf ILiveSDK.zip
rm -rf IMSDK.zip
rm -rf TILCallSDK.zip
