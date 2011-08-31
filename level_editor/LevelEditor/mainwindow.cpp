// ToDo:

// Zoom in/out
// Create default propreties for new level
// Make it possible to move rotated objects

#include "mainwindow.h"
#include "ui_mainwindow.h"

#define MINIMUM_WALL_THICKENESS 5
#define MAX_UNDO_LIMIT 100

// How far away from the edge of the object to display the yellow box when it's selected
#define SELECTED_BOX_MARGIN 5

#define GRID_RESOLUTION 250

// The amount by which an object is translated from the original when it's copy/pasted
#define COPY_POSITION_INCREMENT 25

// THIS IS DEFINETELY NOT A PERMANENT SOLUTION!
#ifdef Q_WS_MAC
#define PATH_SPRITE_PLIST "../../../../../ballgame/Resources/BallGameSpriteSheet.plist"
#define PATH_SPRITE_IMAGE "../../../../../ballgame/Resources/BallGameSpriteSheet.png"
#define PATH_DEBUG_LEVEL "../../../../../ballgame/levels/DebugLevel.level"
#define PATH_BALLGAME_DIR "../../../../../ballgame/levels/"
#define PATH_OBJECT_TEMPLATES "../../../../object_templates/"
#else // assuming you're on Windows
#define PATH_SPRITE_PLIST "..\\..\\ballgame\\Resources\\BallGameSpriteSheet.plist"
#define PATH_SPRITE_IMAGE "..\\..\\ballgame\\Resources\\BallGameSpriteSheet.png"
#define PATH_DEBUG_LEVEL "..\\..\\ballgame\\levels\\DebugLevel.level"
#define PATH_BALLGAME_DIR "..\\..\\ballgame\\levels\\"
#define PATH_OBJECT_TEMPLATES "..\\object_templates\\"
#endif

MainWindow::MainWindow(QWidget *parent) :
        QMainWindow(parent),
        ui(new Ui::MainWindow)
{
    currentFileName = "";

    ui->setupUi(this);

    loadFile();

    noEmit = false;

    connect(ui->graphicsView, SIGNAL(objectChanged(QString, int, QPointF, QSizeF, bool)), this, SLOT(objectChanged(QString, int, QPointF, QSizeF, bool)));
    connect(ui->graphicsView, SIGNAL(objectSelected(QString, int)), this, SLOT(objectSelected(QString, int)));
    connect(ui->graphicsView, SIGNAL(needToRescale(QString, int, double, double, double, double, bool)), this, SLOT(needToRescale(QString, int, double, double, double, double, bool)));
    connect(ui->graphicsView, SIGNAL(needToUpdateGraphics()), this, SLOT(needToUpdateGraphics()));

    populateNewObjectList();

    // Set list pointer in LevelGraphicsView
    ui->graphicsView->setListPointer(&selectedObjects);
}

void MainWindow::loadFile()
{
    // Clean up previous level
    selectedObjects.clear();

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
    justLoaded = true;
    updateGraphics();
    initializing = false;
}

