/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created: Sat Aug 13 16:15:00 2011
**      by: Qt User Interface Compiler version 4.7.3
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QComboBox>
#include <QtGui/QHBoxLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QLineEdit>
#include <QtGui/QListWidget>
#include <QtGui/QMainWindow>
#include <QtGui/QMenu>
#include <QtGui/QMenuBar>
#include <QtGui/QPushButton>
#include <QtGui/QSlider>
#include <QtGui/QSpacerItem>
#include <QtGui/QStatusBar>
#include <QtGui/QTabWidget>
#include <QtGui/QTableWidget>
#include <QtGui/QVBoxLayout>
#include <QtGui/QWidget>
#include <levelgraphicsview.h>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QAction *actionNew_Level;
    QAction *actionOpen_Level;
    QAction *actionSave;
    QAction *actionSave_As;
    QAction *actionExit;
    QAction *actionUndo;
    QAction *actionRedo;
    QAction *actionDelete;
    QAction *actionCopy;
    QAction *actionPaste;
    QWidget *centralWidget;
    QHBoxLayout *horizontalLayout_2;
    QHBoxLayout *horizontalLayout;
    LevelGraphicsView *graphicsView;
    QTabWidget *tabWidget;
    QWidget *tab;
    QWidget *layoutWidget;
    QVBoxLayout *verticalLayout_2;
    QComboBox *objectSelectorComboBox;
    QTableWidget *objectsTableWidget;
    QPushButton *pushButton_4;
    QPushButton *pushButton_5;
    QSpacerItem *verticalSpacer;
    QPushButton *pushButton_3;
    QPushButton *pushButton;
    QPushButton *pushButton_2;
    QLabel *rotationLabel;
    QSlider *rotationSlider;
    QWidget *tab_2;
    QTableWidget *levelPlistTableWidget;
    QPushButton *pushButton_6;
    QPushButton *pushButton_7;
    QWidget *tab_3;
    QListWidget *newObjectListWidget;
    QWidget *tab_4;
    QWidget *layoutWidget1;
    QVBoxLayout *verticalLayout_3;
    QLabel *label;
    QLineEdit *wallThicknessEdit;
    QPushButton *wallThicknessButton;
    QMenuBar *menuBar;
    QMenu *menuFile;
    QMenu *menuEdit;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(800, 600);
        actionNew_Level = new QAction(MainWindow);
        actionNew_Level->setObjectName(QString::fromUtf8("actionNew_Level"));
        actionOpen_Level = new QAction(MainWindow);
        actionOpen_Level->setObjectName(QString::fromUtf8("actionOpen_Level"));
        actionSave = new QAction(MainWindow);
        actionSave->setObjectName(QString::fromUtf8("actionSave"));
        actionSave_As = new QAction(MainWindow);
        actionSave_As->setObjectName(QString::fromUtf8("actionSave_As"));
        actionExit = new QAction(MainWindow);
        actionExit->setObjectName(QString::fromUtf8("actionExit"));
        actionUndo = new QAction(MainWindow);
        actionUndo->setObjectName(QString::fromUtf8("actionUndo"));
        actionRedo = new QAction(MainWindow);
        actionRedo->setObjectName(QString::fromUtf8("actionRedo"));
        actionDelete = new QAction(MainWindow);
        actionDelete->setObjectName(QString::fromUtf8("actionDelete"));
        actionCopy = new QAction(MainWindow);
        actionCopy->setObjectName(QString::fromUtf8("actionCopy"));
        actionPaste = new QAction(MainWindow);
        actionPaste->setObjectName(QString::fromUtf8("actionPaste"));
        centralWidget = new QWidget(MainWindow);
        centralWidget->setObjectName(QString::fromUtf8("centralWidget"));
        horizontalLayout_2 = new QHBoxLayout(centralWidget);
        horizontalLayout_2->setSpacing(6);
        horizontalLayout_2->setContentsMargins(11, 11, 11, 11);
        horizontalLayout_2->setObjectName(QString::fromUtf8("horizontalLayout_2"));
        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setSpacing(6);
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        graphicsView = new LevelGraphicsView(centralWidget);
        graphicsView->setObjectName(QString::fromUtf8("graphicsView"));

        horizontalLayout->addWidget(graphicsView);

        tabWidget = new QTabWidget(centralWidget);
        tabWidget->setObjectName(QString::fromUtf8("tabWidget"));
        tabWidget->setMinimumSize(QSize(260, 0));
        tab = new QWidget();
        tab->setObjectName(QString::fromUtf8("tab"));
        layoutWidget = new QWidget(tab);
        layoutWidget->setObjectName(QString::fromUtf8("layoutWidget"));
        layoutWidget->setGeometry(QRect(10, 10, 258, 496));
        verticalLayout_2 = new QVBoxLayout(layoutWidget);
        verticalLayout_2->setSpacing(6);
        verticalLayout_2->setContentsMargins(11, 11, 11, 11);
        verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
        verticalLayout_2->setContentsMargins(0, 0, 0, 0);
        objectSelectorComboBox = new QComboBox(layoutWidget);
        objectSelectorComboBox->setObjectName(QString::fromUtf8("objectSelectorComboBox"));

        verticalLayout_2->addWidget(objectSelectorComboBox);

        objectsTableWidget = new QTableWidget(layoutWidget);
        if (objectsTableWidget->columnCount() < 2)
            objectsTableWidget->setColumnCount(2);
        QTableWidgetItem *__qtablewidgetitem = new QTableWidgetItem();
        objectsTableWidget->setHorizontalHeaderItem(0, __qtablewidgetitem);
        QTableWidgetItem *__qtablewidgetitem1 = new QTableWidgetItem();
        objectsTableWidget->setHorizontalHeaderItem(1, __qtablewidgetitem1);
        objectsTableWidget->setObjectName(QString::fromUtf8("objectsTableWidget"));
        objectsTableWidget->setMinimumSize(QSize(0, 260));

        verticalLayout_2->addWidget(objectsTableWidget);

        pushButton_4 = new QPushButton(layoutWidget);
        pushButton_4->setObjectName(QString::fromUtf8("pushButton_4"));

        verticalLayout_2->addWidget(pushButton_4);

        pushButton_5 = new QPushButton(layoutWidget);
        pushButton_5->setObjectName(QString::fromUtf8("pushButton_5"));

        verticalLayout_2->addWidget(pushButton_5);

        verticalSpacer = new QSpacerItem(20, 13, QSizePolicy::Minimum, QSizePolicy::Minimum);

        verticalLayout_2->addItem(verticalSpacer);

        pushButton_3 = new QPushButton(layoutWidget);
        pushButton_3->setObjectName(QString::fromUtf8("pushButton_3"));

        verticalLayout_2->addWidget(pushButton_3);

        pushButton = new QPushButton(layoutWidget);
        pushButton->setObjectName(QString::fromUtf8("pushButton"));

        verticalLayout_2->addWidget(pushButton);

        pushButton_2 = new QPushButton(layoutWidget);
        pushButton_2->setObjectName(QString::fromUtf8("pushButton_2"));

        verticalLayout_2->addWidget(pushButton_2);

        rotationLabel = new QLabel(layoutWidget);
        rotationLabel->setObjectName(QString::fromUtf8("rotationLabel"));
        QFont font;
        font.setBold(false);
        font.setWeight(50);
        rotationLabel->setFont(font);
        rotationLabel->setLayoutDirection(Qt::LeftToRight);

        verticalLayout_2->addWidget(rotationLabel);

        rotationSlider = new QSlider(layoutWidget);
        rotationSlider->setObjectName(QString::fromUtf8("rotationSlider"));
        rotationSlider->setOrientation(Qt::Horizontal);

        verticalLayout_2->addWidget(rotationSlider);

        tabWidget->addTab(tab, QString());
        tab_2 = new QWidget();
        tab_2->setObjectName(QString::fromUtf8("tab_2"));
        levelPlistTableWidget = new QTableWidget(tab_2);
        if (levelPlistTableWidget->columnCount() < 2)
            levelPlistTableWidget->setColumnCount(2);
        QTableWidgetItem *__qtablewidgetitem2 = new QTableWidgetItem();
        levelPlistTableWidget->setHorizontalHeaderItem(0, __qtablewidgetitem2);
        QTableWidgetItem *__qtablewidgetitem3 = new QTableWidgetItem();
        levelPlistTableWidget->setHorizontalHeaderItem(1, __qtablewidgetitem3);
        levelPlistTableWidget->setObjectName(QString::fromUtf8("levelPlistTableWidget"));
        levelPlistTableWidget->setGeometry(QRect(0, 0, 256, 431));
        pushButton_6 = new QPushButton(tab_2);
        pushButton_6->setObjectName(QString::fromUtf8("pushButton_6"));
        pushButton_6->setGeometry(QRect(0, 440, 261, 23));
        pushButton_7 = new QPushButton(tab_2);
        pushButton_7->setObjectName(QString::fromUtf8("pushButton_7"));
        pushButton_7->setGeometry(QRect(0, 470, 261, 23));
        tabWidget->addTab(tab_2, QString());
        tab_3 = new QWidget();
        tab_3->setObjectName(QString::fromUtf8("tab_3"));
        newObjectListWidget = new QListWidget(tab_3);
        newObjectListWidget->setObjectName(QString::fromUtf8("newObjectListWidget"));
        newObjectListWidget->setGeometry(QRect(0, 10, 361, 471));
        tabWidget->addTab(tab_3, QString());
        tab_4 = new QWidget();
        tab_4->setObjectName(QString::fromUtf8("tab_4"));
        layoutWidget1 = new QWidget(tab_4);
        layoutWidget1->setObjectName(QString::fromUtf8("layoutWidget1"));
        layoutWidget1->setGeometry(QRect(20, 20, 135, 70));
        verticalLayout_3 = new QVBoxLayout(layoutWidget1);
        verticalLayout_3->setSpacing(6);
        verticalLayout_3->setContentsMargins(11, 11, 11, 11);
        verticalLayout_3->setObjectName(QString::fromUtf8("verticalLayout_3"));
        verticalLayout_3->setContentsMargins(0, 0, 0, 0);
        label = new QLabel(layoutWidget1);
        label->setObjectName(QString::fromUtf8("label"));

        verticalLayout_3->addWidget(label);

        wallThicknessEdit = new QLineEdit(layoutWidget1);
        wallThicknessEdit->setObjectName(QString::fromUtf8("wallThicknessEdit"));

        verticalLayout_3->addWidget(wallThicknessEdit);

        wallThicknessButton = new QPushButton(layoutWidget1);
        wallThicknessButton->setObjectName(QString::fromUtf8("wallThicknessButton"));

        verticalLayout_3->addWidget(wallThicknessButton);

        tabWidget->addTab(tab_4, QString());

        horizontalLayout->addWidget(tabWidget);


        horizontalLayout_2->addLayout(horizontalLayout);

        MainWindow->setCentralWidget(centralWidget);
        menuBar = new QMenuBar(MainWindow);
        menuBar->setObjectName(QString::fromUtf8("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 800, 21));
        menuFile = new QMenu(menuBar);
        menuFile->setObjectName(QString::fromUtf8("menuFile"));
        menuEdit = new QMenu(menuBar);
        menuEdit->setObjectName(QString::fromUtf8("menuEdit"));
        MainWindow->setMenuBar(menuBar);
        statusBar = new QStatusBar(MainWindow);
        statusBar->setObjectName(QString::fromUtf8("statusBar"));
        MainWindow->setStatusBar(statusBar);

        menuBar->addAction(menuFile->menuAction());
        menuBar->addAction(menuEdit->menuAction());
        menuFile->addAction(actionNew_Level);
        menuFile->addSeparator();
        menuFile->addAction(actionOpen_Level);
        menuFile->addSeparator();
        menuFile->addAction(actionSave);
        menuFile->addAction(actionSave_As);
        menuFile->addSeparator();
        menuFile->addAction(actionExit);
        menuEdit->addAction(actionUndo);
        menuEdit->addAction(actionRedo);
        menuEdit->addSeparator();
        menuEdit->addAction(actionCopy);
        menuEdit->addAction(actionPaste);
        menuEdit->addSeparator();
        menuEdit->addAction(actionDelete);

        retranslateUi(MainWindow);
        QObject::connect(actionOpen_Level, SIGNAL(activated()), MainWindow, SLOT(loadFile()));
        QObject::connect(actionSave_As, SIGNAL(activated()), MainWindow, SLOT(saveLevelPlistAs()));
        QObject::connect(actionSave, SIGNAL(activated()), MainWindow, SLOT(saveLevelPlist()));
        QObject::connect(actionNew_Level, SIGNAL(activated()), MainWindow, SLOT(newLevel()));
        QObject::connect(actionExit, SIGNAL(activated()), MainWindow, SLOT(quit()));
        QObject::connect(actionUndo, SIGNAL(activated()), MainWindow, SLOT(undoClicked()));
        QObject::connect(actionRedo, SIGNAL(activated()), MainWindow, SLOT(redoClicked()));
        QObject::connect(actionDelete, SIGNAL(activated()), MainWindow, SLOT(deleteClicked()));
        QObject::connect(actionCopy, SIGNAL(activated()), MainWindow, SLOT(copyClicked()));
        QObject::connect(actionPaste, SIGNAL(activated()), MainWindow, SLOT(pasteClicked()));
        QObject::connect(objectsTableWidget, SIGNAL(cellClicked(int,int)), MainWindow, SLOT(objectTableClicked(int,int)));
        QObject::connect(pushButton_3, SIGNAL(clicked()), MainWindow, SLOT(copyObjectClicked()));
        QObject::connect(rotationSlider, SIGNAL(sliderMoved(int)), MainWindow, SLOT(rotationSliderMoved(int)));
        QObject::connect(levelPlistTableWidget, SIGNAL(itemChanged(QTableWidgetItem*)), MainWindow, SLOT(levelPlistChanged(QTableWidgetItem*)));
        QObject::connect(objectSelectorComboBox, SIGNAL(currentIndexChanged(int)), MainWindow, SLOT(updateObjectTable(int)));
        QObject::connect(objectsTableWidget, SIGNAL(itemChanged(QTableWidgetItem*)), MainWindow, SLOT(objectChanged(QTableWidgetItem*)));
        QObject::connect(pushButton_4, SIGNAL(clicked()), MainWindow, SLOT(addPropertyClicked()));
        QObject::connect(pushButton_5, SIGNAL(clicked()), MainWindow, SLOT(deletePropertyClicked()));
        QObject::connect(pushButton, SIGNAL(clicked()), MainWindow, SLOT(newObjectClicked()));
        QObject::connect(pushButton_2, SIGNAL(clicked()), MainWindow, SLOT(deleteObjectClicked()));
        QObject::connect(pushButton_6, SIGNAL(clicked()), MainWindow, SLOT(addLevelPropertyClicked()));
        QObject::connect(pushButton_7, SIGNAL(clicked()), MainWindow, SLOT(deleteLevelPropertyClicked()));
        QObject::connect(newObjectListWidget, SIGNAL(doubleClicked(QModelIndex)), MainWindow, SLOT(newObjectClicked(QModelIndex)));
        QObject::connect(wallThicknessButton, SIGNAL(clicked()), MainWindow, SLOT(wallThicknessClicked()));

        tabWidget->setCurrentIndex(3);


        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "BallGame Level Editor", 0, QApplication::UnicodeUTF8));
        actionNew_Level->setText(QApplication::translate("MainWindow", "New", 0, QApplication::UnicodeUTF8));
        actionNew_Level->setShortcut(QApplication::translate("MainWindow", "Ctrl+N", 0, QApplication::UnicodeUTF8));
        actionOpen_Level->setText(QApplication::translate("MainWindow", "Open", 0, QApplication::UnicodeUTF8));
        actionOpen_Level->setShortcut(QApplication::translate("MainWindow", "Ctrl+O", 0, QApplication::UnicodeUTF8));
        actionSave->setText(QApplication::translate("MainWindow", "Save", 0, QApplication::UnicodeUTF8));
        actionSave->setShortcut(QApplication::translate("MainWindow", "Ctrl+S", 0, QApplication::UnicodeUTF8));
        actionSave_As->setText(QApplication::translate("MainWindow", "Save As", 0, QApplication::UnicodeUTF8));
        actionExit->setText(QApplication::translate("MainWindow", "Exit", 0, QApplication::UnicodeUTF8));
        actionUndo->setText(QApplication::translate("MainWindow", "Undo", 0, QApplication::UnicodeUTF8));
        actionUndo->setShortcut(QApplication::translate("MainWindow", "Ctrl+Z", 0, QApplication::UnicodeUTF8));
        actionRedo->setText(QApplication::translate("MainWindow", "Redo", 0, QApplication::UnicodeUTF8));
        actionRedo->setShortcut(QApplication::translate("MainWindow", "Ctrl+Y", 0, QApplication::UnicodeUTF8));
        actionDelete->setText(QApplication::translate("MainWindow", "Delete", 0, QApplication::UnicodeUTF8));
        actionDelete->setShortcut(QApplication::translate("MainWindow", "Del", 0, QApplication::UnicodeUTF8));
        actionCopy->setText(QApplication::translate("MainWindow", "Copy", 0, QApplication::UnicodeUTF8));
        actionCopy->setShortcut(QApplication::translate("MainWindow", "Ctrl+C", 0, QApplication::UnicodeUTF8));
        actionPaste->setText(QApplication::translate("MainWindow", "Paste", 0, QApplication::UnicodeUTF8));
        actionPaste->setShortcut(QApplication::translate("MainWindow", "Ctrl+V", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem = objectsTableWidget->horizontalHeaderItem(0);
        ___qtablewidgetitem->setText(QApplication::translate("MainWindow", "Key", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem1 = objectsTableWidget->horizontalHeaderItem(1);
        ___qtablewidgetitem1->setText(QApplication::translate("MainWindow", "Value", 0, QApplication::UnicodeUTF8));
        pushButton_4->setText(QApplication::translate("MainWindow", "Add Property", 0, QApplication::UnicodeUTF8));
        pushButton_5->setText(QApplication::translate("MainWindow", "Delete Property", 0, QApplication::UnicodeUTF8));
        pushButton_3->setText(QApplication::translate("MainWindow", "Copy Object", 0, QApplication::UnicodeUTF8));
        pushButton->setText(QApplication::translate("MainWindow", "Add Blank New Object", 0, QApplication::UnicodeUTF8));
        pushButton_2->setText(QApplication::translate("MainWindow", "Delete Object", 0, QApplication::UnicodeUTF8));
        rotationLabel->setText(QApplication::translate("MainWindow", "Rotation", 0, QApplication::UnicodeUTF8));
        tabWidget->setTabText(tabWidget->indexOf(tab), QApplication::translate("MainWindow", "Objects", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem2 = levelPlistTableWidget->horizontalHeaderItem(0);
        ___qtablewidgetitem2->setText(QApplication::translate("MainWindow", "Key", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem3 = levelPlistTableWidget->horizontalHeaderItem(1);
        ___qtablewidgetitem3->setText(QApplication::translate("MainWindow", "Value", 0, QApplication::UnicodeUTF8));
        pushButton_6->setText(QApplication::translate("MainWindow", "Add Property", 0, QApplication::UnicodeUTF8));
        pushButton_7->setText(QApplication::translate("MainWindow", "Delete Property", 0, QApplication::UnicodeUTF8));
        tabWidget->setTabText(tabWidget->indexOf(tab_2), QApplication::translate("MainWindow", "Properties", 0, QApplication::UnicodeUTF8));
        tabWidget->setTabText(tabWidget->indexOf(tab_3), QApplication::translate("MainWindow", "New Object", 0, QApplication::UnicodeUTF8));
        label->setText(QApplication::translate("MainWindow", "Set thickness of all walls", 0, QApplication::UnicodeUTF8));
        wallThicknessButton->setText(QApplication::translate("MainWindow", "Go!", 0, QApplication::UnicodeUTF8));
        tabWidget->setTabText(tabWidget->indexOf(tab_4), QApplication::translate("MainWindow", "Utils", 0, QApplication::UnicodeUTF8));
        menuFile->setTitle(QApplication::translate("MainWindow", "File", 0, QApplication::UnicodeUTF8));
        menuEdit->setTitle(QApplication::translate("MainWindow", "Edit", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
