#ifndef SUBARRAYEDITWINDOW_H
#define SUBARRAYEDITWINDOW_H

#include <QWidget>
#include <QList>
#include <QMap>
#include <QVariant>
#include <QTableWidgetItem>
#include <QDebug>

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

    void loadData(QVariant*, QWidget* parentWin);

signals:
    void doneEditingSublist();

private slots:
    void objectChanged(QTableWidgetItem*);
    void comboBoxSelected(int);
    void doneClicked();
    void addItemClicked();
    void deleteItemClicked();
    void tableCellClicked(int, int);

private:
    Ui::SubArrayEditWindow *ui;

    void updateComboBox();
    void updateObjectTable(int index);
    void clearObjectTable();

    QVariant *list;

    bool noEmit;
};

#endif // SUBARRAYEDITWINDOW_H
