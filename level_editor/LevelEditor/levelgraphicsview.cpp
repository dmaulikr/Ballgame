#include "levelgraphicsview.h"

LevelGraphicsView::LevelGraphicsView(QWidget* pQW_Parent)
{
}

void LevelGraphicsView::mousePressEvent(QMouseEvent *event)
{
    // This is the default, it might get overwritten later in this function.
    resizing = false;
    panning = false;

    // Check if control key is being held down
    bool controlDown = (event->modifiers() & Qt::ControlModifier);

    // Get item that was selected (if any)
    QGraphicsItem *item = itemAt(event->pos());

    if(controlDown)
    {
        // If something was selected
        if(item)
        {
            // If item is already selected, unselect it
            bool itemRemoved = false;
            if(selectedObjects->contains(item->data(2).toInt()))
            {
                selectedObjects->removeOne(item->data(2).toInt());
                itemRemoved = true;
            }

            // If item is new, add it
            else if(!selectedObjects->contains(item->data(2).toInt()))
            {
                selectedObjects->append(item->data(2).toInt());
            }

            // If we didn't just remove something, check for resizing
            if(!itemRemoved)
            {
                // Figure out if we are in resizing mode
                int mouseX = item->pos().x() - mapToScene(event->pos()).x();
                int mouseY = item->pos().y() - mapToScene(event->pos()).y();
                double rightPercent = (double)mouseX / item->boundingRect().size().width() * -1;
                double bottomPercent = (double)mouseY / item->boundingRect().size().height() * -1;

                if(!(item->data(3).toBool()) && (rightPercent >= .9 || bottomPercent >= .9))
                {
                    resizing = true;
                }
            }
        }
    }
    else // Control not being held down
    {
        // If something was selected
        if(item)
        {
            // If item is new, clear and add it
            if(!selectedObjects->contains(item->data(2).toInt()))
            {
                selectedObjects->clear();
                selectedObjects->append(item->data(2).toInt());
            }

            // Check for resizing
            // Figure out if we are in resizing mode
            int mouseX = item->pos().x() - mapToScene(event->pos()).x();
            int mouseY = item->pos().y() - mapToScene(event->pos()).y();
            double rightPercent = (double)mouseX / item->boundingRect().size().width() * -1;
            double bottomPercent = (double)mouseY / item->boundingRect().size().height() * -1;

            if(!(item->data(3).toBool()) && (rightPercent >= .9 || bottomPercent >= .9))
            {
                resizing = true;
            }
        }
        else // nothing selected
        {
            selectedObjects->clear();
        }
    }

    // If something was selected, pass that along to MainWindow so UI can be updated
    if(item)
    {
        emit objectSelected(item->data(1).toString(), item->data(2).toInt());
    }

    // If something relevant is happening
    if(item || selectedObjects->count() > 0)
    {
        // Fill up list of start positions (for use in mouseMove and moveReleased)
        objectStartPositions.clear();
        objectStartSizes.clear();
        for(int i = 0; i < selectedObjects->length(); i++)
        {
            objectStartPositions.append(getItemForId(selectedObjects->at(i))->pos());
            objectStartSizes.append(getItemForId(selectedObjects->at(i))->boundingRect().size());
        }

        // Save where we first clicked the mouse (for use in mouseMoveEvent and mouseReleaseEvent)
        mouseDownPoint = mapToScene(event->pos());

        emit needToUpdateGraphics();
    }
    else
    {
        panning = true;
        lastPanPoint = event->pos();
        setCursor(Qt::ClosedHandCursor);
    }
}

void LevelGraphicsView::mouseMoveEvent(QMouseEvent *event)
{
    if(panning)
    {
        if(!lastPanPoint.isNull()) {
            //Get how much we panned
            QPointF delta = mapToScene(lastPanPoint) - mapToScene(event->pos());
            lastPanPoint = event->pos();

            //Update the center ie. do the pan
            SetCenter(mapToScene(viewport()->rect()).boundingRect().center() + delta);
        }

        return;
    }

    if(selectedObjects->length() == 0) // no item selected
    {
        return;
    }

    QPointF currentMousePos = mapToScene(event->pos());

    if(!resizing)
    {
        for(int i = 0; i < selectedObjects->length(); i++)
        {
            QGraphicsItem* draggedItem = getItemForId(selectedObjects->at(i));
            QPointF pos = currentMousePos - mouseDownPoint + objectStartPositions[i];
            draggedItem->setPos(pos);
            emit objectChanged(draggedItem->data(1).toString(), draggedItem->data(2).toInt(), pos, draggedItem->boundingRect().size(), true);
        }
    }
    else
    {
        // Figure out magnitude of change
        double deltaWidth = currentMousePos.x() - mouseDownPoint.x();
        double deltaHeight = currentMousePos.y() - mouseDownPoint.y();

        // For each selected object
        for(int i = 0; i < selectedObjects->length(); i++)
        {
            // Retrieve object
            int num = selectedObjects->at(i);
            QGraphicsItem* draggedItem = getItemForId(num);

            double newWidth = objectStartSizes[i].width() + deltaWidth;
            double newHeight = objectStartSizes[i].height() + deltaHeight;

            // Make sure we're not below the minimum size
            if(newWidth < 5) newWidth = 5;
            if(newHeight < 5) newHeight = 5;

            double newX = objectStartPositions[i].x() + newWidth/2;
            double newY = objectStartPositions[i].y() + newHeight/2;

            // This is so we don't have to call updateGraphics(), which is really slow
            draggedItem->setTransform(QTransform().scale(newWidth / objectStartSizes[i].width(), newHeight / objectStartSizes[i].height()));

            emit needToRescale(draggedItem->data(1).toString(), draggedItem->data(2).toInt(), newWidth, newHeight, newX, newY, true);
        }
    }
}

