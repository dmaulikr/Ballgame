#include "mainwindow.h"
#include "ui_mainwindow.h"

// THIS IS DEFINETELY NOT A PERMANENT SOLUTION!
#ifdef ON_MAC
#define PATH_SPRITE_PLIST "../../ballgame/Resources/BallGameSpriteSheet.plist"
#define PATH_SPRITE_IMAGE "../../ballgame/Resources/BallGameSpriteSheet.png"
#define PATH_DEBUG_LEVEL "../../ballgame/Resources/DebugLevel.level"
#else
#define PATH_SPRITE_PLIST "..\\..\\ballgame\\Resources\\BallGameSpriteSheet.plist"
#define PATH_SPRITE_IMAGE "..\\..\\ballgame\\Resources\\BallGameSpriteSheet.png"
#define PATH_DEBUG_LEVEL "..\\..\\ballgame\\DebugLevel.level"
#endif

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    initializing = true;
    ui->setupUi(this);

    loadFile();

    noEmit = false;
    initializing = false;
}

void MainWindow::loadFile()
{

    spriteSheet = QImage(PATH_SPRITE_IMAGE);

    loadSpritePlist();
    loadLevelPlist(PATH_DEBUG_LEVEL);

    // draw objects on screen;
    updateGraphics();

    // populate tables
    updateLevelPlistTable();
    updateObjectTable(0);
    updateObjectComboBox();
}

void MainWindow::updateGraphics()
{
    scene = new QGraphicsScene(0, 0, levelPlist.value("level_width").toInt(), levelPlist.value("level_height").toInt());

    // Add player object to scene
    QRect playerRect = spriteSheetLocations.value("player_amoeba.png");
    Q_ASSERT_X(playerRect != QRect(0,0,0,0), "MainWindow::loadFile()", "Could not find sprite location!");
    QImage player = spriteSheet.copy(playerRect);
    QGraphicsPixmapItem *item = scene->addPixmap(QPixmap::fromImage(player));
    int startX = levelPlist.value("start_x").toInt() - playerRect.width()/2;
    int startY = levelPlist.value("level_height").toInt() - (levelPlist.value("start_y").toInt() + playerRect.height()/2);
    item->setPos(startX, startY);

    for(int i = 0; i < levelObjects.length(); i++)
    {
        QRect objRect;

        // ADD NEW OBJECTS HERE

        objRect = spriteSheetLocations.value(levelObjects.at(i).value("frame_name"));


        //Q_ASSERT_X(objRect != QRect(0,0,0,0), "MainWindow::loadFile()", "Could not find sprite location!");
        QImage img = spriteSheet.copy(objRect);
        int height = levelObjects.at(i).value("height").toInt();
        int width = levelObjects.at(i).value("width").toInt();
        int x = levelObjects.at(i).value("x").toInt();
        int y = levelObjects.at(i).value("y").toInt();
        img = img.scaled(QSize(width, height), Qt::IgnoreAspectRatio);
        item = scene->addPixmap(QPixmap::fromImage(img));
        int xPos = x - width/2;
        int yPos = levelPlist.value("level_height").toInt() - (y + height/2);
        item->setPos(xPos, yPos);
    }

    QGraphicsView *view = ui->graphicsView;
    view->setScene(scene);
    view->setMaximumSize(levelPlist.value("level_width").toInt() + 2, levelPlist.value("level_height").toInt() + 3);

    // set background
    scene->setBackgroundBrush(Qt::black);
}

// Read sprite size and location data from plist, and save it in a hash table.
// I really hope that the file format doesn't change, since a lot of it is hardcoded in.
void MainWindow::loadSpritePlist()
{
    QDomDocument doc("BallGameSpriteSheet");
     QFile file(PATH_SPRITE_PLIST);
     if (!file.open(QIODevice::ReadOnly))
         return;
     if (!doc.setContent(&file)) {
         file.close();
         return;
     }
     file.close();

     QString itemName = "null";
     QRect itemRect;

     // print out the element names of all elements that are direct children
     // of the outermost element.
     QDomElement docElem = doc.documentElement();

     QDomNode n = docElem.firstChild();
     n = n.firstChild().nextSibling().firstChild();
     while(!n.isNull()) {
         QDomElement e = n.toElement(); // try to convert the node to an element.
         if(!e.isNull()) {
             itemName = qPrintable(e.text()); // the node really is an element.
         }
         n = n.nextSibling();
         QDomNode m = n.firstChild();

         // 13 is the index of the Rect string in the sub-dicts.
         for(int i = 0; i < 13; i++)
             m = m.nextSibling();

         QDomElement f = m.toElement();
         itemRect = strToRect(qPrintable(f.text()));
         n = n.nextSibling();

         spriteSheetLocations.insert(itemName, itemRect);
     }
}