void MainWindow::updateGraphics()
{
    // restart scene
    QGraphicsScene *previousScene = scene;
    scene = new QGraphicsScene(0, 0, levelPlist.value("level_width").toInt(), levelPlist.value("level_height").toInt());

    // Add player object to scene
    QRect playerRect = spriteSheetLocations.value("Volt1.png");
    Q_ASSERT_X(playerRect != QRect(0,0,0,0), "MainWindow::loadFile()", "Could not find sprite location!");
    QImage player = spriteSheet.copy(playerRect);

    QGraphicsPixmapItem *item = scene->addPixmap(QPixmap::fromImage(player));
    item->setTransformOriginPoint(item->boundingRect().width()/2, item->boundingRect().height()/2);
    float scale = levelPlist.value("starting_size").toFloat() / playerRect.width();
    item->scale(scale, scale);
    int startX = levelPlist.value("start_x").toInt() - item->boundingRect().width()*scale/2;
    int startY = levelPlist.value("level_height").toInt() - (levelPlist.value("start_y").toInt() + item->boundingRect().height()*scale/2);
    item->setPos(startX, startY);
    item->setData(1, "player");     // type of object
    item->setData(2, -1);           // object id
    item->setData(3, false);        // is the object rotated?
    item->setData(4, QPoint(0,0));  // MouseOffset of the object (not used yet)

    // Add objects to scene
    for(int i = 0; i < levelObjects.length(); i++)
    {
        QRect objRect;
        objRect = spriteSheetLocations.value(levelObjects.at(i).value("frame_name").toString());

        // Make sure we are good to go
        Q_ASSERT_X(objRect != QRect(0,0,0,0), "MainWindow::loadFile()", "Could not find sprite location!");

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
        //float rotationRadians = (3.141592653/180) * rotation;
        //float xShift = (width/2 * qCos(rotationRadians)) - (height/2 * qSin(rotationRadians)) - width/2;
        //float yShift = (-width/2 * qSin(rotationRadians)) - (height/2 * qCos(rotationRadians)) + height/2;

        //item->setPos((int)(xPos - xShift), (int)(yPos + yShift));
        item->setPos((int)xPos, (int)yPos);
        item->setTransformOriginPoint(width/2, height/2);
        item->setRotation((int)rotation);
        item->setData(1, "object");
        item->setData(2, i);
        item->setData(3, (rotation != 0 && rotation != 360));
        //item->setData(4, QPoint(xShift, yShift));
    }

    // Display a yellow box around whichever objects are selected
    updateSelectedObjects(scene, false);

    // Display grid
    float levelHeight = levelPlist.value("level_height").toFloat();
    float levelWidth = levelPlist.value("level_width").toFloat();
    for(int i = 0; i < levelHeight; i += GRID_RESOLUTION)
    {
        scene->addLine(0, i, levelWidth, i, QPen(QColor(255, 255, 255, 50)));
    }
    for(int j = 0; j < levelWidth; j += GRID_RESOLUTION)
    {
        scene->addLine(j, 0, j, levelHeight, QPen(QColor(255, 255, 255, 50)));
    }

    // Display border of level
    QColor borderColor = QColor(50, 50, 255, 150);
    scene->addLine(0, 0, 0, levelHeight, QPen(borderColor));
    scene->addLine(levelWidth, levelHeight, 0, levelHeight, QPen(borderColor));
    scene->addLine(levelWidth, 0, levelWidth, levelHeight, QPen(borderColor));
    scene->addLine(0, 0, levelWidth, 0, QPen(borderColor));

    // Setup graphics view with the newly created scene
    QGraphicsView *view = ui->graphicsView;
    view->setScene(scene);
    view->setMaximumSize(levelPlist.value("level_width").toInt() + 2, levelPlist.value("level_height").toInt() + 3);

    // If we just loaded the level, zoom out all the way.
    if(justLoaded)
    {
        justLoaded = false;
        view->fitInView(0, 0, levelPlist.value("level_width").toInt(), levelPlist.value("level_height").toInt(), Qt::KeepAspectRatio);
    }

    // set background
    scene->setBackgroundBrush(Qt::black);

    // avoid memory leak.  We can't do this earlier, or the QGraphicsView resets its viewport.
    delete previousScene;
}

