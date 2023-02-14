import pymysql as ps
import pyodbc
import pandas
import PyQt6.QtSql as qt
from PyQt6.QtSql import *
from PyQt6.QtWidgets import *
from PyQt6.QtGui import QKeySequence, QPalette, QColor
from PyQt6.QtGui import *
from PyQt6.QtCore import Qt
import PyQt6.QtWidgets as qtw
import sys


class table_display_gui(qtw.QWidget):
    def __init__(self,  DATABASE_NAME, TABLE_NAME):
        # Initializing QDialog and locking the size at a certain value
        super(table_display_gui, self).__init__()
        self.setFixedSize(700, 450)
        self.DATABASE_NAME = DATABASE_NAME
        self.TABLE_NAME = TABLE_NAME
        # Defining our widgets and main layout
        self.layout = qtw.QVBoxLayout(self)
        self.label = qtw.QLabel("Hello, world!", self)
        self.buttonBox = qtw.QDialogButtonBox(self)

        # self.buttonBox.addButton(button1)
        # Appending our widgets to the layout
        if create_connection(DATABASE_NAME) is True:
            sql_statement = 'SELECT * FROM products'
            dataView = display_data(sql_statement)
            # dataView.show()
        self.model = QSqlRelationalTableModel(self)
        self.model.setTable(TABLE_NAME)
        self.model.setEditStrategy(
            QSqlRelationalTableModel.EditStrategy.OnFieldChange)
        # self.model.setHeaderData(0, Qt.Horizontal, "ID")
        # self.model.setHeaderData(1, Qt.Horizontal, "Name")
        # self.model.setHeaderData(2, Qt.Horizontal, "Job")
        # self.model.setHeaderData(3, Qt.Horizontal, "Email")
        self.model.select()
        # Set up the view
        self.view = QTableView()
        self.view.setModel(self.model)
        self.view.resizeColumnsToContents()
        # self.setCentralWidget(self.view)
        self.layout.addWidget(self.view)

        self.layout.addWidget(self.label)
        # self.layout.addWidget(self.buttonBox)

        button_box = QWidget()
        button_box.layout = QHBoxLayout(button_box)

        insert_btn = QPushButton("Insert Record")
        delete_btn = QPushButton("Delete Record")
        insert_btn.clicked.connect(self.insert_record)

        button_box.layout.addWidget(insert_btn)
        button_box.layout.addWidget(delete_btn)

        self.layout.addWidget(button_box)

        # Connecting our 'OK' and 'Cancel' buttons to the corresponding return codes
        # self.buttonBox.accepted.connect(self.accept)
        # self.buttonBox.rejected.connect(self.reject)
    def insert_record(self):
        print('Inserting record')
        rows = self.model.rowCount()
        # r = self.model.record()
        # qry = QSqlQuery(self.DATABASE_NAME)
        # print(qry.prepare('SET IDENTITY_INSERT {} ON'.format(self.TABLE_NAME)))
        # qry.exec()
        # for i in range(2, self.model.columnCount()):
        #     r.setValue(i, 'aaa')
        # # self.model.insertRecord(-1, r)
        res = self.model.insertRow(1)
        if res:
            print('Sucess')
        else:
            print('Failed')
        print('Done')
        # qry.prepare('SET IDENTITY_INSERT {} OFF'.format(
        #     self.model.tableName()))
        # qry.exec()
        self.model.select()
        # write a code that read user input and inserts a new row to the end of the table


def create_connection(DATABASE_NAME):
    DRIVER_NAME = 'SQL SERVER'
    SERVER_NAME = 'DELEVO-PC\SQLEXPRESS'
    # UID='sa';
    # PWD='sa';
    conn_str = f"""
    DRIVER={{{DRIVER_NAME}}};
    SERVER={SERVER_NAME};
    DATABASE={DATABASE_NAME};
    Trusted_Connection=yes;
    """
    # conn = pyodbc.connect(conn_str)
    # df = pandas.read_sql_query('SELECT * FROM products', conn)
    # print(df)
    # print(type(df))

    global db
    db = qt.QSqlDatabase.addDatabase('QODBC')
    db.setDatabaseName(conn_str)
    if db.open() is True:
        print('Connection to SQL Server successful')
        return True
    else:
        print('Connection to SQL Server failed')
        return False


def display_data(sqlStatement):
    print('Processing query')
    qry = QSqlQuery(db)
    qry.prepare(sqlStatement)
    qry.exec()

    model = QSqlQueryModel()
    model.setQuery(qry)

    widget = qtw.QTableView()
    widget.setModel(model)
    return widget


def main():
    app = qtw.QApplication(sys.argv)
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

    gui = table_display_gui('NORTHWND', 'Products')
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