void MainWindow::objectChanged(QTableWidgetItem* newItem)
{
    int column = ui->objectsTableWidget->currentColumn();
    // Nothing selected, abort.
    if(column < 0)
        return;

    int row = ui->objectsTableWidget->currentRow();
    int objId = ui->objectSelectorComboBox->currentIndex();
    if(objId == -1 || row == -1) // not initialized yet
        return;

    if(noEmit)
        return;
    noEmit = true;

    // iterate to the changed row
    QMap<QString, QString>::const_iterator it = levelObjects[objId].constBegin();
    for(int i = 0; i < row; i++)
        ++it;

    if(column == 1)
    {
        levelObjects[objId].insert(it.key(), newItem->text());
    }
    else if(column == 0)
    {
        QString value = levelObjects[objId].value(it.key());
        levelObjects[objId].remove(it.key());
        levelObjects[objId].insert(newItem->text(), value);
    }

    updateGraphics();
    updateObjectComboBox();

    noEmit = false;
}

void MainWindow::levelPlistChanged(QTableWidgetItem* newItem)
{    // Nothing selected, abort.
    if(ui->levelPlistTableWidget->currentColumn() < 0)
        return;

    if(noEmit)
        return;
    noEmit = true;

    int row = ui->levelPlistTableWidget->currentRow();

    // iterate to the changed row

    QMap<QString, QString>::const_iterator it = levelPlist.constBegin();
    for(int i = 0; i < row; i++)
        ++it;

    levelPlist.insert(it.key(), newItem->text());

    updateGraphics();

    noEmit = false;
}

void MainWindow::updateLevelPlistTable()
{
    QTableWidget *table = ui->levelPlistTableWidget;

    int count = levelPlist.count();
    table->setRowCount(count);
    table->setColumnCount(2);


    QMap<QString, QString>::const_iterator i;
    int index = 0;

    for (i = levelPlist.constBegin(); i != levelPlist.constEnd(); ++i)
    {
        QTableWidgetItem *widg = new QTableWidgetItem(i.key());
        table->setItem(index, 0, widg);
        //qDebug() << "before - " << levelPlist;
        table->setItem(index, 1, new QTableWidgetItem(i.value()));
        //qDebug() << "after - " << levelPlist << "\n";
        index++;
    }
}

void MainWindow::updateObjectComboBox()
{
    QComboBox *comboBox = ui->objectSelectorComboBox;

    int previousIndex = comboBox->currentIndex();
    int previousSize = comboBox->count();

    comboBox->clear();
    for(int i = 0; i < levelObjects.count(); i++)
    {
        comboBox->addItem(QString(levelObjects.at(i).value("type") + " - " + levelObjects.at(i).value("name")));
    }

    if(previousSize == comboBox->count())
        comboBox->setCurrentIndex(previousIndex);



}

void MainWindow::clearObjectTable()
{
    QTableWidget *table = ui->objectsTableWidget;
    table->clear();
    table->setRowCount(0);
    table->setColumnCount(0);
}

void MainWindow::updateObjectTable(int objId)
{
    if(objId == -1)
        return;


    QTableWidget *table = ui->objectsTableWidget;

    int rowCount = 0;
    table->setColumnCount(2);
    table->setRowCount(0);


    QMap<QString, QString>::const_iterator it;
    for (it = levelObjects.at(objId).constBegin(); it != levelObjects.at(objId).constEnd(); ++it)
    {
        rowCount++;
        table->setRowCount(rowCount);

        table->setItem(rowCount-1, 0, new QTableWidgetItem(it.key()));
        table->setItem(rowCount-1, 1, new QTableWidgetItem(it.value()));
    }

}

