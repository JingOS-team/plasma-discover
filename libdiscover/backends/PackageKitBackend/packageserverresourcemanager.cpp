#include "packageserverresourcemanager.h"
#include "network/HttpClient.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QNetworkReply>
#include <QFutureWatcher>
#include <QtConcurrent>
#include <QList>

#define IF_MODIFIED_SINCE "If-Modified-Since"
#define IF_NONE_MATCH "If-None-Match"
#define LAST_MODIFIED "Last-Modified"
#define ETAG "Etag"
#define CACHE_FILENAME "/allAppinfo.json"

PackageServerResourceManager::PackageServerResourceManager(QObject *parent) : QObject(parent)
{
    m_requestDataTimer.setSingleShot(true);
    connect(&m_requestDataTimer, &QTimer::timeout, this, &PackageServerResourceManager::requestData);
}

PackageServerResourceManager::~PackageServerResourceManager()
{
    m_threadPool.waitForDone(200);
    m_threadPool.clear();
}

static QByteArray startLoad(){
    QByteArray ret;
    QString path = QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + QLatin1String(CACHE_FILENAME);
    QFile app_json(path);
    if (app_json.open(QIODevice::ReadOnly)) {
        // 成功得到json文件
        QByteArray jsonData=app_json.readAll();
        if (!jsonData.isEmpty()) {
            ret = jsonData;
        }
        app_json.close();
    }
    return ret;
}

void PackageServerResourceManager::loadCacheData()
{
    auto fw = new QFutureWatcher<QByteArray>(this);
    connect(fw, &QFutureWatcher<QByteArray>::finished, this, [this, fw]() {
        const auto data = fw->result();
        fw->deleteLater();
        if(!data.isEmpty()){
            isCacheData = true;
            parseJson(data);
            emit loadFinished();
        }
        m_requestDataTimer.start();

    });
    fw->setFuture(QtConcurrent::run(&m_threadPool, &startLoad));
    emit loadStart();
}

void PackageServerResourceManager::requestData()
{
    if(isNetworking){
        qDebug()<<Q_FUNC_INFO << " load cache isNetworking :" << isNetworking;
        return;
    }
    isNetworking = true;
    QString url;
    url = QLatin1String(BASE_URL) + QLatin1String("allapp");

    if(lastModified != ""){
        headers.insert(IF_MODIFIED_SINCE,lastModified);
    }
    if(etag != ""){
        headers.insert(IF_NONE_MATCH,etag);
    }
    HttpClient::global() -> get(url)
    .headers(headers)
    .onResponse([this](QNetworkReply* result) {
        isNetworking = false;
        bool isExistETAG = result->hasRawHeader(ETAG);
        if(isExistETAG) {
           etag = result->rawHeader(ETAG);
           lastModified = result->rawHeader(LAST_MODIFIED);
        }
        QByteArray serverData = result->readAll();

        auto json = QJsonDocument::fromJson(serverData).object();
        if (json.empty()) {
            emit loadError("data is null");
            return;
        }
        auto httpCode = json.value(QString::fromUtf8("code")).toInt();
        if (httpCode == 204) {
            emit loadFinished();
            return;
        }
        auto appList = json.value(QString::fromUtf8("apps")).toArray();
        if (appList.size() < 1) {
            emit loadError("data size is empty");
            return;
        }
        parseJson(serverData);

        QString path = QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + QLatin1String(CACHE_FILENAME);
        QFile app_json(path);
        if (app_json.open(QIODevice::ReadWrite)) {
            QByteArray fileData =  app_json.readAll();
            if (serverData == fileData) {
                return;
            }
            app_json.resize(0);
            app_json.write(serverData);
            app_json.close();
        }

    })
    .onError([this](QString errorStr) {
        isNetworking = false;
        emit loadError("request fail");
        return;
    })
    .timeout(10 * 1000)
    .exec();
}

void PackageServerResourceManager::parseJson(QByteArray jsonData)
{
    auto json = QJsonDocument::fromJson(jsonData).object();
    if (json.empty()) {
        emit loadError("data is null");
        return;
    }
    auto httpCode = json.value(QString::fromUtf8("code")).toInt();
    if (httpCode == 204) {
        emit loadFinished();
        return;
    }
    auto appList = json.value(QString::fromUtf8("apps")).toArray();
    if (appList.size() < 1) {
        emit loadError("data size is empty");
        return;
    }
    m_serverPackageNames.clear();
    serverPackages.clear();
    for (int i = 0; i < appList.size(); i++) {
        auto appObj = appList.at(i).toObject();
        auto appId = appObj.value(QString::fromUtf8("appId")).toString();
        auto appName = appObj.value(QString::fromUtf8("appName")).toString();
        auto icon = appObj.value(QString::fromUtf8("icon")).toString();
        auto banner = appObj.value(QString::fromUtf8("banner")).toString();
        auto categories = appObj.value(QString::fromUtf8("categories")).toArray();
        auto display = appObj.value(QString::fromUtf8("display")).toArray();
        QString name = "";
        QString comment = "";
        for (int j = 0; j < display.size(); j++) {
            auto displayObj = display.at(j).toObject();
            QString lang = "";
            if (QLocale::system().bcp47Name().startsWith("zh")) {
                lang = "cn";
            } else {
                lang = "en";
            }
            if (lang == displayObj.value(QString::fromUtf8("lang")).toString()) {
                name = displayObj.value(QString::fromUtf8("name")).toString();
                comment = displayObj.value(QString::fromUtf8("summary")).toString();
            }
        }
        QString categoryDisplay = "";
        QSet<QString> categoriesSets;
        for (int j = 0; j < categories.size(); j++) {
            QString currentType = categories.at(j).toString();
            categoryDisplay += currentType;
            categoriesSets.insert(currentType);
            if (j != categories.size() - 1) {
                categoryDisplay += ",";
            }
        }
        m_serverPackageNames.append(appName);
        ServerData currentData;
        currentData.appId = appId;
        currentData.banner = banner;
        currentData.categoryDisplay = categoryDisplay;
        currentData.comment = comment;
        currentData.icon = icon;
        currentData.name = name;
        currentData.appName = appName;
        currentData.categoriesSet = categoriesSets;
        serverPackages.insert(appName,currentData);

    }

    if(!isCacheData){
        emit loadFinished();
    }
}

void PackageServerResourceManager::refreshData()
{
    bool isactive = m_requestDataTimer.isActive();
    if (isactive) {
       m_requestDataTimer.stop();
    }
    isCacheData = false;
    m_requestDataTimer.start();
    emit loadStart();
}

bool PackageServerResourceManager::existPackageName(QString pkgName)
{
    bool isExist = serverPackages.contains(pkgName);

    return isExist;
}
ServerData PackageServerResourceManager::resourceByName(QString pkgName)
{
    return serverPackages.value(pkgName);
}

QList<ServerData> PackageServerResourceManager::resourceByCategory(QString categoryName)
{
    categoryName = categoryName.toLower();
    auto resources = kFilter<QList<ServerData>>(serverPackages, [categoryName](ServerData res) {
        return res.categoriesSet.contains(categoryName);
    });
    return resources;
}
QList<ServerData> PackageServerResourceManager::resourceByKeyword(QString keyword)
{
    QList<ServerData> allResult;
    keyword = keyword.toLower();
    auto resources = kFilter<QList<ServerData>>(serverPackages, [keyword](ServerData res) {
        QString resNameLow = res.name.toLower();
        bool isExist = resNameLow.contains(keyword);
        return isExist;
    });
    allResult += resources;
    return allResult;
}
