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

signals:
    void objectChanged(QString, int, QPointF, QSizeF, bool);
    void objectSelected(QString, int);
    void needToRescale(QString, int, double, double, bool);

private:
    QGraphicsItem *draggedItem;
    int draggedItemId;
    QPointF mouseOffset;
    bool resizing;
    QPointF previousPoint;
};

#endif // LEVELGRAPHICSVIEW_H
