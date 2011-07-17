#include "levelgraphicsview.h"

LevelGraphicsView::LevelGraphicsView(QWidget* pQW_Parent)
{
}

void LevelGraphicsView::mousePressEvent(QMouseEvent *event)
{
    if (QGraphicsItem *item = itemAt(event->pos())) {
        qDebug() << "You clicked on item" << item;
        draggedItem = item;
    } else {
        qDebug() << "You didn't click on an item.";
    }
}


void LevelGraphicsView::mouseReleaseEvent(QMouseEvent *event)
{
    draggedItem->setPos(event->pos());
}
