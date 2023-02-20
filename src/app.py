
from PyQt6.QtSql import QSqlRelationalTableModel, QSqlDatabase, QSqlQuery
from PyQt6.QtWidgets import QApplication, QProxyStyle, QTableView, QAbstractItemView, QHeaderView, QVBoxLayout, QWidget, QHBoxLayout, QPushButton, QStyle, QDialog, QLabel, QDialogButtonBox, QAbstractButton
from PyQt6.QtGui import QPalette, QColor, QIcon, QPixmap, QPainter
from PyQt6.QtCore import Qt, QDate, QSize
import sys
from connect import create_connection
import os
import datetime


class ASSETS:
    ICON = 'assets\logo5.png'
    HELP_ICON = 'assets\help.png'


class ProxyStyle(QProxyStyle):
    # def drawControl(self, ctl, opt, qp, widget=None):
    #     if ctl == QStyle.ControlElement.CE_HeaderSection and opt.orientation == Qt.Orientation.Horizontal:
    #         if opt.section == widget.parent().property('hideSortIndicatorColumn'):
    #             opt.sortIndicator = 0
    #     super().drawControl(ctl, opt, qp, widget)
    pass


class TableModel(QSqlRelationalTableModel):
    def __init__(self):
        super(TableModel, self).__init__()
        self.pk_edit = False
        self.setEditStrategy(
            QSqlRelationalTableModel.EditStrategy.OnFieldChange)

    def set_pk_edit(self, on):
        self.pk_edit = on

    def flags(self, index):  # Overriding the flags method
        cur_flags = super().flags(index)

        if index.column() == 0 and self.pk_edit is False:
            return cur_flags and ~  Qt.ItemFlag.ItemIsEditable

        return cur_flags

    def submit(self):
        print('Submitting')
        success = True

        if self.editStrategy() == QSqlRelationalTableModel.EditStrategy.OnFieldChange or self.editStrategy() == QSqlRelationalTableModel.EditStrategy.OnRowChange:
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
            super().sort(column, self._sort_order)


class HelpDialogue(QWidget):
    def __init__(self,):
        super(HelpDialogue, self).__init__()
        self.setFixedSize(500, 300)
        self.setWindowTitle('Help')

        self.set_icon(ASSETS.HELP_ICON)

        self.layout = QVBoxLayout(self)

        close_btn = QPushButton('Close')

        close_btn.clicked.connect(self.close)

        message = QLabel("Something happened, is that OK?")
        self.layout.addWidget(message)
        self.layout.addWidget(close_btn)
        self.setLayout(self.layout)

    def set_icon(self, relative_path):
        self.setWindowIcon(QIcon(full_path(relative_path)))


class PictureButton(QAbstractButton):

    def __init__(self, picture, parent):
        super().__init__(parent)
        self.setPicture(QPixmap(picture))

    def setPicture(self, picture):
        self.picture = picture
        self.update()

    def sizeHint(self):
        return self.picture.size()

    def paintEvent(self, e):
        painter = QPainter(self)
        painter.drawPixmap(0, 0, self.picture)


