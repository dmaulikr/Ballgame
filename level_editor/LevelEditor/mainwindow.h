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

namespace Ui {
    class MainWindow;
}

struct UndoObject
{
    QMap<QString, QString> levelPlist;
    QList< QMap<QString, QString> > levelObjects;
    int currentObject;
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

    // From LevelGraphicsView
    void objectChanged(QString, int, QPointF, QSizeF, bool);
    void objectSelected(QString, int);
    void needToRescale(QString, int, double, double, bool);

    // Buttons
    void addPropertyClicked();
    void deletePropertyClicked();
    void newObjectClicked();
    void copyObjectClicked();
    void deleteObjectClicked();
    void addLevelPropertyClicked();
    void deleteLevelPropertyClicked();
    void wallThicknessClicked();

    // Other
    void levelPlistChanged(QTableWidgetItem*);
    void objectChanged(QTableWidgetItem*);
    void updateObjectTable(int id);
    void rotationSliderMoved(int);


private:
    Ui::MainWindow *ui;

    void saveLevelPlist(QString filename);

    void loadSpritePlist();
    void loadLevelPlist(QString level);
    void updateGraphics();  // redraws entire level
    QRect strToRect(QString in); // helper function to convert string to rect

    void updateLevelPlistTable();
    void updateObjectComboBox();
    void clearObjectTable();

    QGraphicsScene *scene;
    QImage spriteSheet;
    QMap<QString, QRect> spriteSheetLocations;
    QMap<QString, QString> levelPlist;
    QList< QMap<QString, QString> > levelObjects;

    bool noEmit;
    bool initializing;

    QString currentFileName;

    // Undo functionality
    QStack<UndoObject> undoStack;
    QStack<UndoObject> redoStack;
    void pushUndo(bool clearRedoStack = true);
    void popUndo();


};

#endif // MAINWINDOW_H
