######################################################################
# Automatically generated by qmake (3.1) Fri Oct 22 15:08:16 2021
######################################################################

TEMPLATE = app
TARGET = discover
INCLUDEPATH += .

# The following define makes your compiler warn you if you use any
# feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Input
HEADERS += discover/DiscoverDeclarativePlugin.h \
           discover/DiscoverObject.h \
           discover/FeaturedModel.h \
           discover/PaginateModel.h \
           discover/ReadFile.h \
           discover/UnityLauncher.h \
           exporter/MuonExporter.h \
           kcm/updates.h \
           libdiscover/ActionsModel.h \
           libdiscover/ApplicationAddonsModel.h \
           libdiscover/CachedNetworkAccessManager.h \
           libdiscover/DiscoverBackendsFactory.h \
           libdiscover/log.h \
           libdiscover/ScreenshotsModel.h \
           libdiscover/utils.h \
           notifier/BackendNotifierFactory.h \
           notifier/DiscoverNotifier.h \
           notifier/NotifierItem.h \
           notifier/UnattendedUpdates.h \
           update/DiscoverUpdate.h \
           discover/cus/AppClass.h \
           discover/cus/AppClassModel.h \
           libdiscover/appstream/AppStreamIntegration.h \
           libdiscover/appstream/AppStreamUtils.h \
           libdiscover/appstream/OdrsReviewsBackend.h \
           libdiscover/Category/CategoriesReader.h \
           libdiscover/Category/Category.h \
           libdiscover/Category/CategoryModel.h \
           libdiscover/network/HttpClient.h \
           libdiscover/network/HttpRequest.h \
           libdiscover/network/HttpResponse.h \
           libdiscover/network/networkutils.h \
           libdiscover/notifiers/BackendNotifierModule.h \
           libdiscover/resources/AbstractBackendUpdater.h \
           libdiscover/resources/AbstractKDEDModule.h \
           libdiscover/resources/AbstractResource.h \
           libdiscover/resources/AbstractResourcesBackend.h \
           libdiscover/resources/AbstractSourcesBackend.h \
           libdiscover/resources/AppResItem.h \
           libdiscover/resources/bannerappresource.h \
           libdiscover/resources/bannerresourcemodel.h \
           libdiscover/resources/PackageState.h \
           libdiscover/resources/ResourcesModel.h \
           libdiscover/resources/ResourcesProxyModel.h \
           libdiscover/resources/ResourcesUpdatesModel.h \
           libdiscover/resources/SourcesModel.h \
           libdiscover/resources/StandardBackendUpdater.h \
           libdiscover/resources/StoredResultsStream.h \
           libdiscover/ReviewsBackend/AbstractReviewsBackend.h \
           libdiscover/ReviewsBackend/Rating.h \
           libdiscover/ReviewsBackend/Review.h \
           libdiscover/ReviewsBackend/ReviewsModel.h \
           libdiscover/Transaction/AddonList.h \
           libdiscover/Transaction/Transaction.h \
           libdiscover/Transaction/TransactionListener.h \
           libdiscover/Transaction/TransactionModel.h \
           libdiscover/UpdateModel/UpdateItem.h \
           libdiscover/UpdateModel/UpdateModel.h \
           libdiscover/backends/DummyBackend/DummyBackend.h \
           libdiscover/backends/DummyBackend/DummyNotifier.h \
           libdiscover/backends/DummyBackend/DummyResource.h \
           libdiscover/backends/DummyBackend/DummyReviewsBackend.h \
           libdiscover/backends/DummyBackend/DummySourcesBackend.h \
           libdiscover/backends/DummyBackend/DummyTransaction.h \
           libdiscover/backends/FlatpakBackend/FlatpakBackend.h \
           libdiscover/backends/FlatpakBackend/FlatpakFetchDataJob.h \
           libdiscover/backends/FlatpakBackend/FlatpakJobTransaction.h \
           libdiscover/backends/FlatpakBackend/FlatpakNotifier.h \
           libdiscover/backends/FlatpakBackend/FlatpakResource.h \
           libdiscover/backends/FlatpakBackend/FlatpakSourcesBackend.h \
           libdiscover/backends/FlatpakBackend/FlatpakTransactionThread.h \
           libdiscover/backends/FwupdBackend/FwupdBackend.h \
           libdiscover/backends/FwupdBackend/FwupdResource.h \
           libdiscover/backends/FwupdBackend/FwupdSourcesBackend.h \
           libdiscover/backends/FwupdBackend/FwupdTransaction.h \
           libdiscover/backends/KNSBackend/KNSBackend.h \
           libdiscover/backends/KNSBackend/KNSResource.h \
           libdiscover/backends/KNSBackend/KNSReviews.h \
           libdiscover/backends/PackageKitBackend/AppPackageKitResource.h \
           libdiscover/backends/PackageKitBackend/LocalFilePKResource.h \
           libdiscover/backends/PackageKitBackend/PackageKitBackend.h \
           libdiscover/backends/PackageKitBackend/PackageKitMessages.h \
           libdiscover/backends/PackageKitBackend/PackageKitNotifier.h \
           libdiscover/backends/PackageKitBackend/PackageKitResource.h \
           libdiscover/backends/PackageKitBackend/PackageKitSourcesBackend.h \
           libdiscover/backends/PackageKitBackend/PackageKitUpdater.h \
           libdiscover/backends/PackageKitBackend/packageserverresourcemanager.h \
           libdiscover/backends/PackageKitBackend/pk-offline-private.h \
           libdiscover/backends/PackageKitBackend/PKResolveTransaction.h \
           libdiscover/backends/PackageKitBackend/PKTransaction.h \
           libdiscover/backends/SnapBackend/SnapBackend.h \
           libdiscover/backends/SnapBackend/SnapResource.h \
           libdiscover/backends/SnapBackend/SnapTransaction.h \
           libdiscover/backends/DummyBackend/tests/DummyTest.h \
           libdiscover/backends/KNSBackend/tests/KNSBackendTest.h
