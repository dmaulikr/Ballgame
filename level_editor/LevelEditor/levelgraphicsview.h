#ifndef LEVELGRAPHICSVIEW_H
#define LEVELGRAPHICSVIEW_H

#include <QGraphicsItem>
#include <QGraphicsView>
#include <QMouseEvent>
#include <QDebug>
#include <QList>


class LevelGraphicsView : public QGraphicsView
{
    Q_OBJECT

public:
    LevelGraphicsView(QWidget* pQW_Parent=NULL);

    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);

    void setListPointer(QList<int> *pointer);

signals:
    void objectChanged(QString, int, QPointF, QSizeF, bool);
    void objectSelected(QString, int);
    void needToRescale(QString, int, double, double, double, double, bool);
    void needToUpdateGraphics();

private:

    // Helper function
    QGraphicsItem* getItemForId(int id);

    bool resizing;
    QPointF mouseDownPoint;

    // pointer to list object in MainWindow
    QList<int> *selectedObjects;

    QList<QPointF> objectStartPositions;
    QList<QSizeF> objectStartSizes;

};

#endif // LEVELGRAPHICSVIEW_H
