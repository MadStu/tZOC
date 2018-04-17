mkdir zeroonetest
cd zeroonetest
wget https://github.com/MadStu/tZOC/raw/master/zerooned
wget https://github.com/MadStu/tZOC/raw/master/zeroone-cli
chmod 777 zerooned
chmod 777 zeroone-cli
mkdir ../.zeroonecore
EXIP=$(curl ipinfo.io/ip)
printf "rpcuser=yesme\nrpcpassword=f5hanfsdfia\nrpcallowip=127.0.0.1\nlisten=1\nserver=1\ndeamon=1\nlogtimestamps=1\nmaxconnections=256\ntestnet=1\n\nexternalip=$EXIP\nbind=$EXIP:10001\n\naddnode=94.177.214.132:10001\n\n" > /$HOME/.zeroonecore/zeroone.conf
./zerooned --daemon --datadir=$HOME/.zeroonecore
sleep 10
MKEY=$(./zeroone-cli masternode genkey)
./zeroone-cli stop
echo -e "masternode=1\nmasternodeprivkey=$MKEY\n\n" >> /$HOME/.zeroonecore/zeroone.conf
sleep 30
./zerooned --daemon --datadir=$HOME/.zeroonecore





clear
echo "==============================="
echo "==                           =="
echo "==  MadStu's Reindex Script  =="
echo "==                           =="
echo "==============================="
echo " "
if [ -e getinfo.json ]
then
	echo "Script running already"
else
echo "blah" > getinfo.json
./zeroone-cli stop
sleep 5
cd ~/.zeroonecore
rm mncache.dat
rm mnpayments.dat
cd ~/zeroonetest
./zerooned -daemon -reindex
sleep 2
ARRAY=$(./zeroone-cli getinfo)
echo "$ARRAY" > getinfo.json
BLOCKCOUNT=$(curl https://testexplorer.01coin.io/api/getblockcount)
WALLETBLOCKS=$(jq '.blocks' getinfo.json)
while [ "$menu" != 1 ]; do
	case "$WALLETBLOCKS" in
		"$BLOCKCOUNT" )      
			echo "Complete!"
			menu=1
			break
			;;
		* )
			clear
			echo " "
			echo " "
			echo "  Keep waiting..."
			echo " "
			echo "  Blocks required: $BLOCKCOUNT"
			echo "    Blocks so far: $WALLETBLOCKS"
			sleep 60
			BLOCKCOUNT=$(curl https://testexplorer.01coin.io/api/getblockcount)
			ARRAY=$(./zeroone-cli getinfo)
			echo "$ARRAY" > getinfo.json
			WALLETBLOCKS=$(jq '.blocks' getinfo.json)
			;;
	esac
done
echo "Now wait for AssetID: 999..."
sleep 3
MNSYNC=$(./zeroone-cli mnsync status)
echo "$MNSYNC" > mnsync.json
ASSETID=$(jq '.AssetID' mnsync.json)
echo "Current Asset ID: $ASSETID"
ASSETTARGET=999
while [ "$meanu" != 1 ]; do
	case "$ASSETID" in
		"$ASSETTARGET" )      
			clear
			echo " "
			echo " "
			echo "  No more waiting :) "
			echo " "
			echo "  AssetID: $ASSETID"
			sleep 2
			meanu=1
			break
			;;
		* )
			clear
			echo " "
			echo " "
			echo "  Keep waiting... "
			echo " "
			echo "  AssetID: $ASSETID"
			sleep 10
			MNSYNC=$(./zeroone-cli mnsync status)
			echo "$MNSYNC" > mnsync.json
			ASSETID=$(jq '.AssetID' mnsync.json)
			;;
	esac
done
rm mnsync.json
echo " "
echo " "
./zeroone-cli mnsync status
echo " "
echo " "
echo "  You can now Start Alias in the windows wallet!"
rm getinfo.json

fi





echo " "
THISHOST=$(hostname -f)
echo "For windows wallet masternode.conf:"
echo "$THISHOST $EXIP:10001 $MKEY TXID VOUT"