class MainWidget(QWidget):
    def __init__(self,  DATABASE_NAME, TABLE_NAME):
        self.DATABASE_NAME = DATABASE_NAME
        self.TABLE_NAME = TABLE_NAME

        super(MainWidget, self).__init__()

        self.setFixedSize(700, 480)
        self.setWindowTitle(
            '{} @ Admin Panel'.format(self.TABLE_NAME.replace("dbo.", "")))

        # self.setWindowFlags(
        #     Qt.WindowType.WindowContextHelpButtonHint and self.windowFlags())
        self.set_icon(ASSETS.ICON)

        self.model = TableModel()
        self.model.setTable(TABLE_NAME)

        self.view = QTableView()
        self.view.setModel(self.model)
        self.view.resizeColumnsToContents()
        self.view.setSelectionBehavior(
            QAbstractItemView.SelectionBehavior.SelectRows)

        self.selection_model = self.view.selectionModel()

        self.hh = self.setup_horizontal_header()
        self.vh = self.setup_vertical_header()

        self.view.setSortingEnabled(True)
        self.hh.setSortIndicator(0, Qt.SortOrder.AscendingOrder)

        self.help_widget = self.setup_help()
        

        self.setLayout(self.setup_layout())
        self.model.select()

    def setup_horizontal_header(self):
        hh = self.view.horizontalHeader()
        for i in range(0, self.model.columnCount()):
            hh.setSectionResizeMode(
                i, QHeaderView.ResizeMode.ResizeToContents)
        hh.setSectionResizeMode(3, QHeaderView.ResizeMode.Stretch)
        hh.setSectionResizeMode(2, QHeaderView.ResizeMode.Fixed)
        hh.setSectionResizeMode(4, QHeaderView.ResizeMode.Fixed)
        self.view.setColumnWidth(4, 120)
        self.view.setColumnWidth(4, 70)

        bold_font = hh.font()
        bold_font.setBold(True)
        hh.setFont(bold_font)
        hh.setHighlightSections(True)
        return hh

    def setup_vertical_header(self):
        vh = self.view.verticalHeader()
        # self.vh.setSectionResizeMode(QHeaderView.ResizeMode.Fixed)
        # self.vh.setFixedSize(20, 20)
        vh.setMinimumWidth(25)
        # self.vh.setAutoFillBackground(True)
        vh.setStyleSheet(
            'QHeaderView {background-color: #f2f2f2;}')
        return vh

    def setup_layout(self):
        layout = QVBoxLayout(self)
        layout.addWidget(self.view)
        button_box = QWidget()
        button_box.layout = QHBoxLayout(button_box)

        help_btn = QPushButton()

        pixmap = QPixmap(full_path(ASSETS.HELP_ICON))
        help_btn.setIcon(QIcon(pixmap))
        help_btn_size = QSize(25, 25)
        help_btn.setIconSize(help_btn_size)
        help_btn.setFixedSize(help_btn_size)
        help_btn.setStyleSheet(
            "QPushButton { background-color: transparent; border: 0px }")

        insert_btn = QPushButton('Insert Record')
        delete_btn = QPushButton('Delete Record')
        help_btn.clicked.connect(self.show_help)
        insert_btn.clicked.connect(self.insert_record)
        delete_btn.clicked.connect(self.delete_records)

        button_box.layout.addWidget(help_btn)
        button_box.layout.addSpacing(300)
        button_box.layout.addWidget(insert_btn)
        button_box.layout.addWidget(delete_btn)

        layout.addWidget(button_box)
        return layout

    def setup_help(self):
        print('Displaying help dialogue')

        # help_dialogue.show()
        help_dialogue =  HelpDialogue()
        return help_dialogue

    def set_icon(self, relative_path):
        self.setWindowIcon(QIcon(full_path(relative_path)))

    def submit_changes(self):
        print('Submitting changes')
        self.model.submitAll()
        self.model.select()

    def insert_record(self):

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

    def show_help(self):
        print('Showing help')
        self.help_widget.show()


def full_path(relative_path):
    scriptDir = os.path.dirname(os.path.realpath(__file__))
    return scriptDir + os.path.sep + relative_path


def set_style(app):
    app.setStyle('Fusion')
    # app.setStyle("Fusion")

    palette = QPalette()
    palette.setColor(QPalette.ColorRole.Window, QColor(220, 220, 220))
    # palette.setColor(QPalette.ColorRole.WindowText, Qt.GlobalColor.white)
    palette.setColor(QPalette.ColorRole.Base, QColor(242, 242, 242))
    # palette.setColor(QPalette.ColorRole.AlternateBase, QColor(53, 53, 53))
    # palette.setColor(QPalette.ColorRole.ToolTipBase, Qt.GlobalColor.white)
    # palette.setColor(QPalette.ColorRole.ToolTipText, Qt.GlobalColor.white)
    # palette.setColor(QPalette.ColorRole.Text, Qt.GlobalColor.white)
    palette.setColor(QPalette.ColorRole.Button, QColor(70, 152, 27))
    # palette.setColor(QPalette.ColorRole.Button, QColor(147, 223, 147))
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

    main_window = MainWidget(DATABASE_NAME, TABLE_NAME)
    main_window.show()

    sys.exit(app.exec())
