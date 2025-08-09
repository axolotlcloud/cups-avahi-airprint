FROM ubuntu:24.04


RUN apt-get update && apt-get install -y \
	locales \
	brother-lpr-drivers-extra \
	brother-cups-wrapper-extra \
	printer-driver-foo2zjs-common \
	printer-driver-splix \
	printer-driver-gutenprint \
	gutenprint-doc \
	gutenprint-locales \
	libgutenprint9 \
	libgutenprint-doc \
	ghostscript \
	hplip \
	cups \
	cups-pdf \
	cups-client \
	cups-filters \
	inotify-tools \
	avahi-daemon \
	avahi-discover \
	python3 \
	python3-dev \
	python3-pip \
	python3-cups \
	wget \
	rsync \
	&& rm -rf /var/lib/apt/lists/*

EXPOSE 631

VOLUME /config
VOLUME /services

ADD root /
RUN chmod +x /root/*

CMD ["/root/run_cups.sh"]

RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
	sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf && \
 	sed -i 's/IdleExitTimeout/#IdleExitTimeout/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf && \
	sed -i 's/.*enable\-dbus=.*/enable\-dbus\=no/' /etc/avahi/avahi-daemon.conf && \
	echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
	echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf && \
	echo "ReadyPaperSizes A4,TA4,4X6FULL,T4X6FULL,2L,T2L,A6,A5,B5,L,TL,INDEX5,8x10,T8x10,4X7,T4X7,Postcard,TPostcard,ENV10,EnvDL,ENVC6,Letter,Legal" >> /etc/cups/cupsd.conf && \
	echo "DefaultPaperSize Letter" >> /etc/cups/cupsd.conf && \
	echo "pdftops-renderer ghostscript" >> /etc/cups/cupsd.conf
