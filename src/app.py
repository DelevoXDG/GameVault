from PyQt6.QtSql import *
from PyQt6.QtWidgets import *
from PyQt6.QtGui import *
from PyQt6.QtCore import Qt, QDate
import sys
from connect import create_connection
import os
import datetime


class ProxyStyle(QProxyStyle):
    def drawControl(self, ctl, opt, qp, widget=None):
        if ctl == QStyle.ControlElement.CE_HeaderSection and opt.orientation == Qt.Orientation.Horizontal:
            if opt.section == widget.parent().property('hideSortIndicatorColumn'):
                opt.sortIndicator = 0
        super().drawControl(ctl, opt, qp, widget)


class table_model(QSqlRelationalTableModel):
    def __init__(self):
        super(table_model, self).__init__()
        self.pk_edit = False

    def set_pk_edit(self, on):
        self.pk_edit = on

    def flags(self, index):  # Overriding the flags method
        cur_flags = super().flags(index)

        if index.column() == 0 and self.pk_edit is False:
            cur_flags &= ~ Qt.ItemFlag.ItemIsEditable

        return cur_flags

    def submit(self):
        # print('Submitting')
        success = True

        if self.editStrategy == QSqlRelationalTableModel.EditStrategy.OnFieldChange or self.editStrategy == QSqlRelationalTableModel.EditStrategy.OnRowChange:
            res = super().submitAll()
            if res is False:
                success = False
                self.select()
        else:
            res = super().submit()

        if success:
            # print('Submit successful')
            pass
        else:
            print('Submit failed')
            print(self.lastError().text())
        return res

    def sort(self, column, order):
        if column != 3:
            self._sort_order = order
            super().sort(column, order)


class table_widget(QWidget):
    def __init__(self,  DATABASE_NAME, TABLE_NAME):
        self.DATABASE_NAME = DATABASE_NAME
        self.TABLE_NAME = TABLE_NAME

        super(table_widget, self).__init__()

        self.setFixedSize(700, 480)
        self.setWindowTitle("Game Catalogue @ Admin Panel")

        self.set_icon('assets\logo.ico')

        self.layout = QVBoxLayout(self)
        # self.label = QLabel("Admin Panel", self)
        self.buttonBox = QDialogButtonBox(self)

        self.model = table_model()
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
        # self.layout.addWidget(self.label)
        # self.view.setFocusPolicy(Qt.FocusPolicy.NoFocus)

        self.hh = self.view.horizontalHeader()
        for i in range(0, self.model.columnCount()):
            self.hh.setSectionResizeMode(
                i, QHeaderView.ResizeMode.ResizeToContents)
        self.hh.setSectionResizeMode(3, QHeaderView.ResizeMode.Stretch)
        self.hh.setSectionResizeMode(2, QHeaderView.ResizeMode.Fixed)
        self.hh.setSectionResizeMode(4, QHeaderView.ResizeMode.Fixed)
        self.view.setColumnWidth(4, 120)
        self.view.setColumnWidth(4, 70)

        bold_font = self.hh.font()
        bold_font.setBold(True)
        self.hh.setFont(bold_font)
        self.hh.setHighlightSections(True)

        self.vh = self.view.verticalHeader()
        # self.vh.setSectionResizeMode(QHeaderView.ResizeMode.Fixed)
        # self.vh.setFixedSize(20, 20)
        self.vh.setMinimumWidth(25)
        # self.vh.setAutoFillBackground(True)
        self.vh.setStyleSheet(
            "QHeaderView {background-color: #f2f2f2;}")

        self.view.setSortingEnabled(True)
        self._style = ProxyStyle(self.view.style())
        self.view.setStyle(self._style)
        self.model.setProperty('hideSortIndicatorColumn', 3)

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
        # print('Inserting record')

        self.model.set_pk_edit(True)
        last_row_num = self.model.rowCount() - 1
        cur_sort_col = self.hh.sortIndicatorSection()
        cur_sort_order = self.hh.sortIndicatorOrder()

        self.model.sort(0, Qt.SortOrder.AscendingOrder)

        if last_row_num == -1:
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

        success = self.model.insertRecord(-1, r)
        self.model.set_pk_edit(False)
        self.model.sort(cur_sort_col, cur_sort_order)

        if success is False:
            print('Insert failed')
        else:
            print('Insert successful')

        self.model.select()

    def delete_records(self):
        # print('Deleting records')
        del_rows = self.selection_model.selectedRows()
        success = True
        for index in sorted(del_rows):
            success = self.model.removeRow(index.row())
            if not success:
                break
        if success:
            print('Delete successful')
        else:
            print('Delete failed')
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

    palette = QPalette()
    palette.setColor(QPalette.ColorRole.Window, QColor(231, 231, 231))
    # palette.setColor(QPalette.ColorRole.WindowText, Qt.GlobalColor.white)
    # palette.setColor(QPalette.ColorRole.Base, QColor(25, 25, 25))
    # palette.setColor(QPalette.ColorRole.AlternateBase, QColor(53, 53, 53))
    # palette.setColor(QPalette.ColorRole.ToolTipBase, Qt.GlobalColor.white)
    # palette.setColor(QPalette.ColorRole.ToolTipText, Qt.GlobalColor.white)
    # palette.setColor(QPalette.ColorRole.Text, Qt.GlobalColor.white)
    palette.setColor(QPalette.ColorRole.Button, QColor(190, 232, 190))
    palette.setColor(QPalette.ColorRole.ButtonText, Qt.GlobalColor.black)
    # palette.setColor(QPalette.ColorRole.BrightText, Qt.GlobalColor.red)
    # palette.setColor(QPalette.ColorRole.Link, QColor(42, 130, 218))
    # palette.setColor(QPalette.ColorRole.Highlight, QColor(239, 239, 239))
    palette.setColor(QPalette.ColorRole.Highlight, QColor(216, 234, 216))
    palette.setColor(QPalette.ColorRole.HighlightedText, Qt.GlobalColor.black)
    app.setPalette(palette)
    pass


def start(DRIVER_NAME, SERVER_NAME, DATABASE_NAME, TABLE_NAME):
    print('Starting app')
    app = QApplication(sys.argv)
    set_style(app)
    create_connection(DRIVER_NAME, SERVER_NAME, DATABASE_NAME)
    global db
    from connect import db

    main_window = table_widget(DATABASE_NAME, TABLE_NAME)
    main_window.show()

    sys.exit(app.exec())
