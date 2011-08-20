#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QGraphicsView>
#include <QGraphicsScene>
#include <QtXml/QDomDocument>
#include <QFile>
#include <QHash>
#include <QList>
#include <QGraphicsPixmapItem>
#include <QTableWidgetItem>
#include <QComboBox>
#include <QDebug>
#include <QFileDialog>
#include <QtCore/qmath.h>
#include <QScrollBar>
#include <QMessageBox>
#include <QStack>
#include <QVariant>
#include <QDir>

#include "subarrayeditwindow.h"

namespace Ui {
    class MainWindow;
}

struct UndoObject
{
    QMap<QString, QString> levelPlist;
    QList< QMap<QString, QVariant> > levelObjects;
    QList<int> selectedObjects;
};

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();


private slots:
    // File Menu
    void loadFile();
    void saveLevelPlist();
    void saveLevelPlistAs();
    void newLevel();
    void quit();

    // Edit Menu
    void undoClicked();
    void redoClicked();
    void deleteClicked();
    void copyClicked();
    void pasteClicked();

    // From LevelGraphicsView
    void objectChanged(QString, int, QPointF, QSizeF, bool);
    void objectSelected(QString, int);
    void needToRescale(QString, int, double, double, double, double, bool);
    void needToUpdateGraphics();

    // Buttons
    void addPropertyClicked();
    void deletePropertyClicked();
    void newObjectClicked();
    void deleteObjectClicked();
    void addLevelPropertyClicked();
    void deleteLevelPropertyClicked();
    void wallThicknessClicked();

    // Other
    void levelPlistChanged(QTableWidgetItem*);
    void objectChanged(QTableWidgetItem*);
    void rotationSliderMoved(int);
    void objectTableClicked(int, int);
    void newObjectClicked(QModelIndex);
    void comboBoxChanged(int);

    // Other window
    void doneEditingSublist(QList<QVariant>, int, int);


private:
    Ui::MainWindow *ui;

    void saveLevelPlist(QString filename);

    void loadSpritePlist();
    void loadLevelPlist(QString level);
    void updateGraphics();  // redraws entire level
    void updateSelectedObjects(QGraphicsScene* scene, bool removePrevious);  // redraws all yellow rectangles
    QList<QGraphicsLineItem*> sceneYellowLines; // contains pointers to all lines currently in the scene

    QRect strToRect(QString in); // helper function to convert string to rect
    QString getNameForCopy(QString newName); // helper function to get name after copying or creating new object

    void updateLevelPlistTable();
    void updateObjectComboBox();
    void clearObjectTable();

    QGraphicsScene *scene;
    QImage spriteSheet;
    QMap<QString, QRect> spriteSheetLocations;
    QMap<QString, QString> levelPlist;
    QList< QMap<QString, QVariant> > levelObjects;

    bool noEmit;
    bool initializing;

    QString currentFileName;

    // Undo functionality
    QStack<UndoObject> undoStack;
    QStack<UndoObject> redoStack;
    void pushUndo(bool clearRedoStack = true);
    void popUndo();

    // Copy/paste functionality
    void createCopyOfObjects(QList<int> objects);
    QList<int> copyObjects;  // stored objects to be copied (saved when control-c is hit)

    // Create new object functionality
    void populateNewObjectList();
    QMap<QString, QVariant> loadObjectFromTemplateFile(QString filename);

    // Multi-select functionality
    QList<int> selectedObjects;

    void updateObjectTable(int id);
};

#endif // MAINWINDOW_H
