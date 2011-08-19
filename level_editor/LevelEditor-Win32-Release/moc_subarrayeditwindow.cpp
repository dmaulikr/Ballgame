/****************************************************************************
** Meta object code from reading C++ file 'subarrayeditwindow.h'
**
** Created: Sat Aug 13 16:59:00 2011
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../LevelEditor/subarrayeditwindow.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'subarrayeditwindow.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_SubArrayEditWindow[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: signature, parameters, type, tag, flags
      23,   20,   19,   19, 0x05,

 // slots: signature, parameters, type, tag, flags
      67,   19,   19,   19, 0x08,
     100,   19,   19,   19, 0x08,
     122,   19,   19,   19, 0x08,
     136,   19,   19,   19, 0x08,
     153,   19,   19,   19, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_SubArrayEditWindow[] = {
    "SubArrayEditWindow\0\0,,\0"
    "doneEditingSublist(QList<QVariant>,int,int)\0"
    "objectChanged(QTableWidgetItem*)\0"
    "comboBoxSelected(int)\0doneClicked()\0"
    "addItemClicked()\0deleteItemClicked()\0"
};

const QMetaObject SubArrayEditWindow::staticMetaObject = {
    { &QWidget::staticMetaObject, qt_meta_stringdata_SubArrayEditWindow,
      qt_meta_data_SubArrayEditWindow, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &SubArrayEditWindow::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *SubArrayEditWindow::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *SubArrayEditWindow::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_SubArrayEditWindow))
        return static_cast<void*>(const_cast< SubArrayEditWindow*>(this));
    return QWidget::qt_metacast(_clname);
}

int SubArrayEditWindow::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: doneEditingSublist((*reinterpret_cast< QList<QVariant>(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3]))); break;
        case 1: objectChanged((*reinterpret_cast< QTableWidgetItem*(*)>(_a[1]))); break;
        case 2: comboBoxSelected((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 3: doneClicked(); break;
        case 4: addItemClicked(); break;
        case 5: deleteItemClicked(); break;
        default: ;
        }
        _id -= 6;
    }
    return _id;
}

// SIGNAL 0
void SubArrayEditWindow::doneEditingSublist(QList<QVariant> _t1, int _t2, int _t3)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)), const_cast<void*>(reinterpret_cast<const void*>(&_t3)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_END_MOC_NAMESPACE
