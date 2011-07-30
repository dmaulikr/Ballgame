// ToDo:

// Create object templates for easy object creation
// Zoom in/out
// Create default propreties for new level
// Make it possible to move rotated objects
// Fix scrollbars defaulting to 0-0 upon updateGraphics() bug


#include "mainwindow.h"
#include "ui_mainwindow.h"

#define MINIMUM_WALL_THICKENESS 5

// THIS IS DEFINETELY NOT A PERMANENT SOLUTION!
#ifdef Q_WS_MAC
#define PATH_SPRITE_PLIST "../../../../../ballgame/Resources/BallGameSpriteSheet.plist"
#define PATH_SPRITE_IMAGE "../../../../../ballgame/Resources/BallGameSpriteSheet.png"
#define PATH_DEBUG_LEVEL "../../../../../ballgame/levels/DebugLevel.level"
#define PATH_BALLGAME_DIR "../../../../../ballgame/levels"
#else // assuming you're on Windows
#define PATH_SPRITE_PLIST "..\\..\\ballgame\\Resources\\BallGameSpriteSheet.plist"
#define PATH_SPRITE_IMAGE "..\\..\\ballgame\\Resources\\BallGameSpriteSheet.png"
#define PATH_DEBUG_LEVEL "..\\..\\ballgame\\levels\\DebugLevel.level"
#define PATH_BALLGAME_DIR "..\\..\\ballgame\\"
#endif

MainWindow::MainWindow(QWidget *parent) :
        QMainWindow(parent),
        ui(new Ui::MainWindow)
{
    currentFileName = "";

    ui->setupUi(this);

    loadFile();

    noEmit = false;

    connect(ui->graphicsView, SIGNAL(objectChanged(QString, int, QPointF, QSizeF)), this, SLOT(objectChanged(QString, int, QPointF, QSizeF)));
    connect(ui->graphicsView, SIGNAL(objectSelected(QString, int)), this, SLOT(objectSelected(QString, int)));
    connect(ui->graphicsView, SIGNAL(needToRescale(QString, int, double, double, bool)), this, SLOT(needToRescale(QString, int, double, double, bool)));

}

void MainWindow::loadFile()
{
    initializing = true;
    spriteSheet = QImage(PATH_SPRITE_IMAGE);

    loadSpritePlist();

    QString fileName = QFileDialog::getOpenFileName(this,
         tr("Open Level"), PATH_BALLGAME_DIR, tr("Level file (*.level)"));

    if(fileName == "") // no file selected
        return;

    currentFileName = fileName;

    loadLevelPlist(fileName);

    // populate tables
    updateLevelPlistTable();
    updateObjectTable(0);
    updateObjectComboBox();

    // draw objects on screen;
    scene = new QGraphicsScene();
    updateGraphics();
    initializing = false;

}

