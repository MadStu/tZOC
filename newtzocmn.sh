mkdir zeroonetest
cd zeroonetest
wget https://github.com/MadStu/tZOC/raw/master/zerooned-old
mv zerooned-old zerooned
wget https://github.com/MadStu/tZOC/raw/master/zeroone-cli
chmod 777 zerooned
chmod 777 zeroone-cli
mkdir ../.zeroonecore
EXIP=$(curl ipinfo.io/ip)
printf "rpcuser=yesme\nrpcpassword=f5hanfsdfia\nrpcallowip=127.0.0.1\nlisten=1\nserver=1\ndeamon=1\nlogtimestamps=1\nmaxconnections=256\ntestnet=1\n\nexternalip=$EXIP\nbind=$EXIP:10001\n\naddnode=80.211.209.75:10001\naddnode=80.211.134.175:10001\naddnode=199.247.28.109:10001\naddnode=185.33.145.138:10001\naddnode=80.211.219.176:10001\naddnode=94.177.170.193:10001\naddnode=80.211.187.187:10001\n\n" > /$HOME/.zeroonecore/zeroone.conf
./zerooned --daemon --datadir=$HOME/.zeroonecore
sleep 10
MKEY=$(./zeroone-cli masternode genkey)
./zeroone-cli stop
echo -e "masternode=1\nmasternodeprivkey=$MKEY\n\n" >> /$HOME/.zeroonecore/zeroone.conf
sleep 2
./zerooned --daemon --datadir=$HOME/.zeroonecore
sleep 60
./zeroone-cli mnsync status
echo " "
echo "For windows wallet masternode.conf:"
echo "MN1 $EXIP:10001 $MKEY TXID VOUT"