FORMS += libdiscover/backends/SnapBackend/libsnapclient/SnapMacaroonDialog.ui
SOURCES += discover/DiscoverDeclarativePlugin.cpp \
           discover/DiscoverObject.cpp \
           discover/FeaturedModel.cpp \
           discover/main.cpp \
           discover/PaginateModel.cpp \
           discover/ReadFile.cpp \
           discover/UnityLauncher.cpp \
           exporter/main.cpp \
           exporter/MuonExporter.cpp \
           kcm/updates.cpp \
           libdiscover/ActionsModel.cpp \
           libdiscover/ApplicationAddonsModel.cpp \
           libdiscover/CachedNetworkAccessManager.cpp \
           libdiscover/DiscoverBackendsFactory.cpp \
           libdiscover/ScreenshotsModel.cpp \
           notifier/BackendNotifierFactory.cpp \
           notifier/DiscoverNotifier.cpp \
           notifier/main.cpp \
           notifier/NotifierItem.cpp \
           notifier/UnattendedUpdates.cpp \
           update/DiscoverUpdate.cpp \
           update/main.cpp \
           discover/autotests/PaginateModelTest.cpp \
           discover/cus/AppClass.cpp \
           discover/cus/AppClassModel.cpp \
           libdiscover/appstream/AppStreamIntegration.cpp \
           libdiscover/appstream/AppStreamUtils.cpp \
           libdiscover/appstream/OdrsReviewsBackend.cpp \
           libdiscover/Category/CategoriesReader.cpp \
           libdiscover/Category/Category.cpp \
           libdiscover/Category/CategoryModel.cpp \
           libdiscover/network/HttpClient.cpp \
           libdiscover/network/HttpRequest.cpp \
           libdiscover/network/HttpResponse.cpp \
           libdiscover/network/networkutils.cpp \
           libdiscover/notifiers/BackendNotifierModule.cpp \
           libdiscover/resources/AbstractBackendUpdater.cpp \
           libdiscover/resources/AbstractKDEDModule.cpp \
           libdiscover/resources/AbstractResource.cpp \
           libdiscover/resources/AbstractResourcesBackend.cpp \
           libdiscover/resources/AbstractSourcesBackend.cpp \
           libdiscover/resources/AppResItem.cpp \
           libdiscover/resources/bannerappresource.cpp \
           libdiscover/resources/bannerresourcemodel.cpp \
           libdiscover/resources/PackageState.cpp \
           libdiscover/resources/ResourcesModel.cpp \
           libdiscover/resources/ResourcesProxyModel.cpp \
           libdiscover/resources/ResourcesUpdatesModel.cpp \
           libdiscover/resources/SourcesModel.cpp \
           libdiscover/resources/StandardBackendUpdater.cpp \
           libdiscover/resources/StoredResultsStream.cpp \
           libdiscover/ReviewsBackend/AbstractReviewsBackend.cpp \
           libdiscover/ReviewsBackend/Rating.cpp \
           libdiscover/ReviewsBackend/Review.cpp \
           libdiscover/ReviewsBackend/ReviewsModel.cpp \
           libdiscover/tests/CategoriesTest.cpp \
           libdiscover/Transaction/AddonList.cpp \
           libdiscover/Transaction/Transaction.cpp \
           libdiscover/Transaction/TransactionListener.cpp \
           libdiscover/Transaction/TransactionModel.cpp \
           libdiscover/UpdateModel/UpdateItem.cpp \
           libdiscover/UpdateModel/UpdateModel.cpp \
           libdiscover/backends/DummyBackend/DummyBackend.cpp \
           libdiscover/backends/DummyBackend/DummyNotifier.cpp \
           libdiscover/backends/DummyBackend/DummyResource.cpp \
           libdiscover/backends/DummyBackend/DummyReviewsBackend.cpp \
           libdiscover/backends/DummyBackend/DummySourcesBackend.cpp \
           libdiscover/backends/DummyBackend/DummyTransaction.cpp \
           libdiscover/backends/FlatpakBackend/FlatpakBackend.cpp \
           libdiscover/backends/FlatpakBackend/FlatpakFetchDataJob.cpp \
           libdiscover/backends/FlatpakBackend/FlatpakJobTransaction.cpp \
           libdiscover/backends/FlatpakBackend/FlatpakNotifier.cpp \
           libdiscover/backends/FlatpakBackend/FlatpakResource.cpp \
           libdiscover/backends/FlatpakBackend/FlatpakSourcesBackend.cpp \
           libdiscover/backends/FlatpakBackend/FlatpakTransactionThread.cpp \
           libdiscover/backends/FwupdBackend/FwupdBackend.cpp \
           libdiscover/backends/FwupdBackend/FwupdResource.cpp \
           libdiscover/backends/FwupdBackend/FwupdSourcesBackend.cpp \
           libdiscover/backends/FwupdBackend/FwupdTransaction.cpp \
           libdiscover/backends/KNSBackend/KNSBackend.cpp \
           libdiscover/backends/KNSBackend/KNSResource.cpp \
           libdiscover/backends/KNSBackend/KNSReviews.cpp \
           libdiscover/backends/PackageKitBackend/AppPackageKitResource.cpp \
           libdiscover/backends/PackageKitBackend/LocalFilePKResource.cpp \
           libdiscover/backends/PackageKitBackend/PackageKitBackend.cpp \
           libdiscover/backends/PackageKitBackend/PackageKitMessages.cpp \
           libdiscover/backends/PackageKitBackend/PackageKitNotifier.cpp \
           libdiscover/backends/PackageKitBackend/PackageKitResource.cpp \
           libdiscover/backends/PackageKitBackend/PackageKitSourcesBackend.cpp \
           libdiscover/backends/PackageKitBackend/PackageKitUpdater.cpp \
           libdiscover/backends/PackageKitBackend/packageserverresourcemanager.cpp \
           libdiscover/backends/PackageKitBackend/PKResolveTransaction.cpp \
           libdiscover/backends/PackageKitBackend/PKTransaction.cpp \
           libdiscover/backends/SnapBackend/SnapBackend.cpp \
           libdiscover/backends/SnapBackend/SnapResource.cpp \
           libdiscover/backends/SnapBackend/SnapTransaction.cpp \
           libdiscover/backends/DummyBackend/tests/DummyTest.cpp \
           libdiscover/backends/DummyBackend/tests/UpdateDummyTest.cpp \
           libdiscover/backends/FlatpakBackend/tests/FlatpakTest.cpp \
           libdiscover/backends/KNSBackend/tests/KNSBackendTest.cpp \
           libdiscover/backends/PackageKitBackend/runservice/main.cpp \
           libdiscover/backends/SnapBackend/libsnapclient/SnapAuthHelper.cpp \
           libdiscover/backends/SnapBackend/libsnapclient/SnapMacaroonDialog.cpp
RESOURCES += discover/resources.qrc \
             libdiscover/backends/PackageKitBackend/pkui.qrc \
             libdiscover/backends/SnapBackend/snapui.qrc