void MainWindow::updateGraphics()
{
    //int horizontalScrollBarPosition = ui->graphicsView->horizontalScrollBar()->sliderPosition();
    //int verticalScrollBarPosition = ui->graphicsView->verticalScrollBar()->sliderPosition();

    //qDebug("%d, %d", horizontalScrollBarPosition, verticalScrollBarPosition);

    // restatr scene
    QGraphicsScene *previousScene = scene;
    scene = new QGraphicsScene(0, 0, levelPlist.value("level_width").toInt(), levelPlist.value("level_height").toInt());

    // Add player object to scene
    QRect playerRect = spriteSheetLocations.value("player_amoeba.png");
    Q_ASSERT_X(playerRect != QRect(0,0,0,0), "MainWindow::loadFile()", "Could not find sprite location!");
    QImage player = spriteSheet.copy(playerRect);
    player = player.scaledToHeight(levelPlist.value("starting_size").toFloat());
    QGraphicsPixmapItem *item = scene->addPixmap(QPixmap::fromImage(player));
    int startX = levelPlist.value("start_x").toInt() - playerRect.width()/2;
    int startY = levelPlist.value("level_height").toInt() - (levelPlist.value("start_y").toInt() + playerRect.height()/2);
    item->setPos(startX, startY);
    item->setData(1, "player");     // type of object
    item->setData(2, -1);           // object id
    item->setData(3, false);        // is the object rotated?
    item->setData(4, QPoint(0,0));  // MouseOffset of the object (not used yet)

    for(int i = 0; i < levelObjects.length(); i++)
    {
        QRect objRect;
        objRect = spriteSheetLocations.value(levelObjects.at(i).value("frame_name"));

        //Q_ASSERT_X(objRect != QRect(0,0,0,0), "MainWindow::loadFile()", "Could not find sprite location!");
        QImage img = spriteSheet.copy(objRect);
        float height = levelObjects.at(i).value("height").toFloat();
        float width = levelObjects.at(i).value("width").toFloat();
        float x = levelObjects.at(i).value("x").toFloat();
        float y = levelObjects.at(i).value("y").toFloat();
        img = img.scaled(QSize(width, height), Qt::IgnoreAspectRatio);
        item = scene->addPixmap(QPixmap::fromImage(img));
        float xPos = x - width/2;
        float yPos = levelPlist.value("level_height").toFloat() - (y + height/2);

        // Rotate object around its own center as opposed to its top left corner
        float rotation = levelObjects[i].value("rotation").toFloat();
        float rotationRadians = (3.141592653/180) * rotation;
        float xShift = (width/2 * qCos(rotationRadians)) - (height/2 * qSin(rotationRadians)) - width/2;
        float yShift = (-width/2 * qSin(rotationRadians)) - (height/2 * qCos(rotationRadians)) + height/2;

        item->setPos((int)(xPos - xShift), (int)(yPos + yShift));
        item->setRotation((int)rotation);
        item->setData(1, "object");
        item->setData(2, i);
        item->setData(3, (rotation != 0 && rotation != 360));
        item->setData(4, QPoint(xShift, yShift));
    }

    QGraphicsView *view = ui->graphicsView;

    view->setScene(scene);
    view->setMaximumSize(levelPlist.value("level_width").toInt() + 2, levelPlist.value("level_height").toInt() + 3);

    // set background
    scene->setBackgroundBrush(Qt::black);

    // avoid memory leak.  We can't do this earlier, or the QGraphicsView resets its viewport.
    delete previousScene;
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
{
    int column = ui->levelPlistTableWidget->currentColumn();

    // Nothing selected, abort.
    if(column < 0)
        return;

    if(noEmit)
        return;
    noEmit = true;

    int row = ui->levelPlistTableWidget->currentRow();

    // iterate to the changed row

    QMap<QString, QString>::const_iterator it = levelPlist.constBegin();
    for(int i = 0; i < row; i++)
        ++it;

    if(column == 1)
    {
        levelPlist.insert(it.key(), newItem->text());
    }
    else if(column == 0)
    {
        QString value = levelPlist.value(it.key());
        levelPlist.remove(it.key());
        levelPlist.insert(newItem->text(), value);
    }

    updateGraphics();
    updateLevelPlistTable();

    noEmit = false;
}

void MainWindow::objectSelected(QString type, int id)
{
    if(type == "object")
    {
        ui->objectSelectorComboBox->setCurrentIndex(id);
        updateObjectTable(id);
    }
}

void MainWindow::needToRescale(QString type, int id, double scaleX, double scaleY, bool doublesOK)
{
    // ToDo:  rescale player

    int x = levelObjects[id].value("width").toFloat() * scaleX;
    int y = levelObjects[id].value("height").toFloat() * scaleY;

    if(x < 5) x = 5;
    if(y < 5) y = 5;

    float dX = x - levelObjects[id].value("width").toFloat();
    float dY = y - levelObjects[id].value("height").toFloat();

    float oldX = levelObjects[id].value("x").toFloat();
    float oldY = levelObjects[id].value("y").toFloat();

    float sPXn = (float)(oldX + dX/2);
    float sPYn = (float)(oldY - dY/2);

    if(!doublesOK)
    {
        sPXn = (int)sPXn;
        sPYn = (int)sPYn;
    }


    QString sX = QString::number(x);
    QString sY = QString::number(y);
    QString sPX = QString::number(sPXn);
    QString sPY = QString::number(sPYn);


    //qDebug("scaleX - %f, scaleY - %f", scaleX, scaleY);
    //qDebug(QString(sX + " " + sY + " " + sPX + " " + sPY).toAscii());
    //qDebug("%f, %f", sPXn, sPYn);

    levelObjects[id].insert("width", sX);
    levelObjects[id].insert("height", sY);
    levelObjects[id].insert("x", sPX);
    levelObjects[id].insert("y", sPY);

    updateGraphics();
    updateObjectTable(id);
}

void MainWindow::objectChanged(QString type, int id, QPointF pos, QSizeF size)
{
    //qDebug() << type << " " << id << " " << pos  << " " << size << endl;

    if(type == "player")
    {
        levelPlist.insert("start_x", QString::number(pos.x() + (int)(size.width() / 2)));
        QString num = QString::number(levelPlist.value("level_height").toFloat() - pos.y() - (int)(size.height() / 2));
        levelPlist.insert("start_y", num);

        // ToDo:  update size in level plist here

        updateLevelPlistTable();
    }

    else if(type == "object")
    {
        ui->objectSelectorComboBox->setCurrentIndex(id);
        levelObjects[id].insert("x", QString::number(pos.x() + (int)(size.width() / 2)));
        levelObjects[id].insert("y", QString::number(levelPlist.value("level_height").toFloat() - pos.y() - (int)(size.height() / 2)));

        levelObjects[id].insert("height", QString::number(size.height()));
        levelObjects[id].insert("width", QString::number(size.width()));

        updateObjectTable(id);
    }

    else
    {
        Q_ASSERT_X(false, "MainWindow::objectChanged", "Unknown object type!");
    }
}

void MainWindow::updateLevelPlistTable()
{
    noEmit = true;

    QTableWidget *table = ui->levelPlistTableWidget;

    int count = levelPlist.count();
    table->setRowCount(count);
    table->setColumnCount(2);

    QMap<QString, QString>::const_iterator i;
    int index = 0;

    for (i = levelPlist.constBegin(); i != levelPlist.constEnd(); ++i)
    {
        table->setItem(index, 0, new QTableWidgetItem(i.key()));
        table->setItem(index, 1, new QTableWidgetItem(i.value()));
        index++;
    }

    noEmit = false;
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

void MainWindow::rotationSliderMoved(int value)
{
    int objId = ui->objectSelectorComboBox->currentIndex();

    if(objId == -1) // nothing selected
        return;

    if(noEmit)
        return;
    noEmit = true;

    float rot = (value * 360.0 / 99);  // dividing by 99 instead of 100 so that 360 can actually be reached
    int rotation = (int)rot / 5 * 5;  // round to the nearest 5

    levelObjects[objId].insert("rotation", QString::number(rotation));

    updateGraphics();
    updateObjectTable(objId);

    noEmit = false;
}

void MainWindow::updateObjectTable(int objId)
{
    if(objId == -2 || levelObjects.count() <= objId)
    {
        clearObjectTable();
        return;
    }

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

    QString rotationStr = levelObjects[objId].value("rotation", "nil");
    if(rotationStr != "nil"){
        int rotation = rotationStr.toInt();
        ui->rotationLabel->setText(QString("Rotation - " + QString::number(rotation) + " degrees").toAscii());

        ui->rotationSlider->setValue(rotation / 3.6);
    }
}

void MainWindow::wallThicknessClicked()
{
    int thickness = ui->wallThicknessEdit->text().toInt();

    if(thickness <= 0) // invalid input
        return;

    for(int i = 0; i < levelObjects.count(); i++)
    {
        if(levelObjects[i].value("type").toLower() == "wall")
        {
            bool xSmaller = true;
            if(levelObjects[i].value("height").toInt() < levelObjects[i].value("width").toInt())
                xSmaller = false;

            if(xSmaller)
                levelObjects[i].insert("width", QString::number(thickness));
            else
                levelObjects[i].insert("height", QString::number(thickness));
        }
    }

    updateGraphics();
    updateObjectTable(ui->objectSelectorComboBox->currentIndex());
}

void MainWindow::newLevel()
{
    // ToDo:  implement "do you want to save?" here

    currentFileName = "";

    levelPlist = QMap<QString, QString>();
    levelObjects = QList< QMap<QString, QString> >();

    updateGraphics();
    clearObjectTable();
    updateLevelPlistTable();
    updateObjectComboBox();
}

void MainWindow::saveLevelPlist()
{
    if(currentFileName != "")
    {
        saveLevelPlist(currentFileName);
    }
    else
    {
        saveLevelPlistAs();
    }
}

void MainWindow::saveLevelPlistAs()
{
    QString fileName = QFileDialog::getSaveFileName(this, tr("Save Level"),
                                PATH_BALLGAME_DIR,
                                tr("Levels (*.level)"));

    if(fileName != "")
    {
        currentFileName = fileName;
        saveLevelPlist(fileName);
    }
}


void MainWindow::saveLevelPlist(QString filename)
{
    qDebug(filename.toAscii());
    QDomDocument doc("plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"");
    QDomElement root = doc.createElement("plist");
    doc.appendChild(root);

    QDomElement rootDict = doc.createElement("dict");
    root.appendChild(rootDict);

    QMap<QString, QString>::const_iterator i;
    for (i = levelPlist.constBegin(); i != levelPlist.constEnd(); ++i)
    {
        QDomElement tag = doc.createElement("key");
        rootDict.appendChild(tag);

        QDomText t = doc.createTextNode(i.key());
        tag.appendChild(t);

        tag = doc.createElement("string");
        if(i.value().toInt() != 0)
            tag = doc.createElement("integer");
        rootDict.appendChild(tag);

        t = doc.createTextNode(i.value());
        tag.appendChild(t);
    }

    QDomElement tag = doc.createElement("key");
    rootDict.appendChild(tag);

    QDomText t = doc.createTextNode("game_objects");
    tag.appendChild(t);

    QDomElement array = doc.createElement("array");
    rootDict.appendChild(array);

    for(int j = 0; j < levelObjects.count(); j++)
    {
        QDomElement dict = doc.createElement("dict");
        array.appendChild(dict);

        QMap<QString, QString>::const_iterator i;
        for (i = levelObjects.at(j).constBegin(); i != levelObjects.at(j).constEnd(); ++i)
        {
            tag = doc.createElement("key");
            dict.appendChild(tag);

            t = doc.createTextNode(i.key());
            tag.appendChild(t);

            tag = doc.createElement("string");
            if(i.value().toInt() != 0)
                tag = doc.createElement("integer");
            dict.appendChild(tag);

            t = doc.createTextNode(i.value());
            tag.appendChild(t);
        }
    }

    QFile data(filename);
    if (data.open(QFile::WriteOnly | QFile::Truncate))
    {
        QTextStream out(&data);
        out << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" << endl;
        //out << "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" << endl;
        doc.save(out, 1);
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

    levelPlist.clear();
    levelObjects.clear();

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

void MainWindow::addLevelPropertyClicked()
{
    if(noEmit)
        return;
    noEmit = true;

    levelPlist.insert("new_property", "null");

    updateGraphics();
    updateLevelPlistTable();

    noEmit = false;

}

void MainWindow::deleteLevelPropertyClicked()
{
    int row = ui->levelPlistTableWidget->currentRow();

    if(row == -1) // nothing selected
        return;

    if(noEmit)
        return;
    noEmit = true;

    // iterate to the deleted row
    QMap<QString, QString>::const_iterator it = levelPlist.constBegin();
    for(int i = 0; i < row; i++)
        ++it;

    levelPlist.remove(it.key());

    updateGraphics();
    updateLevelPlistTable();

    noEmit = false;





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

void MainWindow::quit()
{
    // ToDo:  Implement "do you want to save?" here

    exit(0);
}

MainWindow::~MainWindow()
{
    delete ui;
}
