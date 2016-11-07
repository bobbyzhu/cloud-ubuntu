# https://github.com/kanaka/websockify/wiki/Encrypted-Connections

TOP_DIR=$(cd $(dirname $0) && pwd)

PEM=${TOP_DIR}/noVNC/utils/self.pem

KEY=${TOP_DIR}/tty.js/server.key
CERT=${TOP_DIR}/tty.js/server.crt

[ -n "$AUTO" -a "$AUTO" == "1"  ] && BATCH=-batch

openssl req $BATCH -new -x509 -days 365 -nodes -out $CERT -keyout $KEY

cat $CERT $KEY > $PEM