void MainWindow::loadLevelPlist(QString level)
{
    QDomDocument doc("BallGameSpriteSheet");
     QFile file(level);
     if (!file.open(QIODevice::ReadOnly))
         return;
     if (!doc.setContent(&file)) {
         file.close();
         return;
     }
     file.close();

     QString itemName = "null";
     QString itemContents = "null";
     QString itemTag = "null";

     // print out the element names of all elements that are direct children
     // of the outermost element.
     QDomElement docElem = doc.documentElement();

     QDomNode n = docElem.firstChild();
     n = n.firstChild();
     while(!n.isNull()) {
         QDomElement e = n.toElement(); // try to convert the node to an element.
         if(!e.isNull()) {

             itemName = qPrintable(e.text()); // the node really is an element.
             itemTag = qPrintable(e.tagName());

             Q_ASSERT_X(itemTag == "key", "MainWindow::loadLevelPlist", "Tag should be a key, but isn't!");

             n = n.nextSibling();
             e = n.toElement();
             itemContents = qPrintable(e.text());
             itemTag = qPrintable(e.tagName());
             if(itemTag != "array")
             {
                 levelPlist.insert(itemName, itemContents);
             }
             else
             {
                 QDomNode m = n.firstChild();
                 while(!m.isNull())
                 {
                     QMap<QString, QString> newHash;
                     QDomNode o = m.firstChild();
                     while(!o.isNull())
                     {
                         QDomElement f = o.toElement(); // try to convert the node to an element.
                         if(!f.isNull()) {

                             itemName = qPrintable(f.text()); // the node really is an element.
                             itemTag = qPrintable(f.tagName());

                             Q_ASSERT_X(itemTag == "key", "MainWindow::loadLevelPlist", "Level object tag should be a key, but isn't!");

                             o = o.nextSibling();
                             f = o.toElement();
                             itemContents = qPrintable(f.text());
                             itemTag = qPrintable(f.tagName());

                             newHash.insert(itemName, itemContents);

                             o = o.nextSibling();
                         }
                     } // while object dict is not done

                     levelObjects.append(newHash);
                     m = m.nextSibling();
                 }
             }

             n = n.nextSibling();


         }

     }
}

void MainWindow::addPropertyClicked()
{
    int objId = ui->objectSelectorComboBox->currentIndex();

    if(objId == -1) // nothing selected
        return;


    levelObjects[objId].insert("new_property", "null");

    updateGraphics();
    updateObjectComboBox();
    updateObjectTable(objId);

}

void MainWindow::deletePropertyClicked()
{
    int row = ui->objectsTableWidget->currentRow();
    int objId = ui->objectSelectorComboBox->currentIndex();

    if(objId == -1 || row == -1) // nothing selected
        return;

    // iterate to the deleted row
    QMap<QString, QString>::const_iterator it = levelObjects[objId].constBegin();
    for(int i = 0; i < row; i++)
        ++it;

    levelObjects[objId].remove(it.key());

    updateGraphics();
    updateObjectComboBox();
    updateObjectTable(objId);

}

void MainWindow::newObjectClicked()
{
    levelObjects.append(QMap<QString, QString>());

    updateGraphics();
    updateObjectComboBox();

    ui->objectSelectorComboBox->setCurrentIndex(levelObjects.count()-1);
    updateObjectTable(levelObjects.count() - 1);
}

void MainWindow::copyObjectClicked()
{
    int index = ui->objectSelectorComboBox->currentIndex();
    if(index == -1) // nothing selected
        return;

    levelObjects.append(QMap<QString, QString>(levelObjects[index]));

    levelObjects[levelObjects.count()-1].insert("name", QString("Copy of " + levelObjects[levelObjects.count()-1].value("name")));
    updateGraphics();
    updateObjectComboBox();

    ui->objectSelectorComboBox->setCurrentIndex(levelObjects.count()-1);
    updateObjectTable(levelObjects.count() - 1);
}

void MainWindow::deleteObjectClicked()
{
    int index = ui->objectSelectorComboBox->currentIndex();
    if(index == -1) // nothing selected
        return;

    levelObjects.removeAt(index);

    updateGraphics();
    updateObjectComboBox();

    if(index != 0)
    {
        ui->objectSelectorComboBox->setCurrentIndex(index-1);
        updateObjectTable(index-1);
    }
    else if(levelObjects.count() == 0)
    {
        clearObjectTable();
    }
}

// Helper function to convert string to rect
QRect MainWindow::strToRect(QString in)
{
    in.replace("{", "");
    in.replace("}", "");
    in.replace(",", "");

    QStringList strL = in.split(" ");
    Q_ASSERT_X(strL.length() == 4, "MainWindow::strToRect", "strL does not have 4 strings!");

    return QRect(strL.at(0).toInt(),strL.at(1).toInt(), strL.at(2).toInt(), strL.at(3).toInt() );
}

MainWindow::~MainWindow()
{
    delete ui;
}
