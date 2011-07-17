#ifndef LEVELGRAPHICSVIEW_H
#define LEVELGRAPHICSVIEW_H

#include <QGraphicsView>
#include <QMouseEvent>
#include <QDebug>
#include <QGraphicsItem>

class LevelGraphicsView : public QGraphicsView
{
public:
    LevelGraphicsView(QWidget* pQW_Parent=NULL);

    void mousePressEvent(QMouseEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);

    QGraphicsItem *draggedItem;
};

#endif // LEVELGRAPHICSVIEW_H
