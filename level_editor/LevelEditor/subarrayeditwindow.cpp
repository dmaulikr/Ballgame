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
    connect(this, SIGNAL(doneEditingSublist()), parent, SLOT(doneEditingSublist()));
}

void SubArrayEditWindow::loadData(QVariant *listIn, QWidget* mainWin)
{
    list = listIn;

    updateComboBox();
    updateObjectTable(0);

    //connect(this, SIGNAL(doneEditingSublist(QList<QVariant>, int, int)), mainWin, SLOT(doneEditingSublist(QList<QVariant>, int, int)));
}

void SubArrayEditWindow::doneClicked()
{
    emit doneEditingSublist();
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
    QMap<QString, QVariant>::const_iterator it = list->toList()[objId].toMap().constBegin();
    for(int i = 0; i < row; i++)
        ++it;

    if(column == 1)
    {
        // This looks like it's more complicated than it needs to be, but unfortunately, it has to be this way :(
        // list is a pointer to a QVariant in the MainWindow, and when we do list->toList(), we get an entirely new object.
        // Therefore, if we only do list->toList().modifySomehow(), we modify only the newly created object, but not where it came from.
        // So in order to make this work, we have to create a tempList object, modify that, then set the original equal to the tempList.

        QMap<QString, QVariant> newMap = list->toList()[objId].toMap();
        newMap.insert(it.key(), newItem->text());

        QList<QVariant> tempList = list->toList();
        tempList[objId] = QVariant(newMap);
        *list = QVariant(tempList);
    }
    else if(column == 0)
    {
        QMap<QString, QVariant> newMap = list->toList()[objId].toMap();
        QString value = newMap.value(it.key()).toString();
        newMap.remove(it.key());
        newMap.insert(newItem->text(), value);

        QList<QVariant> tempList = list->toList();
        tempList[objId] = QVariant(newMap);
        *list = QVariant(tempList);
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
    for(int i = 0; i < list->toList().count(); i++)
    {
        comboBox->addItem(QString("Array Index: %1").arg(i));
    }

    if(previousSize == comboBox->count())
        comboBox->setCurrentIndex(previousIndex);
}

void SubArrayEditWindow::updateObjectTable(int objId)
{
    if(objId == -2 || list->toList().count() <= objId)
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
    for (it = list->toList().at(objId).toMap().constBegin(); it != list->toList().at(objId).toMap().constEnd(); ++it)
    {
        rowCount++;
        table->setRowCount(rowCount);

        table->setItem(rowCount-1, 0, new QTableWidgetItem(it.key()));

        if(it.value().type() == QVariant::String)
        {
            table->setItem(rowCount-1, 1, new QTableWidgetItem(it.value().toString()));
        }

        // This really shouldn't happen... yet
        else if(it.value().type() == QVariant::List || it.value().type() == QVariant::Map)
        {
            table->setItem(rowCount-1, 1, new QTableWidgetItem(QString("Click to edit")));
        }
        else
        {
            qDebug() << it.value();
            Q_ASSERT_X(false, "MainWindow::updateObjectTable", "Unknown QVariant type!");
        }
    }
}

void SubArrayEditWindow::addItemClicked()
{
    // If list is not empty, append a copy of the first object
    // See comment in objectChanged() for an explanation of why this is so complicated.
    if(list->toList().count() > 0)
    {
        QList<QVariant> tempList = list->toList();
        tempList.append(QMap<QString, QVariant>(list->toList()[0].toMap()));
        *list = QVariant(tempList);
    }

    // Otherwise, append a blank object
    else
    {
        QList<QVariant> tempList = list->toList();
        tempList.append(QMap<QString, QVariant>());
        *list = QVariant(tempList);
    }

    updateComboBox();

    ui->comboBox->setCurrentIndex(list->toList().count()-1);
    updateObjectTable(list->toList().count() - 1);
}

void SubArrayEditWindow::deleteItemClicked()
{
    int index = ui->comboBox->currentIndex();
    if(index == -1) // nothing selected
        return;

    // See comment in objectChanged() for an explanation of why this is so complicated.
    QList<QVariant> tempList = list->toList();
    tempList.removeAt(index);
    *list = QVariant(tempList);

    updateComboBox();

    if(index != 0)
    {
        ui->comboBox->setCurrentIndex(index-1);
        updateObjectTable(index-1);
    }
    else if(list->toList().count() == 0)
    {
        clearObjectTable();
    }
}

void SubArrayEditWindow::tableCellClicked(int x, int y)
{
    qDebug() << "Click received";

    // If didn't click in second column, don't do anything.
    if(y != 1)
        return;

    int objId = ui->comboBox->currentIndex();

    // Iterate to correct item
    QMap<QString, QVariant>::iterator it = list->toList()[objId].toMap().begin();
    for (int i = 0; i < x; i++)
    {
        it++;
    }

    // If item is not a list, don't do anything.
    if(it.value().type() != QVariant::List)
    {
        return;
    }

    // Otherwise, open up a new window and pass some stuff to it
    Qt::WindowFlags flags = Qt::Window;
    SubArrayEditWindow *sub = new SubArrayEditWindow(this, flags);
    // Pass the new widget a pointer to the data it should manipulate, and a pointer to the main window for a callback.
    sub->loadData(&it.value(), this);
    sub->show();
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
