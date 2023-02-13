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


class game_viewer_gui(qtw.QMainWindow):
    def __init__(self):
        # Initializing QDialog and locking the size at a certain value
        super(game_viewer_gui, self).__init__()
        self.setFixedSize(700, 450)

        # Defining our widgets and main layout
        self.layout = qtw.QVBoxLayout(self)
        self.label = qtw.QLabel("Hello, world!", self)
        self.buttonBox = qtw.QDialogButtonBox(self)
        self.buttonBox.setStandardButtons(
            qtw.QDialogButtonBox.StandardButton.Cancel | qtw.QDialogButtonBox.StandardButton.Ok)

        # Appending our widgets to the layout
        if create_connection() is True:
            sql_statement = 'SELECT * FROM products'
            dataView = display_data(sql_statement)
            # dataView.show()
        self.model = QSqlTableModel(self)
        self.model.setTable("Products")
        self.model.setEditStrategy(QSqlTableModel.EditStrategy.OnFieldChange)
        # self.model.setHeaderData(0, Qt.Horizontal, "ID")
        # self.model.setHeaderData(1, Qt.Horizontal, "Name")
        # self.model.setHeaderData(2, Qt.Horizontal, "Job")
        # self.model.setHeaderData(3, Qt.Horizontal, "Email")
        self.model.select()
        # Set up the view
        self.view = QTableView()
        self.view.setModel(self.model)
        self.view.resizeColumnsToContents()
        self.setCentralWidget(self.view)
        self.layout.addWidget(dataView)

        self.layout.addWidget(self.label)
        self.layout.addWidget(self.buttonBox)

        # Connecting our 'OK' and 'Cancel' buttons to the corresponding return codes
        # self.buttonBox.accepted.connect(self.accept)
        # self.buttonBox.rejected.connect(self.reject)


def create_connection():
    DRIVER_NAME = 'SQL SERVER'
    SERVER_NAME = 'DELEVO-PC\SQLEXPRESS'
    DATABASE_NAME = 'NORTHWND'
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

    gui = game_viewer_gui()
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
