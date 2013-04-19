DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
/usr/local/bin/iced --compile $DIR/..
/usr/local/bin/node $@
