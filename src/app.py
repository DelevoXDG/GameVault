from PyQt6.QtSql import *
from PyQt6.QtWidgets import *
from PyQt6.QtGui import *
from PyQt6.QtCore import Qt, QDate
import sys
from connect import create_connection
import os
import datetime


class tableModel(QSqlRelationalTableModel):
    def __init__(self):
        super(tableModel, self).__init__()
        self.pk_edit = False

    def set_pk_edit(self, on):
        self.pk_edit = on

    def flags(self, index):  # Overriding the flags method
        cflags = super().flags(index)

        # if index.column() == 0:
        #     cflags = cflags and ~Qt.ItemFlag.ItemIsSelectable

        if index.column() == 0 and self.pk_edit is False:
            return cflags and ~ Qt.ItemFlag.ItemIsEditable

        return cflags

    def submit(self):
        print('Submitting')
        success = True

        if self.editStrategy == QSqlRelationalTableModel.EditStrategy.OnFieldChange or self.editStrategy == QSqlRelationalTableModel.EditStrategy.OnRowChange:
            res = super().submitAll()
            if res is False:
                success = False
                self.select()
        else:
            res = super().submit()

        if success:
            print('Submit successful')
        else:
            print('Submit failed')
            print(self.lastError().text())
        return res


class table_display_gui(QWidget):
    def __init__(self,  DATABASE_NAME, TABLE_NAME):
        # Initializing QDialog and locking the size at a certain value
        super(table_display_gui, self).__init__()
        self.setFixedSize(700, 480)
        self.setWindowTitle("Game Catalogue @ Admin Panel")

        self.set_icon('assets\logo.ico')

        self.DATABASE_NAME = DATABASE_NAME
        self.TABLE_NAME = TABLE_NAME

        self.layout = QVBoxLayout(self)
        self.label = QLabel("Hello, world!", self)
        self.buttonBox = QDialogButtonBox(self)

        self.model = tableModel()
        self.model.setTable(TABLE_NAME)

        self.model.setEditStrategy(
            QSqlRelationalTableModel.EditStrategy.OnFieldChange)

        self.model.select()

        self.view = QTableView()
        self.view.setModel(self.model)
        self.view.resizeColumnsToContents()
        self.selection_model = self.view.selectionModel()
        self.view.setSelectionBehavior(
            QAbstractItemView.SelectionBehavior.SelectRows)
        self.layout.addWidget(self.view)
        self.layout.addWidget(self.label)

        header = self.view.horizontalHeader()
        for i in range(0, self.model.columnCount()):
            header.setSectionResizeMode(
                i, QHeaderView.ResizeMode.ResizeToContents)
        header.setSectionResizeMode(3, QHeaderView.ResizeMode.Stretch)
        header.setSectionResizeMode(2, QHeaderView.ResizeMode.Fixed)
        header.setSectionResizeMode(4, QHeaderView.ResizeMode.Fixed)
        self.view.setColumnWidth(4, 120)
        self.view.setColumnWidth(4, 70)

        button_box = QWidget()
        button_box.layout = QHBoxLayout(button_box)

        insert_btn = QPushButton("Insert Record")
        delete_btn = QPushButton("Delete Record")
        insert_btn.clicked.connect(self.insert_record)
        delete_btn.clicked.connect(self.delete_records)

        button_box.layout.addSpacing(300)
        button_box.layout.addWidget(insert_btn)
        button_box.layout.addWidget(delete_btn)

        self.layout.addWidget(button_box)

    def set_icon(self, relative_path):
        scriptDir = os.path.dirname(os.path.realpath(__file__))
        self.setWindowIcon(QIcon(scriptDir + os.path.sep + 'assets\logo.ico'))

    def submit_changes(self):
        print('Submitting changes')
        self.model.submitAll()
        self.model.select()

    def insert_record(self):
        print('Inserting record')

        self.model.set_pk_edit(True)
        last_row_num = self.model.rowCount() - 1
        if last_row_num == 0:
            row_num = 1
        else:
            row_num = int(self.model.index(last_row_num, 0).data())+1
        # while (self.model.index(row_num, 0).isValid()):
        #     print('Valid')
        #     row_num += 1

        r = self.model.record()
        r.setValue(0, row_num)
        r.setValue(1, '')
        dt = str(datetime.datetime.now().date())
        r.setValue(2, dt)
        r.setValue(3, '')
        r.setValue(4, 0.00)

        self.model.insertRecord(-1, r)
        self.model.set_pk_edit(False)
        # res = self.model.insertRow(1)
        # if res:
        #     print('Sucess')
        # else:
        #     print('Failed')
        print('Done')
        # qry.prepare('SET IDENTITY_INSERT {} OFF'.format(
        #     self.model.tableName()))
        # qry.exec()
        self.model.select()
        # write a code that read user input and inserts a new row to the end of the table

    def delete_records(self):
        del_rows = self.selection_model.selectedRows()

        for index in sorted(del_rows):
            self.model.removeRow(index.row())
        self.model.select()


def display_data(sqlStatement):
    print('Processing query')
    qry = QSqlQuery(db)
    qry.prepare(sqlStatement)
    qry.exec()

    model = QSqlQueryModel()
    model.setQuery(qry)

    widget = QTableView()
    widget.setModel(model)
    return widget


def set_style(app):
    app.setStyle('Fusion')
    # app.setStyle("Fusion")

    # # Now use a palette to switch to dark colors:
    # palette = QPalette()
    # palette.setColor(QPalette.ColorRole.Window, QColor(53, 53, 53))
    # palette.setColor(QPalette.ColorRole.WindowText, Qt.GlobalColor.white)
    # palette.setColor(QPalette.ColorRole.Base, QColor(25, 25, 25))
    # palette.setColor(QPalette.ColorRole.AlternateBase, QColor(53, 53, 53))
    # palette.setColor(QPalette.ColorRole.ToolTipBase, Qt.GlobalColor.white)
    # palette.setColor(QPalette.ColorRole.ToolTipText, Qt.GlobalColor.white)
    # palette.setColor(QPalette.ColorRole.Text, Qt.GlobalColor.white)
    # palette.setColor(QPalette.ColorRole.Button, QColor(53, 53, 53))
    # palette.setColor(QPalette.ColorRole.ButtonText, Qt.GlobalColor.white)
    # palette.setColor(QPalette.ColorRole.BrightText, Qt.GlobalColor.red)
    # palette.setColor(QPalette.ColorRole.Link, QColor(42, 130, 218))
    # palette.setColor(QPalette.ColorRole.Highlight, QColor(42, 130, 218))
    # palette.setColor(QPalette.ColorRole.HighlightedText, Qt.GlobalColor.black)
    # app.setPalette(palette)
    pass


def start(DRIVER_NAME, SERVER_NAME, DATABASE_NAME, TABLE_NAME):
    print('Starting app')
    app = QApplication(sys.argv)
    set_style(app)
    create_connection(DRIVER_NAME, SERVER_NAME, DATABASE_NAME)
    global db
    from connect import db

    main_window = table_display_gui(DATABASE_NAME, TABLE_NAME)
    main_window.show()

    sys.exit(app.exec())
