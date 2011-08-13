/********************************************************************************
** Form generated from reading UI file 'subarrayeditwindow.ui'
**
** Created: Sat Aug 13 16:15:00 2011
**      by: Qt User Interface Compiler version 4.7.3
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_SUBARRAYEDITWINDOW_H
#define UI_SUBARRAYEDITWINDOW_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QComboBox>
#include <QtGui/QHBoxLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QPushButton>
#include <QtGui/QSpacerItem>
#include <QtGui/QTableWidget>
#include <QtGui/QVBoxLayout>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_SubArrayEditWindow
{
public:
    QWidget *widget;
    QHBoxLayout *horizontalLayout_2;
    QSpacerItem *verticalSpacer;
    QVBoxLayout *verticalLayout;
    QHBoxLayout *horizontalLayout;
    QLabel *label;
    QComboBox *comboBox;
    QTableWidget *tableWidget;
    QPushButton *pushButton_2;
    QPushButton *pushButton_3;
    QSpacerItem *horizontalSpacer;
    QPushButton *pushButton;

    void setupUi(QWidget *SubArrayEditWindow)
    {
        if (SubArrayEditWindow->objectName().isEmpty())
            SubArrayEditWindow->setObjectName(QString::fromUtf8("SubArrayEditWindow"));
        SubArrayEditWindow->resize(300, 370);
        widget = new QWidget(SubArrayEditWindow);
        widget->setObjectName(QString::fromUtf8("widget"));
        widget->setGeometry(QRect(0, 10, 286, 345));
        horizontalLayout_2 = new QHBoxLayout(widget);
        horizontalLayout_2->setObjectName(QString::fromUtf8("horizontalLayout_2"));
        horizontalLayout_2->setContentsMargins(0, 0, 0, 0);
        verticalSpacer = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        horizontalLayout_2->addItem(verticalSpacer);

        verticalLayout = new QVBoxLayout();
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        label = new QLabel(widget);
        label->setObjectName(QString::fromUtf8("label"));
        label->setMaximumSize(QSize(40, 16777215));

        horizontalLayout->addWidget(label);

        comboBox = new QComboBox(widget);
        comboBox->setObjectName(QString::fromUtf8("comboBox"));
        comboBox->setMaximumSize(QSize(16777215, 16777215));

        horizontalLayout->addWidget(comboBox);


        verticalLayout->addLayout(horizontalLayout);

        tableWidget = new QTableWidget(widget);
        if (tableWidget->columnCount() < 2)
            tableWidget->setColumnCount(2);
        QTableWidgetItem *__qtablewidgetitem = new QTableWidgetItem();
        tableWidget->setHorizontalHeaderItem(0, __qtablewidgetitem);
        QTableWidgetItem *__qtablewidgetitem1 = new QTableWidgetItem();
        tableWidget->setHorizontalHeaderItem(1, __qtablewidgetitem1);
        tableWidget->setObjectName(QString::fromUtf8("tableWidget"));
        tableWidget->setMinimumSize(QSize(0, 200));

        verticalLayout->addWidget(tableWidget);

        pushButton_2 = new QPushButton(widget);
        pushButton_2->setObjectName(QString::fromUtf8("pushButton_2"));

        verticalLayout->addWidget(pushButton_2);

        pushButton_3 = new QPushButton(widget);
        pushButton_3->setObjectName(QString::fromUtf8("pushButton_3"));

        verticalLayout->addWidget(pushButton_3);

        horizontalSpacer = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        verticalLayout->addItem(horizontalSpacer);

        pushButton = new QPushButton(widget);
        pushButton->setObjectName(QString::fromUtf8("pushButton"));

        verticalLayout->addWidget(pushButton);


        horizontalLayout_2->addLayout(verticalLayout);

        tableWidget->raise();
        comboBox->raise();
        label->raise();
        pushButton->raise();
        tableWidget->raise();

        retranslateUi(SubArrayEditWindow);
        QObject::connect(comboBox, SIGNAL(currentIndexChanged(int)), SubArrayEditWindow, SLOT(comboBoxSelected(int)));
        QObject::connect(pushButton, SIGNAL(clicked()), SubArrayEditWindow, SLOT(doneClicked()));
        QObject::connect(tableWidget, SIGNAL(itemChanged(QTableWidgetItem*)), SubArrayEditWindow, SLOT(objectChanged(QTableWidgetItem*)));
        QObject::connect(pushButton_2, SIGNAL(clicked()), SubArrayEditWindow, SLOT(addItemClicked()));
        QObject::connect(pushButton_3, SIGNAL(clicked()), SubArrayEditWindow, SLOT(deleteItemClicked()));

        QMetaObject::connectSlotsByName(SubArrayEditWindow);
    } // setupUi

    void retranslateUi(QWidget *SubArrayEditWindow)
    {
        SubArrayEditWindow->setWindowTitle(QApplication::translate("SubArrayEditWindow", "Form", 0, QApplication::UnicodeUTF8));
        label->setText(QApplication::translate("SubArrayEditWindow", "Item #", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem = tableWidget->horizontalHeaderItem(0);
        ___qtablewidgetitem->setText(QApplication::translate("SubArrayEditWindow", "Key", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem1 = tableWidget->horizontalHeaderItem(1);
        ___qtablewidgetitem1->setText(QApplication::translate("SubArrayEditWindow", "Value", 0, QApplication::UnicodeUTF8));
        pushButton_2->setText(QApplication::translate("SubArrayEditWindow", "Add Item", 0, QApplication::UnicodeUTF8));
        pushButton_3->setText(QApplication::translate("SubArrayEditWindow", "Delete Item", 0, QApplication::UnicodeUTF8));
        pushButton->setText(QApplication::translate("SubArrayEditWindow", "Done", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class SubArrayEditWindow: public Ui_SubArrayEditWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_SUBARRAYEDITWINDOW_H
