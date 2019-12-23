FROM intersystems/iris:2019.4.0.383.0

ARG COMMIT_ID="unknown"

#USER root
# ENV DEBIAN_FRONTEND noninteractive
### leave tzdata package to allow choosing arbitary timezone, later
#RUN apt-get update && apt-get install -y tzdata
### IRIS itself doesn't require ja language pack
#RUN apt-get install -y language-pack-ja && update-locale LANG=ja_JP.UTF-8

USER irisowner

ENV SRCDIR=src
COPY project/ $SRCDIR/

# loading the same installer class into both USER and MYAPP, becuase USER becomes unreachable when Durable SYS is enabled
RUN iris start $ISC_PACKAGE_INSTANCENAME \ 
 && printf 'Do ##class(Config.NLS.Locales).Install("jpuw") h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && printf 'Set tSC=$system.OBJ.Load("'$HOME/$SRCDIR'/MyInstallerPackage/Installer.cls","ck") Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME \
 && printf 'Set tSC=##class(MyInstallerPackage.Installer).setup() Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly

###RUN /usr/irissys/dev/Container/imageBuildSteps.sh
### stop using it because there is no way to make unpriv users untouched (always forced to cange password)
RUN iris start $ISC_PACKAGE_INSTANCENAME nostu quietly \
 && printf "kill ^%%SYS(\"JOURNAL\") kill ^SYS(\"NODE\") Do INT^SHUTDOWN" | irissession $ISC_PACKAGE_INSTANCENAME -B | cat \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/iris.ids \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/alerts.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal/* \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/messages.log

USER root
# cpf merger is not yet ready.
RUN sed -ie 's/globals=0,0,0,0,0,0/globals=0,0,64,0,0,0/' $ISC_PACKAGE_INSTALLDIR/iris.cpf && chown irisowner:irisuser $ISC_PACKAGE_INSTALLDIR/iris.cpf
RUN rm -rf $SRCDIR
USER irisowner
RUN echo $COMMIT_ID > $HOME/commit.txt
