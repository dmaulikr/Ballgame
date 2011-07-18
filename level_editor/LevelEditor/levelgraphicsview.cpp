#include "levelgraphicsview.h"

LevelGraphicsView::LevelGraphicsView(QWidget* pQW_Parent)
{
}

void LevelGraphicsView::mousePressEvent(QMouseEvent *event)
{
    if (QGraphicsItem *item = itemAt(event->pos())) {
        //qDebug() << "You clicked on item" << item;
        draggedItem = item;
        int mouseX = draggedItem->pos().x() - mapToScene(event->pos()).x();
        int mouseY = draggedItem->pos().y() - mapToScene(event->pos()).y();
        mouseOffset = QPointF(mouseX, mouseY);

        resizing = false;

        double rightPercent = (double)mouseX / draggedItem->boundingRect().size().width() * -1;
        double bottomPercent = (double)mouseY / draggedItem->boundingRect().size().height() * -1;
        if(rightPercent >= .9 || bottomPercent >= .9)
        {
            resizing = true;
            previousPoint = QPointF(mapToScene(event->pos()));
        }

        emit objectSelected(draggedItem->data(1).toString(), draggedItem->data(2).toInt());

    } else {
        //qDebug() << "You didn't click on an item.";
        draggedItem = NULL;
        mouseOffset = QPointF(0,0);
        resizing = false;
    }
}

void LevelGraphicsView::mouseMoveEvent(QMouseEvent *event)
{
    if(!draggedItem) // no item selected
        return;

    QPointF pos = mapToScene(event->pos()) + mouseOffset;

    if(!resizing)
    {
        draggedItem->setPos(pos);
        emit objectChanged(draggedItem->data(1).toString(), draggedItem->data(2).toInt(), pos, draggedItem->boundingRect().size());
    }
    else
    {
        QPointF newPoint = mapToScene(event->pos());

        double scaleX = (newPoint.x() - draggedItem->pos().x()) / (previousPoint.x() - draggedItem->pos().x());
        double scaleY = (newPoint.y() - draggedItem->pos().y()) / (previousPoint.y() - draggedItem->pos().y());

        if(scaleX > 0 && scaleY > 0)
        {
            previousPoint = newPoint;
            emit needToRescale(draggedItem->data(1).toString(), draggedItem->data(2).toInt(), scaleX, scaleY);
        }
    }
}


void LevelGraphicsView::mouseReleaseEvent(QMouseEvent *event)
{
    if(!draggedItem) // no item selected
        return;

    QPointF pos = mapToScene(event->pos()) + mouseOffset;

    if(!resizing)
    {
        draggedItem->setPos(pos);
        emit objectChanged(draggedItem->data(1).toString(), draggedItem->data(2).toInt(), pos, draggedItem->boundingRect().size());
    }
    else
    {
        QPointF newPoint = mapToScene(event->pos());

        double scaleX = (newPoint.x() - draggedItem->pos().x()) / (previousPoint.x() - draggedItem->pos().x());
        double scaleY = (newPoint.y() - draggedItem->pos().y()) / (previousPoint.y() - draggedItem->pos().y());

        if(scaleX > 0 && scaleY > 0)
        {
            previousPoint = newPoint;
            emit needToRescale(draggedItem->data(1).toString(), draggedItem->data(2).toInt(), scaleX, scaleY);
        }
    }




    draggedItem = NULL;
    resizing = false;
}
