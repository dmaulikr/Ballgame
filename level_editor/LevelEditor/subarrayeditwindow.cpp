#include "subarrayeditwindow.h"
#include "ui_subarrayeditwindow.h"

SubArrayEditWindow::SubArrayEditWindow(QWidget * parent, Qt::WindowFlags f) :
    QWidget(parent),
    ui(new Ui::SubArrayEditWindow)
{
    // Make sure we are in a new window
    setWindowFlags(f);

    ui->setupUi(this);

    noEmit = false;

    // Make sure we can relay information back to the Main Window
    connect(this, SIGNAL(doneEditingSublist(QList<QVariant>, int, int)), parent, SLOT(doneEditingSublist(QList<QVariant>, int, int)));
}

void SubArrayEditWindow::loadData(QList< QVariant > listIn, int index1, int index2, MainWindow* mainWin)
{
    list = listIn;
    mainWindowObjectId = index1;
    mainWindowObjectIndex = index2;

    updateComboBox();
    updateObjectTable(0);

    //connect(this, SIGNAL(doneEditingSublist(QList<QVariant>, int, int)), mainWin, SLOT(doneEditingSublist(QList<QVariant>, int, int)));
}

void SubArrayEditWindow::doneClicked()
{
    emit doneEditingSublist(list, mainWindowObjectId, mainWindowObjectIndex);
    close();
}

void SubArrayEditWindow::objectChanged(QTableWidgetItem* newItem)
{
    int column = ui->tableWidget->currentColumn();
    // Nothing selected, abort.
    if(column < 0)
        return;

    int row = ui->tableWidget->currentRow();
    int objId = ui->comboBox->currentIndex();
    if(objId == -1 || row == -1) // not initialized yet
        return;

    if(noEmit)
        return;
    noEmit = true;

    // iterate to the changed row
    QMap<QString, QVariant>::const_iterator it = list[objId].toMap().constBegin();
    for(int i = 0; i < row; i++)
        ++it;

    if(column == 1)
    {
        QMap<QString, QVariant> newMap = list[objId].toMap();
        newMap.insert(it.key(), newItem->text());
        list[objId] = QVariant(newMap);
    }
    else if(column == 0)
    {
        QMap<QString, QVariant> newMap = list[objId].toMap();
        QString value = newMap.value(it.key()).toString();
        newMap.remove(it.key());
        newMap.insert(newItem->text(), value);
        list[objId] = QVariant(newMap);
    }
    noEmit = false;
}

void SubArrayEditWindow::comboBoxSelected(int index)
{
    updateObjectTable(index);
}

void SubArrayEditWindow::updateComboBox()
{
    QComboBox *comboBox = ui->comboBox;

    int previousIndex = comboBox->currentIndex();
    int previousSize = comboBox->count();

    comboBox->clear();
    for(int i = 0; i < list.count(); i++)
    {
        comboBox->addItem(QString("Array Index: %1").arg(i));
    }

    if(previousSize == comboBox->count())
        comboBox->setCurrentIndex(previousIndex);
}

void SubArrayEditWindow::updateObjectTable(int objId)
{
    if(objId == -2 || list.count() <= objId)
    {
        clearObjectTable();
        return;
    }

    if(objId == -1)
        return;


    QTableWidget *table = ui->tableWidget;

    int rowCount = 0;
    table->setColumnCount(2);
    table->setRowCount(0);


    QMap<QString, QVariant>::const_iterator it;
    for (it = list.at(objId).toMap().constBegin(); it != list.at(objId).toMap().constEnd(); ++it)
    {
        rowCount++;
        table->setRowCount(rowCount);

        table->setItem(rowCount-1, 0, new QTableWidgetItem(it.key()));

        if(it.value().type() == QVariant::String)
        {
            table->setItem(rowCount-1, 1, new QTableWidgetItem(it.value().toString()));
        }

        // This really shouldn't happen... yet
        else if(it.value().type() == QVariant::List)
        {
            table->setItem(rowCount-1, 1, new QTableWidgetItem(QString("Click to edit")));
        }
        else
        {
            Q_ASSERT_X(false, "MainWindow::updateObjectTable", "Unknown QVariant type!");
        }
    }
}

void SubArrayEditWindow::addItemClicked()
{
    // If list is not empty, append a copy of the first object
    if(list.count() > 0)
        list.append(QMap<QString, QVariant>(list[0].toMap()));

    // Otherwise, append a blank object
    else
        list.append(QMap<QString, QVariant>());

    updateComboBox();

    ui->comboBox->setCurrentIndex(list.count()-1);
    updateObjectTable(list.count() - 1);
}

void SubArrayEditWindow::deleteItemClicked()
{
    int index = ui->comboBox->currentIndex();
    if(index == -1) // nothing selected
        return;

    list.removeAt(index);

    updateComboBox();

    if(index != 0)
    {
        ui->comboBox->setCurrentIndex(index-1);
        updateObjectTable(index-1);
    }
    else if(list.count() == 0)
    {
        clearObjectTable();
    }
}

void SubArrayEditWindow::clearObjectTable()
{
    QTableWidget *table = ui->tableWidget;
    table->clear();
    table->setRowCount(0);
    table->setColumnCount(0);
}

SubArrayEditWindow::~SubArrayEditWindow()
{
    delete ui;
}
