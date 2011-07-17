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
    void levelPlistChanged(QTableWidgetItem*);
    void objectChanged(QTableWidgetItem*);
    void updateObjectTable(int id);
    void addPropertyClicked();
    void deletePropertyClicked();
    void newObjectClicked();
    void copyObjectClicked();
    void deleteObjectClicked();

private:
    Ui::MainWindow *ui;

    void loadFile();
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


};

#endif // MAINWINDOW_H
