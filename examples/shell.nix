with import <nixpkgs> { };

runCommand "dummy" {
  buildInputs = [
    go_1_8 stdenv protobuf3_0
  ];
  shellHook = ''
    unset SSL_CERT_FILE
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:$PATH
    PATH=$(readlink -f ../../bin):$PATH
  '';
} ""
