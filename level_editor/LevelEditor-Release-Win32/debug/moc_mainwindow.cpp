/****************************************************************************
** Meta object code from reading C++ file 'mainwindow.h'
**
** Created: Sat Aug 13 16:15:06 2011
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../LevelEditor/mainwindow.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'mainwindow.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_MainWindow[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
      28,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      12,   11,   11,   11, 0x08,
      23,   11,   11,   11, 0x08,
      40,   11,   11,   11, 0x08,
      59,   11,   11,   11, 0x08,
      70,   11,   11,   11, 0x08,
      77,   11,   11,   11, 0x08,
      91,   11,   11,   11, 0x08,
     105,   11,   11,   11, 0x08,
     121,   11,   11,   11, 0x08,
     135,   11,   11,   11, 0x08,
     155,  150,   11,   11, 0x08,
     204,  202,   11,   11, 0x08,
     232,  150,   11,   11, 0x08,
     278,   11,   11,   11, 0x08,
     299,   11,   11,   11, 0x08,
     323,   11,   11,   11, 0x08,
     342,   11,   11,   11, 0x08,
     362,   11,   11,   11, 0x08,
     384,   11,   11,   11, 0x08,
     410,   11,   11,   11, 0x08,
     439,   11,   11,   11, 0x08,
     462,   11,   11,   11, 0x08,
     499,   11,   11,   11, 0x08,
     535,  532,   11,   11, 0x08,
     558,   11,   11,   11, 0x08,
     583,  202,   11,   11, 0x08,
     611,   11,   11,   11, 0x08,
     644,  641,   11,   11, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_MainWindow[] = {
    "MainWindow\0\0loadFile()\0saveLevelPlist()\0"
    "saveLevelPlistAs()\0newLevel()\0quit()\0"
    "undoClicked()\0redoClicked()\0deleteClicked()\0"
    "copyClicked()\0pasteClicked()\0,,,,\0"
    "objectChanged(QString,int,QPointF,QSizeF,bool)\0"
    ",\0objectSelected(QString,int)\0"
    "needToRescale(QString,int,double,double,bool)\0"
    "addPropertyClicked()\0deletePropertyClicked()\0"
    "newObjectClicked()\0copyObjectClicked()\0"
    "deleteObjectClicked()\0addLevelPropertyClicked()\0"
    "deleteLevelPropertyClicked()\0"
    "wallThicknessClicked()\0"
    "levelPlistChanged(QTableWidgetItem*)\0"
    "objectChanged(QTableWidgetItem*)\0id\0"
    "updateObjectTable(int)\0rotationSliderMoved(int)\0"
    "objectTableClicked(int,int)\0"
    "newObjectClicked(QModelIndex)\0,,\0"
    "doneEditingSublist(QList<QVariant>,int,int)\0"
};

const QMetaObject MainWindow::staticMetaObject = {
    { &QMainWindow::staticMetaObject, qt_meta_stringdata_MainWindow,
      qt_meta_data_MainWindow, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &MainWindow::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *MainWindow::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *MainWindow::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_MainWindow))
        return static_cast<void*>(const_cast< MainWindow*>(this));
    return QMainWindow::qt_metacast(_clname);
}

int MainWindow::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QMainWindow::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: loadFile(); break;
        case 1: saveLevelPlist(); break;
        case 2: saveLevelPlistAs(); break;
        case 3: newLevel(); break;
        case 4: quit(); break;
        case 5: undoClicked(); break;
        case 6: redoClicked(); break;
        case 7: deleteClicked(); break;
        case 8: copyClicked(); break;
        case 9: pasteClicked(); break;
        case 10: objectChanged((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< QPointF(*)>(_a[3])),(*reinterpret_cast< QSizeF(*)>(_a[4])),(*reinterpret_cast< bool(*)>(_a[5]))); break;
        case 11: objectSelected((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 12: needToRescale((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< double(*)>(_a[3])),(*reinterpret_cast< double(*)>(_a[4])),(*reinterpret_cast< bool(*)>(_a[5]))); break;
        case 13: addPropertyClicked(); break;
        case 14: deletePropertyClicked(); break;
        case 15: newObjectClicked(); break;
        case 16: copyObjectClicked(); break;
        case 17: deleteObjectClicked(); break;
        case 18: addLevelPropertyClicked(); break;
        case 19: deleteLevelPropertyClicked(); break;
        case 20: wallThicknessClicked(); break;
        case 21: levelPlistChanged((*reinterpret_cast< QTableWidgetItem*(*)>(_a[1]))); break;
        case 22: objectChanged((*reinterpret_cast< QTableWidgetItem*(*)>(_a[1]))); break;
        case 23: updateObjectTable((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 24: rotationSliderMoved((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 25: objectTableClicked((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 26: newObjectClicked((*reinterpret_cast< QModelIndex(*)>(_a[1]))); break;
        case 27: doneEditingSublist((*reinterpret_cast< QList<QVariant>(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3]))); break;
        default: ;
        }
        _id -= 28;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