void LevelGraphicsView::mouseReleaseEvent(QMouseEvent *event)
{
    if(panning)
    {
        setCursor(Qt::ArrowCursor);
        lastPanPoint = QPoint();
        return;
    }

    if(selectedObjects->length() == 0) // no item selected
    {
        //mouseDownPoint = QPointF(0,0);
        return;
    }

    QPointF currentMousePos = mapToScene(event->pos());

    for(int i = 0; i < selectedObjects->length(); i++)
    {
        QGraphicsItem* draggedItem = getItemForId(selectedObjects->at(i));

        if(!resizing)
        {
            QPointF pos = currentMousePos - mouseDownPoint + objectStartPositions[i];
            draggedItem->setPos(pos);
            emit objectChanged(draggedItem->data(1).toString(), draggedItem->data(2).toInt(), pos, draggedItem->boundingRect().size(), false);
        }
        else
        {
            // Figure out magnitude of change
            double deltaWidth = currentMousePos.x() - mouseDownPoint.x();
            double deltaHeight = currentMousePos.y() - mouseDownPoint.y();

            // For each selected object
            for(int i = 0; i < selectedObjects->length(); i++)
            {
                // Retrieve object
                int num = selectedObjects->at(i);
                QGraphicsItem* draggedItem = getItemForId(num);

                double newWidth = objectStartSizes[i].width() + deltaWidth;
                double newHeight = objectStartSizes[i].height() + deltaHeight;

                // Make sure we're not below the minimum size
                if(newWidth < 5) newWidth = 5;
                if(newHeight < 5) newHeight = 5;

                double newX = objectStartPositions[i].x() + newWidth/2;
                double newY = objectStartPositions[i].y() + newHeight/2;

                emit needToRescale(draggedItem->data(1).toString(), draggedItem->data(2).toInt(), newWidth, newHeight, newX, newY, false);
            }
        }
    }

    resizing = false;
    //mouseDownPoint = QPointF(0,0);
}

// Zoom in/out
void LevelGraphicsView::wheelEvent(QWheelEvent* event)
{
    //Get the position of the mouse before scaling, in scene coords
    QPointF pointBeforeScale(mapToScene(event->pos()));

    //Get the original screen centerpoint
    QPointF screenCenter = mapToScene(viewport()->rect()).boundingRect().center(); //CurrentCenterPoint; //(visRect.center());

    //Scale the view ie. do the zoom
    double scaleFactor = 1.15; //How fast we zoom
    if(event->delta() > 0) {
        //Zoom in
        scale(scaleFactor, scaleFactor);
    } else {
        //Zooming out
        scale(1.0 / scaleFactor, 1.0 / scaleFactor);
    }

    //Get the position after scaling, in scene coords
    QPointF pointAfterScale(mapToScene(event->pos()));

    //Get the offset of how the screen moved
    QPointF offset = pointBeforeScale - pointAfterScale;

    //Adjust to the new center for correct zooming
    QPointF newCenter = screenCenter + offset;
    SetCenter(newCenter);
}

//Set the current centerpoint in the
void LevelGraphicsView::SetCenter(const QPointF& centerPoint) {
    //Get the rectangle of the visible area in scene coords
    QRectF visibleArea = mapToScene(rect()).boundingRect();

    //Get the scene area
    QRectF sceneBounds = sceneRect();

    double boundX = visibleArea.width() / 2.0;
    double boundY = visibleArea.height() / 2.0;
    double boundWidth = sceneBounds.width() - 2.0 * boundX;
    double boundHeight = sceneBounds.height() - 2.0 * boundY;

    //The max boundary that the centerPoint can be to
    QRectF bounds(boundX, boundY, boundWidth, boundHeight);

    QPointF CurrentCenterPoint;

    if(bounds.contains(centerPoint)) {
        //We are within the bounds
        CurrentCenterPoint = centerPoint;
    } else {
        //We need to clamp or use the center of the screen
        if(visibleArea.contains(sceneBounds)) {
            //Use the center of scene ie. we can see the whole scene
            CurrentCenterPoint = sceneBounds.center();
        } else {

            CurrentCenterPoint = centerPoint;

            //We need to clamp the center. The centerPoint is too large
            if(centerPoint.x() > bounds.x() + bounds.width()) {
                CurrentCenterPoint.setX(bounds.x() + bounds.width());
            } else if(centerPoint.x() < bounds.x()) {
                CurrentCenterPoint.setX(bounds.x());
            }

            if(centerPoint.y() > bounds.y() + bounds.height()) {
                CurrentCenterPoint.setY(bounds.y() + bounds.height());
            } else if(centerPoint.y() < bounds.y()) {
                CurrentCenterPoint.setY(bounds.y());
            }

        }
    }

    //Update the scrollbars
    centerOn(CurrentCenterPoint);
}

QGraphicsItem* LevelGraphicsView::getItemForId(int id)
{
    QList<QGraphicsItem*> its = items();
    for(int i = 0; i < its.count(); i++)
    {
        if (its[i]->data(2).toInt() == id && its[i]->data(1).toString() != "")
        {
            return its[i];
        }
    }

    return NULL;
}

void LevelGraphicsView::setListPointer(QList<int> *pointer)
{
    selectedObjects = pointer;
}
