FROM buildpack-deps:jessie-scm

RUN apt-get update && \
    apt-get -y install curl unzip git make gcc ed bison

ENV GOROOT /usr/local/go
ENV GOBIN  /usr/local/bin

RUN git clone https://go.googlesource.com/go $GOROOT && \
    cd $GOROOT && git checkout weekly.2009-11-10

ENV GOOS linux
ENV GOARCH amd64

RUN cd $GOROOT/src && ./make.bash

RUN chmod +x $GOBIN/6c $GOBIN/6a $GOBIN/6g $GOBIN/6l $GOBIN/cgo

ENV HOME /home/gopher
ENV GOPATH $HOME
ENV PATH $PATH:$GOBIN

RUN mkdir -p $GOPATH/hello && \
    cd $GOPATH/hello

RUN echo 'package main\n\n\
import "fmt"\n\n\
func main() {\n\
	fmt.Printf("hello, world")\n\
}\n'\
>> $GOPATH/hello/hello.go

WORKDIR /home/gopher/hello
ENTRYPOINT /bin/bash