/****************************************************************************
** Meta object code from reading C++ file 'scale.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.6)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "scale.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'scale.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.6. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_SerialScale[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       4,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: signature, parameters, type, tag, flags
      25,   13,   12,   12, 0x05,

 // slots: signature, parameters, type, tag, flags
      60,   12,   12,   12, 0x0a,
      67,   12,   12,   12, 0x0a,
      75,   12,   12,   12, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_SerialScale[] = {
    "SerialScale\0\0weight,unit\0"
    "newMeasurement(double,Units::Unit)\0"
    "tare()\0weigh()\0dataAvailable()\0"
};

void SerialScale::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        SerialScale *_t = static_cast<SerialScale *>(_o);
        switch (_id) {
        case 0: _t->newMeasurement((*reinterpret_cast< double(*)>(_a[1])),(*reinterpret_cast< Units::Unit(*)>(_a[2]))); break;
        case 1: _t->tare(); break;
        case 2: _t->weigh(); break;
        case 3: _t->dataAvailable(); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData SerialScale::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject SerialScale::staticMetaObject = {
    { &QextSerialPort::staticMetaObject, qt_meta_stringdata_SerialScale,
      qt_meta_data_SerialScale, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &SerialScale::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *SerialScale::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *SerialScale::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_SerialScale))
        return static_cast<void*>(const_cast< SerialScale*>(this));
    return QextSerialPort::qt_metacast(_clname);
}

int SerialScale::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QextSerialPort::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    }
    return _id;
}

// SIGNAL 0
void SerialScale::newMeasurement(double _t1, Units::Unit _t2)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_END_MOC_NAMESPACE