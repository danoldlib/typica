/*249:*/
#line 33 "./abouttypica.w"

#include "abouttypica.h"

/*250:*/
#line 42 "./abouttypica.w"

AboutTypica::AboutTypica():QMainWindow(NULL)
{
QFile aboutFile(":/resources/html/about.html");
aboutFile.open(QIODevice::ReadOnly);
QByteArray content= aboutFile.readAll();
TypicaWebView*banner= new TypicaWebView;
banner->setHtml(content,QUrl("qrc:/resources/html/about.html"));
aboutFile.close();
setCentralWidget(banner);
}

#line 5992 "./typica.w"

/*:250*/
#line 36 "./abouttypica.w"


/*:249*/
