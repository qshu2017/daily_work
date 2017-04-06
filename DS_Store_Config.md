禁止.DS_store生成：

defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE

恢復.DS_store生成：

defaults delete com.apple.desktopservices DSDontWriteNetworkStores

刪除已存在的.DS_Store

sudo find . -name ".DS_Store" -depth -exec rm {} \;