void MainWindow::updateSelectedObjects(QGraphicsScene *scene, bool removePrevious)
{
    // If scene doesn't exist, don't do anything
    if(!scene)
        return;

    // Clear existing lines
    if(removePrevious)
    {
        for(int i = 0; i < sceneYellowLines.length(); i++)
        {
            scene->removeItem(sceneYellowLines.at(i));
        }
    }
    sceneYellowLines.clear();

    // Draw new lines
    for(int i = 0; i < selectedObjects.length(); i++)
    {
        int index = selectedObjects[i];
        float height, width, x, y;
        if(index == -1) // player is selected
        {
            height = levelPlist.value("starting_size").toFloat();
            width = height;
            x = levelPlist.value("start_x").toFloat() - width/2;
            y = levelPlist.value("level_height").toFloat() - (levelPlist.value("start_y").toFloat() + height/2);
        }
        else // object is selected
        {
            height = levelObjects.at(index).value("height").toFloat();
            width = levelObjects.at(index).value("width").toFloat();
            x = levelObjects.at(index).value("x").toFloat() - width/2;
            y = levelPlist.value("level_height").toFloat() - (levelObjects.at(index).value("y").toFloat() + height/2);
        }

        // Define unrotated points
        float x1Unrot = x - SELECTED_BOX_MARGIN;
        float y1Unrot = y - SELECTED_BOX_MARGIN;
        float x2Unrot = x - SELECTED_BOX_MARGIN;
        float y2Unrot = y+height+SELECTED_BOX_MARGIN;
        float x3Unrot = x+width+SELECTED_BOX_MARGIN;
        float y3Unrot = y+height+SELECTED_BOX_MARGIN;
        float x4Unrot = x+width+SELECTED_BOX_MARGIN;
        float y4Unrot = y - SELECTED_BOX_MARGIN;

        float angle = 0;
        if(index != -1 && levelObjects.at(index).contains("rotation"))
            angle = levelObjects.at(index).value("rotation").toFloat() * 3.14159265 / 180;

        float positionX, positionY;
        if(index != -1) // If we are not the player
        {
            positionX = levelObjects.at(index).value("x").toFloat();
            positionY = levelPlist.value("level_height").toFloat() - (levelObjects.at(index).value("y").toFloat());
        }
        else // we are the player
        {
            positionX = levelPlist.value("start_x").toFloat() - width;
            positionY = levelPlist.value("level_height").toFloat() - (levelPlist.value("start_y").toFloat() + height);
        }

        float x1 = (x1Unrot - positionX) * cos(angle) - (y1Unrot - positionY) * sin(angle) + positionX;
        float y1 = (x1Unrot - positionX) * sin(angle) + (y1Unrot - positionY) * cos(angle) + positionY;
        float x2 = (x2Unrot - positionX) * cos(angle) - (y2Unrot - positionY) * sin(angle) + positionX;
        float y2 = (x2Unrot - positionX) * sin(angle) + (y2Unrot - positionY) * cos(angle) + positionY;
        float x3 = (x3Unrot - positionX) * cos(angle) - (y3Unrot - positionY) * sin(angle) + positionX;
        float y3 = (x3Unrot - positionX) * sin(angle) + (y3Unrot - positionY) * cos(angle) + positionY;
        float x4 = (x4Unrot - positionX) * cos(angle) - (y4Unrot - positionY) * sin(angle) + positionX;
        float y4 = (x4Unrot - positionX) * sin(angle) + (y4Unrot - positionY) * cos(angle) + positionY;

        sceneYellowLines.append(scene->addLine(x1, y1, x2, y2, QPen(Qt::yellow)));
        sceneYellowLines.append(scene->addLine(x2, y2, x3, y3, QPen(Qt::yellow)));
        sceneYellowLines.append(scene->addLine(x3, y3, x4, y4, QPen(Qt::yellow)));
        sceneYellowLines.append(scene->addLine(x4, y4, x1, y1, QPen(Qt::yellow)));
    }
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

        // 2 is the index of the Rect string in the sub-dicts.
        for(int i = 0; i < 1; i++)
            m = m.nextSibling();

        //qDebug(m.toElement().text().toAscii());

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

    // Push an Undo object
    pushUndo();

    // iterate to the changed row
    QMap<QString, QVariant>::const_iterator it = levelObjects[objId].constBegin();
    for(int i = 0; i < row; i++)
        ++it;

    if(column == 1)
    {
        levelObjects[objId].insert(it.key(), newItem->text());
    }
    else if(column == 0)
    {
        QString value = levelObjects[objId].value(it.key()).toString();
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

    // Push an Undo object
    pushUndo();

    int row = ui->levelPlistTableWidget->currentRow();

    // iterate to the changed row

    QMap<QString, QVariant>::const_iterator it = levelPlist.constBegin();
    for(int i = 0; i < row; i++)
        ++it;

    if(column == 1)
    {
        levelPlist.insert(it.key(), newItem->text());
    }
    else if(column == 0)
    {
        QString value = levelPlist.value(it.key()).toString();
        levelPlist.remove(it.key());
        levelPlist.insert(newItem->text(), value);
    }

    updateGraphics();
    updateLevelPlistTable();

    noEmit = false;
}

void MainWindow::objectSelected(QString type, int id)
{
    // Push Undo object
    pushUndo();

    if(noEmit)
        return;
    noEmit = true;

    if(type == "object")
    {
        ui->objectSelectorComboBox->setCurrentIndex(id);
        updateObjectTable(id);
    }

    ui->levelPlistTableWidget->setCurrentCell(-1, -1);
    ui->objectsTableWidget->setCurrentCell(-1, -1);

    noEmit = false;
    //updateGraphics();
}

void MainWindow::needToRescale(QString type, int id, double width, double height, double x, double y, bool objectStillDragging)
{
    // Invert y
    y = levelPlist.value("level_height").toInt() - y;

    if(!objectStillDragging)
    {
        width = (int) width;
        height = (int) height;
        x = (int) x;
        y = (int) y;
    }

    QString sWidth = QString::number(width);
    QString sHeight = QString::number(height);
    QString sX = QString::number(x);
    QString sY = QString::number(y);

    // If we are the player
    if(id == -1)
    {
        levelPlist.insert("starting_size", sHeight);
        levelPlist.insert("start_x", sX);
        levelPlist.insert("start_y", sY);

        // Update UI with new size and position
        updateLevelPlistTable();
    }

    // We are not the player
    else
    {
        levelObjects[id].insert("width", sWidth);
        levelObjects[id].insert("height", sHeight);
        levelObjects[id].insert("x", sX);
        levelObjects[id].insert("y", sY);

        // Update UI with new size and position
        updateObjectTable(id);
    }

    // Enormous performance boost
    if(!objectStillDragging)
    {
        updateGraphics();
    }
    else
    {
        updateSelectedObjects(ui->graphicsView->scene(), true);
    }

}

void MainWindow::objectChanged(QString type, int id, QPointF pos, QSizeF size, bool objectStillDragging)
{
    if(type == "player")
    {
        // This is disgusting, but I can't think of a better way to do it.  Good luck.
        QRect playerRect = spriteSheetLocations.value("Volt1.png");
        float scale = levelPlist.value("starting_size").toFloat() / playerRect.width();

        float posX = pos.x() + size.width()*scale/2;
        float posY = levelPlist.value("level_height").toFloat() - pos.y() - size.height()*scale/2;

        // If we let go of the object, round to the nearest int
        if(!objectStillDragging)
        {
            posX = (int)(posX - .5) + 1;
            posY = (int)(posY - .5) + 1;
        }

        levelPlist.insert("start_x", QString::number(posX));
        levelPlist.insert("start_y", QString::number(posY));

        // ToDo:  update size in level plist here

        updateLevelPlistTable();
    }

    else if(type == "object")
    {
        noEmit = true;
        ui->objectSelectorComboBox->setCurrentIndex(id);
        noEmit = false;

        float posX = pos.x() + size.width() / 2;
        float posY = levelPlist.value("level_height").toFloat() - pos.y() - size.height() / 2;

        // If we let go of the object, round to the nearest int
        if(!objectStillDragging)
        {
            posX = (int)(posX - .5) + 1;
            posY = (int)(posY - .5) + 1;
        }

        levelObjects[id].insert("x", QString::number(posX));
        levelObjects[id].insert("y", QString::number(posY));

        levelObjects[id].insert("height", QString::number(size.height()));
        levelObjects[id].insert("width", QString::number(size.width()));

        updateObjectTable(id);
    }

    else
    {
        Q_ASSERT_X(false, "MainWindow::objectChanged", "Unknown object type!");
    }

    // Updating graphics every frame is an enormous performance lag.
    if(!objectStillDragging)
    {
        updateGraphics();
    }
    else
    {
        updateSelectedObjects(ui->graphicsView->scene(), true);
    }
}

void MainWindow::updateLevelPlistTable()
{
    noEmit = true;

    QTableWidget *table = ui->levelPlistTableWidget;

    int count = levelPlist.count();
    table->setRowCount(count);
    table->setColumnCount(2);

    QMap<QString, QVariant>::const_iterator i;
    int index = 0;

    for (i = levelPlist.constBegin(); i != levelPlist.constEnd(); ++i)
    {
        table->setItem(index, 0, new QTableWidgetItem(i.key()));

        if(i.value().type() == QVariant::String)
        {
            table->setItem(index, 1, new QTableWidgetItem(i.value().toString()));
        }
        else if(i.value().type() == QVariant::List)
        {
            table->setItem(index, 1, new QTableWidgetItem(QString("Click to edit")));
        }
        else
        {
            Q_ASSERT_X(false, "MainWindow::updateObjectTable", "Unknown QVariant type!");
        }
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
        comboBox->addItem(QString(levelObjects.at(i).value("type").toString() + " - " + levelObjects.at(i).value("name").toString()));
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

    // Push an Undo object
    pushUndo();

    float rot = (value * 360.0 / 99);  // dividing by 99 instead of 100 so that 360 can actually be reached
    int rotation = (int)rot / 5 * 5;  // round to the nearest 5

    levelObjects[objId].insert("rotation", QString::number(rotation));

    updateGraphics();

    noEmit = false;

    updateObjectTable(objId);


}

void MainWindow::comboBoxChanged(int objId)
{
    if(noEmit)
        return;

    // Show item as selected in graphics view
    selectedObjects.clear();
    if(objId != -1)
        selectedObjects.append(objId);
    updateSelectedObjects(ui->graphicsView->scene(), true);

    updateObjectTable(objId);
}

void MainWindow::updateObjectTable(int objId)
{
    if(noEmit)
        return;

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

    QMap<QString, QVariant>::const_iterator it;
    for (it = levelObjects.at(objId).constBegin(); it != levelObjects.at(objId).constEnd(); ++it)
    {
        rowCount++;
        table->setRowCount(rowCount);

        table->setItem(rowCount-1, 0, new QTableWidgetItem(it.key()));

        if(it.value().type() == QVariant::String)
        {
            table->setItem(rowCount-1, 1, new QTableWidgetItem(it.value().toString()));
        }
        else if(it.value().type() == QVariant::List)
        {
            table->setItem(rowCount-1, 1, new QTableWidgetItem(QString("Click to edit")));
        }
        else
        {
            Q_ASSERT_X(false, "MainWindow::updateObjectTable", "Unknown QVariant type!");
        }
    }

    QString rotationStr = levelObjects[objId].value("rotation", "nil").toString();
    if(rotationStr != "nil"){
        int rotation = rotationStr.toInt();
        ui->rotationLabel->setText(QString("Rotation - " + QString::number(rotation) + " degrees").toAscii());

        ui->rotationSlider->setValue(rotation / 3.6);
    }
}

void MainWindow::objectTableClicked(int x, int y)
{
    int objId = ui->objectSelectorComboBox->currentIndex();

    // Iterate to correct item
    QMap<QString, QVariant>::const_iterator it = levelObjects.at(objId).constBegin();
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
    sub->loadData(it.value().toList(), objId, x, this);
    sub->show();
}

void MainWindow::levelPlistTableClicked(int x, int y)
{
    // Iterate to correct item
    QMap<QString, QVariant>::const_iterator it = levelPlist.constBegin();
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
    sub->loadData(it.value().toList(), 0, x, this);
    sub->show();
}

void MainWindow::wallThicknessClicked()
{
    qDebug("Triggered");

    // Push an Undo object
    pushUndo();

    int thickness = ui->wallThicknessEdit->text().toInt();

    if(thickness <= 0) // invalid input
        return;

    for(int i = 0; i < levelObjects.count(); i++)
    {
        if(levelObjects[i].value("type").toString().toLower().contains("wall"))
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

void MainWindow::doneEditingSublist(QList<QVariant> list, int objId, int objProp)
{
    qDebug("Signal received!");

    // iterate to the changed row
    QMap<QString, QVariant>::iterator it = levelObjects[objId].begin();
    for(int i = 0; i < objProp; i++)
        ++it;

    QString name = it.key();

    levelObjects[objId].insert(name, list);

    updateGraphics();
    updateObjectComboBox();
    updateObjectTable(ui->objectSelectorComboBox->currentIndex());

}

void MainWindow::newLevel()
{
    // ToDo:  implement "do you want to save?" here

    currentFileName = "";
    QString levelPlistPath = QString(PATH_OBJECT_TEMPLATES) + QString("TemplateLevel.level");
    loadLevelPlist(levelPlistPath);
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






void MainWindow::addPropertyClicked()
{
    // Push an Undo object
    pushUndo();

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
    // Push an Undo object
    pushUndo();

    int row = ui->objectsTableWidget->currentRow();
    int objId = ui->objectSelectorComboBox->currentIndex();

    if(objId == -1 || row == -1) // nothing selected
        return;

    // iterate to the deleted row
    QMap<QString, QVariant>::const_iterator it = levelObjects[objId].constBegin();
    for(int i = 0; i < row; i++)
        ++it;

    levelObjects[objId].remove(it.key());

    updateGraphics();
    updateObjectComboBox();
    updateObjectTable(objId);

}

void MainWindow::newObjectClicked()
{
    // Push an Undo object
    pushUndo();

    levelObjects.append(QMap<QString, QVariant>());

    updateGraphics();
    updateObjectComboBox();

    ui->objectSelectorComboBox->setCurrentIndex(levelObjects.count()-1);
    updateObjectTable(levelObjects.count() - 1);
}

void MainWindow::createCopyOfObjects(QList<int> objects)
{
    selectedObjects.clear();

    for(int i = 0; i < objects.count(); i++)
    {
        int index = objects.at(i);
        levelObjects.append(QMap<QString, QVariant>(levelObjects[index]));

        // Rename copy
        QString newName = levelObjects[levelObjects.count()-1].value("name").toString();
        newName = getNameForCopy(newName);

        // Update name
        levelObjects[levelObjects.count()-1].insert("name", newName);

        // Increment x and y by some amount
        int newX = levelObjects[levelObjects.count()-1].value("x").toInt() + COPY_POSITION_INCREMENT;
        int newY = levelObjects[levelObjects.count()-1].value("y").toInt() + COPY_POSITION_INCREMENT;
        levelObjects[levelObjects.count()-1].insert("x", QString("%1").arg(newX));
        levelObjects[levelObjects.count()-1].insert("y", QString("%1").arg(newY));

        // Make sure object is selected when we're done
        selectedObjects.append(levelObjects.count()-1);
    }

    updateGraphics();
    noEmit = true;
    updateObjectComboBox();
    ui->objectSelectorComboBox->setCurrentIndex(levelObjects.count()-1);
    noEmit = false;
}

void MainWindow::saveLevelPlist(QString filename)
{
    QDomDocument doc("plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"");
    QDomElement root = doc.createElement("plist");
    doc.appendChild(root);

    // Temporarily add game objects back to level plist
    QList<QVariant> tempList;
    for(int i = 0; i < levelObjects.size(); i++)
    {
        tempList.append(levelObjects.at(i));
    }
    levelPlist.insert("game_objects", tempList);

    // Save levelPlist
    root.appendChild(saveDictionary(levelPlist, doc));

    QFile data(filename);
    if (data.open(QFile::WriteOnly | QFile::Truncate))
    {
        QTextStream out(&data);
        out << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" << endl;
        //out << "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" << endl;
        doc.save(out, 1);
    }

    // Remove game objects from level plist again
    levelPlist.remove("game_objects");

}

QDomElement MainWindow::saveDictionary(QMap<QString, QVariant> inputDict, QDomDocument doc)
{
    QDomElement rootDict = doc.createElement("dict");

    QMap<QString, QVariant>::const_iterator i;
    for (i = inputDict.constBegin(); i != inputDict.constEnd(); ++i)
    {
        QDomElement tag = doc.createElement("key");
        rootDict.appendChild(tag);

        QDomText t = doc.createTextNode(i.key());
        tag.appendChild(t);

        if(i.value().toInt() != 0)
        {
            tag = doc.createElement("integer");
            rootDict.appendChild(tag);
            t = doc.createTextNode(i.value().toString());
            tag.appendChild(t);
        }
        else if(i.value().toFloat() != 0)
        {
            tag = doc.createElement("real");
            rootDict.appendChild(tag);
            t = doc.createTextNode(i.value().toString());
            tag.appendChild(t);
        }
        else if(i.value().type() == QVariant::List)
        {
            rootDict.appendChild(saveArray(i.value().toList(), doc));
        }
        else if(i.value().type() == QVariant::Map)
        {
            rootDict.appendChild(saveDictionary(i.value().toMap(), doc));
        }
        else // Assuming it's a string
        {
            tag = doc.createElement("string");
            rootDict.appendChild(tag);
            t = doc.createTextNode(i.value().toString());
            tag.appendChild(t);
        }
    }

    return rootDict;
}

QDomElement MainWindow::saveArray(QList<QVariant> list, QDomDocument doc)
{
    QDomElement rootArray = doc.createElement("array");

    for(int i = 0; i < list.count(); i++)
    {
        if(list.at(i).type() == QVariant::Map)
        {
            rootArray.appendChild(saveDictionary(list.at(i).toMap(), doc));
        }
        else if(list.at(i).type() == QVariant::List)
        {
            rootArray.appendChild(saveArray(list.at(i).toList(), doc));
        }
        else if(list.at(i).toInt() != 0)
        {
            QDomElement tag = doc.createElement("integer");
            rootArray.appendChild(tag);
            QDomText t = doc.createTextNode(list.at(i).toString());
            tag.appendChild(t);
        }
        else if(list.at(i).toFloat() != 0)
        {
            QDomElement tag = doc.createElement("real");
            rootArray.appendChild(tag);
            QDomText t = doc.createTextNode(list.at(i).toString());
            tag.appendChild(t);
        }
        else
        {
            QDomElement tag = doc.createElement("string");
            rootArray.appendChild(tag);
            QDomText t = doc.createTextNode(list.at(i).toString());
            tag.appendChild(t);
        }
    }

    return rootArray;
}

void MainWindow::loadLevelPlist(QString level)
{
    QDomDocument doc("Level Plist");
    QFile file(level);
    if (!file.open(QIODevice::ReadOnly))
        return;
    if (!doc.setContent(&file)) {
        file.close();
        return;
    }
    file.close();

    // Clear selected objects from previous level (if any)
    selectedObjects.clear();

    levelPlist.clear();
    levelObjects.clear();

    // Load top level.
    QDomElement docElem = doc.documentElement();

    // This is the uppermost dictionary
    QDomNode n = docElem.firstChild();

    // Load level
    levelPlist = loadDictionary(n);

    // Extract game objects from levelPlist
    QList<QVariant> tempList = levelPlist.value("game_objects").toList();
    for(int i = 0; i < tempList.size(); i++)
    {
        levelObjects.append(tempList.at(i).toMap());
    }
    levelPlist.remove("game_objects");
}

QMap<QString, QVariant> MainWindow::loadDictionary(QDomNode n)
{
    QString itemName = "", itemTag = "", itemContents = "";
    QMap<QString, QVariant> returnMap;

    // Get first element of dictionary
    n = n.firstChild();

    while(!n.isNull()) {
        // Try to convert the node to an element.
        QDomElement e = n.toElement();

        // The node really is an element.
        if(!e.isNull()) {

            itemName = qPrintable(e.text());
            itemTag = qPrintable(e.tagName());

            Q_ASSERT_X(itemTag == "key", "MainWindow::loadLevelPlist", "Tag should be a key, but isn't!");

            n = n.nextSibling();
            e = n.toElement();
            itemContents = qPrintable(e.text());
            itemTag = qPrintable(e.tagName());

            // Simple case (either string or number)
            if(itemTag != "array" && itemTag != "dict")
            {
                returnMap.insert(itemName, itemContents);
            }

            // Do we have an array?
            else if(itemTag == "array")
            {
                returnMap.insert(itemName, loadArray(n));
            }

            // Else, we have a dictionary.  Let the recursion begin.
            else
            {
                returnMap.insert(itemName, loadDictionary(n));
            }

            n = n.nextSibling();
        }
    }

    return returnMap;
}

QList<QVariant> MainWindow::loadArray(QDomNode n)
{
    QString itemName = "", itemTag = "";
    QList< QVariant > returnArray;

    // Get first item of array
    QDomNode m = n.firstChild();

    while(!m.isNull())
    {
        // Try to convert the node to an element.
        QDomElement e = m.toElement();

        // The node really is an element.
        if(!e.isNull()) {

            itemName = qPrintable(e.text());
            itemTag = qPrintable(e.tagName());

            if(itemTag == "array")
            {
                returnArray.append(loadArray(m));
            }
            else if(itemTag == "dict")
            {
                returnArray.append(loadDictionary(m));
            }
            else
            {
                returnArray.append(itemName);
            }
        }

        m = m.nextSibling();
    }

    return returnArray;
}

void MainWindow::deleteObjectClicked()
{
    if(selectedObjects.count() == 0) // nothing selected
        return;

    // Push an Undo object
    pushUndo();

    // Sort Selected Objects backwards so we can remove safely below (Whee, Bubblesort!)
    for(int i = 0; i < selectedObjects.count(); i++)
    {
        for(int j = i; j < selectedObjects.count(); j++)
        {
            if(selectedObjects[i] < selectedObjects[j])
            {
                int temp = selectedObjects[i];
                selectedObjects[i] = selectedObjects[j];
                selectedObjects[j] = temp;
            }
        }
    }

    for(int i = 0; i < selectedObjects.count(); i++)
    {
        // This is safe because we just sorted :P
        levelObjects.removeAt(selectedObjects[i]);
    }
    selectedObjects.clear();

    // Make sure we can't paste anything after this without re-copying
    copyObjects.clear();

    if(noEmit)
        return;
    noEmit = true;

    updateGraphics();
    updateObjectComboBox();

    if(levelObjects.count() != 0)
    {
        ui->objectSelectorComboBox->setCurrentIndex(0);
        updateObjectTable(0);
    }
    else
    {
        clearObjectTable();
    }

    noEmit = false;
}

void MainWindow::addLevelPropertyClicked()
{
    if(noEmit)
        return;
    noEmit = true;

    // Push an Undo object
    pushUndo();

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

    // Push an Undo object
    pushUndo();

    // iterate to the deleted row
    QMap<QString, QVariant>::const_iterator it = levelPlist.constBegin();
    for(int i = 0; i < row; i++)
        ++it;

    levelPlist.remove(it.key());

    updateGraphics();
    updateLevelPlistTable();

    noEmit = false;
}

void MainWindow::pushUndo(bool clearRedoStack)
{
    // Save backup
    if(currentFileName != "")
        saveLevelPlist(QString(currentFileName + ".backup"));

    // Save current state as an UndoObject
    UndoObject u;
    u.levelObjects = levelObjects;
    u.levelPlist = levelPlist;
    u.selectedObjects = selectedObjects;

    // Push undo object onto undo stack
    undoStack.push(u);

    // Clear redo stack
    if(clearRedoStack)
        redoStack.clear();

    // Clear out bottom of undo stack if necessary
    while(undoStack.count() > MAX_UNDO_LIMIT)
    {
        undoStack.pop_front();
    }

    //qDebug(QString("Pushed Undo - %1").arg(undoStack.count()).toAscii());
}

void MainWindow::popUndo()
{

    if(!undoStack.isEmpty())
    {
        UndoObject u = undoStack.pop();

        // Redo functionality
        UndoObject r;
        r.levelObjects = levelObjects;
        r.levelPlist = levelPlist;
        r.selectedObjects = selectedObjects;
        redoStack.push(r);

        // Restore state from undo object
        levelObjects = u.levelObjects;
        levelPlist = u.levelPlist;
        selectedObjects = u.selectedObjects;

        // Make sure we don't end up in an infinite loop
        noEmit = true;

        // Update stuff to reflect new state
        updateGraphics();
        updateObjectComboBox();
        updateLevelPlistTable();
        if(selectedObjects.length() > 0)
        {
            if(selectedObjects[0] != -1) // not the player
            {
                ui->objectSelectorComboBox->setCurrentIndex(selectedObjects[0]);
                updateObjectTable(selectedObjects[0]);
            }
            else
            {
                ui->objectSelectorComboBox->setCurrentIndex(0);
                updateObjectTable(0);
            }
        }
        else
        {
            ui->objectSelectorComboBox->setCurrentIndex(0);
            updateObjectTable(0);
        }

        noEmit = false;
    }
    else
    {
        QMessageBox msgBox;
        msgBox.setText("Nothing to undo!");
        msgBox.setIcon(QMessageBox::Warning);
        msgBox.exec();
    }

    //qDebug(QString("Popped Undo - %1").arg(undoStack.count()).toAscii());
}

void MainWindow::undoClicked()
{
    popUndo();
}

void MainWindow::redoClicked()
{
    if(!redoStack.isEmpty())
    {
        UndoObject r = redoStack.pop();

        // Push current state to undo stack
        pushUndo(false);

        // Restore state from undo object
        levelObjects = r.levelObjects;
        levelPlist = r.levelPlist;
        selectedObjects = r.selectedObjects;

        // Make sure we don't end up in an infinite loop
        noEmit = true;

        // Update stuff to reflect new state
        updateGraphics();
        updateObjectComboBox();
        updateLevelPlistTable();
        if(selectedObjects.length() > 0)
        {
            ui->objectSelectorComboBox->setCurrentIndex(selectedObjects[0]);
            updateObjectTable(selectedObjects[0]);
        }
        else
        {
            ui->objectSelectorComboBox->setCurrentIndex(0);
            updateObjectTable(0);
        }

        noEmit = false;
    }
    else
    {
        QMessageBox msgBox;
        msgBox.setText("Nothing to redo!");
        msgBox.setIcon(QMessageBox::Warning);
        msgBox.exec();
    }
}

void MainWindow::deleteClicked()
{
    // If we are in the objects tab
    if(ui->tabWidget->currentIndex() == 0)
    {
        int index = ui->objectsTableWidget->currentRow();

        // If something is selected
        if(index != -1)
            deletePropertyClicked();

        else
            deleteObjectClicked();
    }

    // Else we are in the level properties tab
    else
    {
        int index = ui->levelPlistTableWidget->currentRow();

        // If something is selected
        if(index != -1)
            deleteLevelPropertyClicked();

        else
            deleteObjectClicked();
    }
}

void MainWindow::copyClicked()
{
    copyObjects = selectedObjects;
}

void MainWindow::pasteClicked()
{
    createCopyOfObjects(copyObjects);
}

void MainWindow::populateNewObjectList()
{
    ui->newObjectListWidget->clear();

    // Get list of files in directory
    QDir dir = QDir(PATH_OBJECT_TEMPLATES);
    dir.setFilter(QDir::Files);
    QList<QString> fileList = dir.entryList();

    // Add each filename to the list
    for(int i = 0; i < fileList.count(); i++)
    {
        QString name = fileList[i];

        // If it's not a .template file, skip it
        int index = name.lastIndexOf(".template");
        if(index == -1)
            continue;

        // Get rid of ".template" at the end
        name = name.left(index);

        // Add it to the list
        ui->newObjectListWidget->addItem(name);
    }
}

void MainWindow::newObjectClicked(QModelIndex index)
{
    // Make sure we can undo this later
    pushUndo();

    // Get filename of object template
    QString filename = QString(PATH_OBJECT_TEMPLATES + ui->newObjectListWidget->currentItem()->text() + ".template");

    // Construct new object from template file
    QMap<QString, QVariant> newObject = loadObjectFromTemplateFile(filename);

    // Get center of viewport
    QRect rect = ui->graphicsView->rect();
    int newX = ui->graphicsView->horizontalScrollBar()->value() + rect.width() / 2;
    int newY = levelPlist.value("level_height").toInt() - ui->graphicsView->verticalScrollBar()->value() - rect.height() / 2;

    // Rename object
    newObject.insert("name", getNameForCopy(newObject.value("name").toString()));

    // Set object's x/y to center of viewport
    if(newObject.contains("x"))
        newObject.insert("x", QString("%1").arg(newX));
    if(newObject.contains("y"))
        newObject.insert("y", QString("%1").arg(newY));

    // Add new object to levelObjects
    levelObjects.append(newObject);

    // Update display
    ui->objectSelectorComboBox->setCurrentIndex(ui->objectSelectorComboBox->count() - 1);
    updateGraphics();
    updateObjectComboBox();
}

QMap<QString, QVariant> MainWindow::loadObjectFromTemplateFile(QString filename)
{
    QDomDocument doc("New Object");
    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly))
        return QMap<QString, QVariant>();
    if (!doc.setContent(&file)) {
        file.close();
        return QMap<QString, QVariant>();
    }
    file.close();

    QMap<QString, QVariant> newObject;
    QString itemName = "null";
    QString itemName2 = "null";
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

            Q_ASSERT_X(itemTag == "key", "MainWindow::loadObjectFromTemplateFile", "Tag should be a key, but isn't!");

            n = n.nextSibling();
            e = n.toElement();
            itemContents = qPrintable(e.text());
            itemTag = qPrintable(e.tagName());
            if(itemTag != "array")
            {
                newObject.insert(itemName, itemContents);
            }
            else
            {
                QList< QVariant > subList;
                QDomNode x = e.firstChild(); // guessing here...
                while(!x.isNull())
                {
                    QMap<QString, QVariant> newMap;
                    QDomNode p = x.firstChild();
                    while(!p.isNull())
                    {
                        QDomElement g = p.toElement(); // try to convert the node to an element.
                        if(!g.isNull()) {

                            itemName2 = qPrintable(g.text()); // the node really is an element.
                            itemTag = qPrintable(g.tagName());

                            Q_ASSERT_X(itemTag == "key", "MainWindow::loadLevelPlist", "Level object tag should be a key, but isn't!");

                            p = p.nextSibling();
                            g = p.toElement();
                            itemContents = qPrintable(g.text());
                            itemTag = qPrintable(g.tagName());

                            newMap.insert(itemName2, itemContents);

                            p = p.nextSibling();
                        }
                    } // while object dict is not done

                    subList.append(newMap);
                    x = x.nextSibling();
                }

                newObject.insert(itemName, subList);
            }

            n = n.nextSibling();
        }
    }

    return newObject;
}

void MainWindow::needToUpdateGraphics()
{
    updateGraphics();
}

QString MainWindow::getNameForCopy(QString newName)
{
    // Determine how many digits the number at the end is (could be 0)
    int count = 0;
    while(newName.right(count+1).toInt() != 0)
    {
        count++;
    }

    // Trim number off the end of the string
    newName = newName.left(newName.length() - count);

    // If the last character is not a space, add one
    if(newName.right(1) != " ")
        newName = newName + " ";

    // Find first name that doesn't exist yet
    count = 1;
    bool found;
    do
    {
        count++;
        found = false;
        QString tempStr = newName;
        tempStr.append(QString("%1").arg(count));
        for(int i = 0; i < levelObjects.count(); i++)
        {
            if(levelObjects[i].value("name") == tempStr)
            {
                found = true;
                continue;
            }
        }
    } while(found);

    newName.append(QString("%1").arg(count));

    return newName;
}

// Helper function to convert string to rect
QRect MainWindow::strToRect(QString in)
{
    in.replace("{", " ");
    in.replace("}", " ");
    in.replace(",", " ");

    // Replace all whitespace with a single space
    in.replace(QRegExp("\\s+"), " ");

    QStringList strL = in.split(" ");

    // For some reason, strL(0) and strL(last) are some kind of empty string
    Q_ASSERT_X(strL.length() == 6, "MainWindow::strToRect", "strL does not have 4 strings!");

    return QRect(strL.at(1).toInt(),strL.at(2).toInt(), strL.at(3).toInt(), strL.at(4).toInt() );
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
