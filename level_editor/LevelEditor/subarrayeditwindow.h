#ifndef SUBARRAYEDITWINDOW_H
#define SUBARRAYEDITWINDOW_H

#include <QWidget>
#include <QList>
#include <QMap>
#include <QVariant>
#include <QTableWidgetItem>

class MainWindow;

namespace Ui {
    class SubArrayEditWindow;
}

class SubArrayEditWindow : public QWidget
{
    Q_OBJECT

public:
    explicit SubArrayEditWindow(QWidget * parent = 0, Qt::WindowFlags f = 0);
    ~SubArrayEditWindow();

    void loadData(QList< QVariant >, int, int, MainWindow* mainWin);

signals:
    void doneEditingSublist(QList<QVariant>, int, int);

private slots:
    void objectChanged(QTableWidgetItem*);
    void comboBoxSelected(int);
    void doneClicked();
    void addItemClicked();
    void deleteItemClicked();

private:
    Ui::SubArrayEditWindow *ui;

    void updateComboBox();
    void updateObjectTable(int index);
    void clearObjectTable();

    // Stores which object this belongs to in the main window
    int mainWindowObjectId;
    // Stores which property of that object this is
    int mainWindowObjectIndex;

    QList< QVariant > list;

    bool noEmit;
};

#endif // SUBARRAYEDITWINDOW_H
