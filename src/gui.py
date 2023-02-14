from PyQt6.QtSql import *
from PyQt6.QtWidgets import *
from PyQt6.QtGui import QKeySequence, QPalette, QColor
from PyQt6.QtGui import *
from PyQt6.QtCore import Qt
import sys
from connect import create_connection


class TM(QSqlRelationalTableModel):
    def __init__(self):
        super(TM, self).__init__()
        self.row_count = super().rowCount()
        self.editStrategy = QSqlRelationalTableModel.EditStrategy.OnFieldChange
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
        print('submitting')
        if self.editStrategy == QSqlRelationalTableModel.EditStrategy.OnFieldChange or self.editStrategy == QSqlRelationalTableModel.EditStrategy.OnRowChange:
            res = super().submitAll()
            # self.select()
            if res is False:
                print(self.lastError().text())
                self.select()
            return res

        return True


class table_display_gui(QWidget):
    def __init__(self,  DATABASE_NAME, TABLE_NAME):
        # Initializing QDialog and locking the size at a certain value
        super(table_display_gui, self).__init__()
        self.setFixedSize(700, 480)
        self.DATABASE_NAME = DATABASE_NAME
        self.TABLE_NAME = TABLE_NAME
        # Defining our widgets and main layout
        self.layout = QVBoxLayout(self)
        self.label = QLabel("Hello, world!", self)
        self.buttonBox = QDialogButtonBox(self)

        self.model = TM()
        self.model.setTable(TABLE_NAME)

        self.model.setEditStrategy(
            QSqlRelationalTableModel.EditStrategy.OnFieldChange)

        self.model.select()

        # Set up the view
        self.view = QTableView()
        self.view.setModel(self.model)
        self.view.resizeColumnsToContents()
        self.selection_model = self.view.selectionModel()
        self.view.setSelectionBehavior(
            QAbstractItemView.SelectionBehavior.SelectRows)
        # self.setCentralWidget(self.view)
        self.layout.addWidget(self.view)
        # self.view.

        self.layout.addWidget(self.label)
        # self.layout.addWidget(self.buttonBox)

        header = self.view.horizontalHeader()
        # header.setSectionResizeMode(0, QHeaderView.ResizeMode.ResizeToContents)
        for i in range(1, self.model.columnCount()):
            header.setSectionResizeMode(
                i, QHeaderView.ResizeMode.ResizeToContents)
        header.setSectionResizeMode(3, QHeaderView.ResizeMode.Stretch)
        header.setSectionResizeMode(4, QHeaderView.ResizeMode.Fixed)
        self.view.setColumnWidth(4, 70)
        # header.size

        # self.model.flags(self.model.index(0, 0), Qt.ItemFlag.ItemIsEditable)

        button_box = QWidget()
        button_box.layout = QHBoxLayout(button_box)

        insert_btn = QPushButton("Insert Record")
        delete_btn = QPushButton("Delete Record")
        submit_btn = QPushButton("Submit All Changes")
        insert_btn.clicked.connect(self.insert_record)
        delete_btn.clicked.connect(self.delete_records)
        submit_btn.clicked.connect(self.submit_changes)

        button_box.layout.addWidget(insert_btn)
        button_box.layout.addWidget(delete_btn)
        button_box.layout.addWidget(submit_btn)

        self.layout.addWidget(button_box)

        # Connecting our 'OK' and 'Cancel' buttons to the corresponding return codes
        # self.buttonBox.accepted.connect(self.accept)
        # self.buttonBox.rejected.connect(self.reject)

    def submit_changes(self):
        print('Submitting changes')
        self.model.submitAll()
        self.model.select()

    def insert_record(self):
        print('Inserting record')
        # qry = QSqlQuery(self.DATABASE_NAME)
        # print(qry.prepare('SET IDENTITY_INSERT {} ON'.format(self.TABLE_NAME)))
        # qry.exec()
        # for i in range(2, self.model.columnCount()):
        # r.setValue(i, 'aaa')
        self.model.row_count += 1
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
        r.setValue(2, '1999-01-01')
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
        rows = self.selection_model.selectedRows()
        # indices = self.view.selectedRows()
        for index in sorted(rows):
            self.model.removeRow(index.row())
            self.model.row_count -= 1
        self.model.select()


# def create_connection(DATABASE_NAME):
#     DRIVER_NAME = 'SQL SERVER'
#     SERVER_NAME = 'DELEVO-PC\SQLEXPRESS'
#     # UID='sa';
#     # PWD='sa';
#     conn_str = f"""
#     DRIVER={{{DRIVER_NAME}}};
#     SERVER={SERVER_NAME};
#     DATABASE={DATABASE_NAME};
#     Trusted_Connection=yes;
#     """
#     # conn = pyodbc.connect(conn_str)
#     # df = pandas.read_sql_query('SELECT * FROM products', conn)
#     # print(df)
#     # print(type(df))

#     global db
#     db = qt.QSqlDatabase.addDatabase('QODBC')
#     db.setDatabaseName(conn_str)
#     if db.open() is True:
#         print('Connection to SQL Server successful')
#         return True
#     else:
#         print('Connection to SQL Server failed')
#         return False


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


def main():
    app = QApplication(sys.argv)
    set_style(app)
    create_connection()
    global db
    from connect import db

    gui = table_display_gui('Steam', 'Games')
    gui.show()

    ### ----------------- ###
    # app = qtw.QApplication(sys.argv)
    # app.setApplicationName('BD_Project')

    # if create_connection() is True:
    #     sql_statement = 'SELECT * FROM products'
    # dataView = display_data(sql_statement)
    # dataView.show()

    # app.exit()

    # sys.exit(app.exec())
    ### ----------------- ###

    sys.exit(app.exec())

    # try:
    #     cn=ps.connect(host='localhost',port=8889,user='sa',password='sa',db='NORTHWND')

    #     cmd=cn.cursor()

    #     query="select * from products"

    #     cmd.execute(query)

    #     rows=cmd.fetchall()


    #     for row in rows:
    #         for col in row:
    #             print(col,end=' ')
    #         print()
    #     cn.close()
    # except Exception as e:
    #     print(e)
if __name__ == '__main__':
    main()
