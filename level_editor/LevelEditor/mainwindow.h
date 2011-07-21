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
<<<<<<< HEAD
#include <QScrollBar>
=======
>>>>>>> ebff114bb841e1209526f67971513d43b4ad601a

namespace Ui {
    class MainWindow;
}

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

    // From LevelGraphicsView
    void objectChanged(QString, int, QPointF, QSizeF);
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


};

#endif // MAINWINDOW_H
