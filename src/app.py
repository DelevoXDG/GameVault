
from PyQt6.QtSql import QSqlRelationalTableModel, QSqlDatabase, QSqlQuery
from PyQt6.QtWidgets import QApplication, QProxyStyle, QTableView, QAbstractItemView, QHeaderView, QVBoxLayout, QWidget, QHBoxLayout, QPushButton, QStyle, QDialog, QLabel, QDialogButtonBox, QAbstractButton, QMessageBox, QComboBox, QLineEdit
from PyQt6.QtGui import QPalette, QColor, QIcon, QBrush, QPixmap, QPainter, QDesktopServices, QFont
from PyQt6.QtCore import Qt, QDate, QSize, QUrl
import sys
import connect 
import os
import datetime

class CONFIG:
    DRIVER_NAME = 'SQL SERVER'
    SERVER_NAME = 'DELEVO-PC\SQLEXPRESS'
    DATABASE_NAME = 'STEAM'
    TABLE_NAME = 'dbo.Games'
    APP_NAME = 'Management Studio'
    FULL_APP_NAME = DATABASE_NAME + ' BD ' + APP_NAME 
    TABLE_EXCHANGE_RATE = 'dbo.ExchangeRate'
    FN_CONVERT_CURRENCY = f'SELECT dbo.howMuch({{}},{{}})'
    DEFAULT_CURRENCY = 'USD'
    


class ASSETS:
    LOGO = 'assets\logo_200.png'
    HELP_ICON = 'assets\help.png'
    GH_ICON = 'assets\github.png'
    CURRENCY_ICON_FORMAT= f'assets\currencies\{{}}.png'


# class ProxyStyle(QProxyStyle):
    # def drawControl(self, ctl, opt, qp, widget=None):
    #     if ctl == QStyle.ControlElement.CE_HeaderSection and opt.orientation == Qt.Orientation.Horizontal:
    #         if opt.section == widget.parent().property('hideSortIndicatorColumn'):
    #             opt.sortIndicator = 0
    #     super().drawControl(ctl, opt, qp, widget)
    # pass


class TableModel(QSqlRelationalTableModel):
    def __init__(self):
        super(TableModel, self).__init__()
        self.pk_edit = False
        self.hh = None
        self.vh = None

        self.setEditStrategy(
            QSqlRelationalTableModel.EditStrategy.OnFieldChange)
        self.currency = self.default_currency()

    def default_currency(self):
        return CONFIG.DEFAULT_CURRENCY

    def set_pk_edit(self, on):
        log_enabled = False
        if log_enabled:
            if on:
                print('Enabled Private Key column editing')
            else:
                print('Disabled Private Key column editing')
        self.pk_edit = on

    def flags(self, index): 
        cur_flags = super().flags(index)

        if index.column() == 0 and self.pk_edit is False:
            return (cur_flags )  and ~  Qt.ItemFlag.ItemIsEditable
        if index.column()>=super().columnCount():
            return  (~ Qt.ItemFlag.ItemIsUserCheckable | Qt.ItemFlag.ItemIsSelectable | Qt.ItemFlag.ItemIsEnabled) and ~ Qt.ItemFlag.ItemIsEditable
            
        return cur_flags
    


    def submit(self):
        print('Submitting')
        success = True

        if self.editStrategy() == QSqlRelationalTableModel.EditStrategy.OnFieldChange or self.editStrategy() == QSqlRelationalTableModel.EditStrategy.OnRowChange:
            success = super().submitAll()
        else:
            success = super().submit()

        if success:
            # print('Submit successful')
            pass
        else:
            self.select()
            print('Submit failed')
            print(self.lastError().text())
        return success

    def sort(self, column, order):
        sort_enabled = True
        if column == 3:
            sort_enabled=False
        elif column >= super().columnCount():
            column -=1 
        
        if sort_enabled:
            self._sort_order = order
            super().sort(column, self._sort_order)

    def columnCount(self, parent=None):
        if parent is None:
            cc = super().columnCount()
        else:
            cc = super().columnCount(parent)
        return cc+1

    def data(self, index, role):
        if(role == Qt.ItemDataRole.ForegroundRole):
            return QBrush(Qt.GlobalColor.black)
        
        # if(role == Qt.ItemDataRole.DecorationRole):
            # print('DecorationRole')
            # value = super().data(index, Qt.ItemDataRole.DisplayRole)
            # if index.column() == 2:
        
        if (role == Qt.ItemDataRole.DisplayRole):
            if index.column() >= super().columnCount():
                if (self.currency == self.default_currency()):
                    return ''
                else:
                    qry = QSqlQuery(db)
                    
                    statement = CONFIG.FN_CONVERT_CURRENCY.format(
                        self.data(self.index(index.row(), 0), role),
                        "'"+self.currency+"'"
                    )
                    qry.prepare(statement) 
                    qry.exec()
                    qry.next()
                    res = qry.record().value(0)
                    return res
        
        return super().data(index, role)
    def index(self, row, column, parent=None):
        if column >= super(TableModel, self).columnCount() and row <= super().rowCount():
            ind = self.createIndex(row, column)
        else:
            if parent is None:
                ind =  super(TableModel, self).index(row, column)
            else:
                ind=  super(TableModel, self).index(row, column, parent)
        return ind

    def headerData(self, section, orientation, role=Qt.ItemDataRole.DisplayRole):
        default = super().headerData(section, orientation, Qt.ItemDataRole.DisplayRole)

        if(role == Qt.ItemDataRole.DecorationRole):
            # print('DecorationRole')
            if orientation == Qt.Orientation.Horizontal:
                if section == 4:
                    return QIcon(full_path(ASSETS.CURRENCY_ICON_FORMAT.format(self.default_currency())))
                if section == 5:
                    return QIcon(full_path(ASSETS.CURRENCY_ICON_FORMAT.format(self.currency)))

        if role == Qt.ItemDataRole.ToolTipRole and orientation == Qt.Orientation.Horizontal:
            if section == 5:
                res = 'Price in {}'.format(self.currency)
            else:
                res= default
            # if self.hh is not None:
                # cur_sort_col = self.hh.sortIndicatorSection()
                # cur_sort_order = self.hh.sortIndicatorOrder()
                # if cur_sort_col == section:
                #     if cur_sort_order == Qt.SortOrder.AscendingOrder:
                #         res += ' (Sorted ASCENDING)'
                #     else:
                #         res += ' (Sorting DESCENDING)'
            return res

        if role == Qt.ItemDataRole.DisplayRole and orientation == Qt.Orientation.Horizontal:
            headers = {
                        0: 'ID',
                        1: 'Title',
                        2: 'Last Updated',
                        3: 'Description',
                        4: CONFIG.DEFAULT_CURRENCY,
                        5: self.currency
                    }
            
            res = headers.get(section, default)
            
            return res
        if role == Qt.ItemDataRole.ToolTipRole and orientation == Qt.Orientation.Vertical:
            num = default
            
            return ordinal(num)+' row'
        
        return super().headerData(section, orientation, role)
        
 

class HelpDialogue(QWidget):
    def __init__(self, DATABASE_NAME='DB'):
        super(HelpDialogue, self).__init__()

        self.DATABASE_NAME = DATABASE_NAME
        self.setFixedSize(400, 360)
        self.setWindowTitle('About')

        self.setWindowFlags(self.windowFlags() | Qt.WindowType.WindowStaysOnTopHint)

        self.setWindowIcon(QIcon(full_path(ASSETS.HELP_ICON)))
        
        self.setLayout(self.setup_layout())

    def open_gh(self):
        QDesktopServices.openUrl(QUrl('https://github.com/DelevoXDG/bd_project/'))

    def setup_layout(self):
        layout = QVBoxLayout(self)
        
        button_box = QWidget()
        button_box.layout = QHBoxLayout(button_box)
        
        gh_btn = QPushButton('')
        gh_btn.setIcon(QIcon(full_path(ASSETS.GH_ICON)))
        gh_btn_size = QSize(30, 30)
        gh_btn.setIconSize(gh_btn_size)
        gh_btn.setFixedSize(gh_btn_size)
        gh_btn.setStyleSheet(
            "QPushButton { background-color: transparent; border: 0px }")
        gh_btn.setToolTip('GitHub repo')

        close_btn = QPushButton('Close')
        close_btn.setMinimumSize(QSize(40, 30))
        close_btn.setToolTip('Close this window')

        button_box.layout.addWidget(gh_btn)
        
        button_box.layout.addSpacing(200)
        button_box.layout.addWidget(close_btn)
        

        pattern = f"<center>" \
            "<h1>{}</h1>" \
            "&#8291;" \
            "<img src={} width=\"100\" height=\"100\"></center>" \
            "<center>" \
            "Sample application to manage the database of the video game<br>" \
            "digital distribution service.</center>" \
            "<p style=\"margin-left:10px; text-align:left;\"><b>Attributions</b><br>""<span>&#8226;</span> Flag icons made by <a href=\"https://www.flaticon.com/authors/freepik\">Freepik</a> from <a href=\"http://www.flaticon.com/\">www.flaticon.com</a><br>" \
            "<span>&#8226;</span> Logo generated via <a href=\"https://midjourney.com/\">midjourney.com</a>" \
            "</p>"
        pattern = pattern.format(
            CONFIG.DATABASE_NAME+" DB<br>" + CONFIG.APP_NAME, full_path(ASSETS.LOGO))
        
        label = QLabel(pattern)
        label.setTextFormat(Qt.TextFormat.RichText)
        label.setTextInteractionFlags(Qt.TextInteractionFlag.TextBrowserInteraction)
        label.setOpenExternalLinks(True)
        layout.addWidget(label)
        layout.addWidget(button_box)

        gh_btn.clicked.connect(self.open_gh)
        close_btn.clicked.connect(self.close)
        
        return layout

class MainWidget(QWidget):
    def __init__(self,  DATABASE_NAME, TABLE_NAME):
        self.DATABASE_NAME = DATABASE_NAME
        self.TABLE_NAME = TABLE_NAME

        super(MainWidget, self).__init__()

        self.setFixedSize(700, 480)
        self.setWindowTitle(
            '{} @ {}'.format(self.TABLE_NAME.replace("dbo.", ""), CONFIG.FULL_APP_NAME ))

        # self.setWindowFlags(
        #     Qt.WindowType.WindowContextHelpButtonHint and self.windowFlags())
        self.setWindowIcon(QIcon(full_path(ASSETS.LOGO)))

        self.model = TableModel()
        self.model.setTable(TABLE_NAME)
        # self.model.setHeaderData(0, Qt.Orientation.Horizontal, "ID")
        # self.model.setHeaderData(1, Qt.Orientation.Horizontal, "Title")
        # self.model.setHeaderData(2, Qt.Orientation.Horizontal, "Last Updated")
        # self.model.setHeaderData(3, Qt.Orientation.Horizontal, "Description")
        # self.model.setHeaderData(4, Qt.Orientation.Horizontal, "USD")
        # self.model.setHeaderData(5, Qt.Orientation.Horizontal, "Price in {}".format(self.model.currency))


        self.view = QTableView()
        self.view.setModel(self.model)
        self.view.resizeColumnsToContents()
        # self.view.setAlternatingRowColors(True)

        self.view.setSelectionBehavior(
            QAbstractItemView.SelectionBehavior.SelectRows)
        # self.view.setStyleSheet(
        #     '''
        #     QTableCornerButton::section {
        #         background-color: #f2f2f2;
        #         border: 2px outset #f2f2f2;
        #     }
        #     ''')

        self.selection_model = self.view.selectionModel()
    
        self.hh = self.setup_horizontal_header()
        self.vh = self.setup_vertical_header()
        
        self.model.hh=self.hh
        self.model.vh=self.vh

        self.view.setSortingEnabled(True)
        self.hh.setSortIndicator(0, Qt.SortOrder.AscendingOrder)

        self.help_widget = self.setup_help()
        
        self.layout= self.setup_layout()
        self.setLayout(self.layout)

        self.model.select()


    def setup_horizontal_header(self):
        hh = self.view.horizontalHeader()
        for i in range(0, self.model.columnCount()):
            hh.setSectionResizeMode(
                i, QHeaderView.ResizeMode.ResizeToContents)
        hh.setSectionResizeMode(3, QHeaderView.ResizeMode.Stretch)
        hh.setSectionResizeMode(2, QHeaderView.ResizeMode.Fixed)
        hh.setSectionResizeMode(4, QHeaderView.ResizeMode.Fixed)
        hh.setSectionResizeMode(5, QHeaderView.ResizeMode.Fixed)
        self.view.setColumnWidth(2, 100)
        self.view.setColumnWidth(4, 70)
        if self.model.columnCount() ==6:
            self.view.setColumnWidth(5, 70)
        hh.setMinimumHeight(30)
        

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
            ''' 
            QHeaderView {
                background-color: #f2f2f2;
            }'''
        )
        
        return vh
    
    def setup_layout(self):
        layout = QVBoxLayout(self)
        layout.addWidget(self.view)
        button_box = QWidget()
        button_box.layout = QHBoxLayout(button_box)

        help_btn = QPushButton()

        help_btn.setIcon(QIcon(full_path(ASSETS.HELP_ICON)))
        help_btn_size = QSize(35, 35)
        help_btn.setIconSize(help_btn_size)
        help_btn.setFixedSize(help_btn_size)
        help_btn.setStyleSheet(
            "QPushButton { background-color: transparent; border: 0px }")
        help_btn.clicked.connect(self.show_help)

        regular_btn_size = QSize(100, 35)
        insert_btn = QPushButton('Insert Record')
        insert_btn.setMinimumSize(regular_btn_size)
        insert_btn.clicked.connect(self.insert_record)
        
        delete_btn = QPushButton('Delete Records')
        delete_btn.setMinimumSize(regular_btn_size)
        delete_btn.setStyleSheet('''
            QPushButton:disabled {
                background-color: #666666;
            }
        ''')
        self.delete_btn=delete_btn
        delete_btn.clicked.connect(self.delete_records)
        delete_btn.setEnabled(False)
        self.selection_model.selectionChanged.connect(self.toggle_delete_btn)

        cur_combo = QComboBox()
        currencies = self.get_currency_list()
        for cur in currencies:
            icon_path = full_path(ASSETS.CURRENCY_ICON_FORMAT.format(cur))
            cur_icon = QIcon(icon_path)
            cur_combo.addItem(cur_icon, cur)
        cur_combo.currentTextChanged.connect(self.changed_currency)

        cur_combo.setStyleSheet(
            '''
            QComboBox {
                background-color: #DCDCDC;
                    }
            ''')
        cur_combo.setFixedSize(QSize(100, 35))

        search = QLineEdit(self)
        search.setPlaceholderText('Search titles')
        search.setToolTip('Search titles')
        search.textChanged.connect(self.search_changed)
        search.setMinimumHeight(35)
        search.setMinimumWidth(230)
        search.setFont(QFont('Arial', 13))
        search.setStyleSheet('''
                    QLineEdit {
                        padding-left: 8px;
                             }''')
        self.search = search 
        self.model.search = search

        font = insert_btn.font()
        font.setBold(True)
        insert_btn.setFont(font)
        delete_btn.setFont(font)
        cur_combo.setFont(font)

        help_btn.setToolTip('About')
        insert_btn.setToolTip("Insert a new record with empty values and today's date")
        delete_btn.setToolTip('Delete all the selected records')
        cur_combo.setToolTip('Select the currency to convert prices to')

        button_box.layout.addWidget(help_btn)
        button_box.layout.addSpacing(5)

        button_box.layout.addWidget(search)
        button_box.layout.addSpacing(300)
        button_box.layout.addWidget(cur_combo)
        button_box.layout.addWidget(insert_btn)
        button_box.layout.addWidget(delete_btn)

        layout.addWidget(button_box)
        return layout

    def search_changed(self):
        searched_title = self.search.text().lower()
        for row in range(self.model.rowCount()):
            item = self.model.data(self.model.index(row, 1), Qt.ItemDataRole.DisplayRole)
            self.view.setRowHidden(row, searched_title not in str(item).lower())

    def changed_currency(self, text):
        print('Set currency to {}'.format(text))
        self.model.currency = text
        self.model.setHeaderData(
            5, Qt.Orientation.Horizontal, self.model.currency)
        self.model.select()

    def get_currency_list(self):
        qry = QSqlQuery(db)
        statement = "SELECT * FROM {}".format(
           CONFIG.TABLE_EXCHANGE_RATE)

        qry.prepare(statement)
        qry.exec()
        res = []
        while qry.next() is True:
            res.append(qry.record().value(0))
        res.reverse()
        return res


    def setup_help(self):
        print('Displaying help dialogue')
        help_dialogue =  HelpDialogue(self.DATABASE_NAME)
        
        return help_dialogue


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

        default_title = self.search.text().lower()
        r = self.model.record()
        r.setValue(0, row_num)
        r.setValue(1, default_title)
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

    def toggle_delete_btn(self):
        self.delete_btn.setEnabled(self.selection_model.hasSelection())

    def show_help(self):
        print('Showing help')
        self.help_widget.show()


def ordinal(n: int):
    if 11 <= (n % 100) <= 13:
        suffix = 'th'
    else:
        suffix = ['th', 'st', 'nd', 'rd', 'th'][min(n % 10, 4)]
    return str(n) + suffix

def full_path(relative_path):
    scriptDir = os.path.dirname(os.path.realpath(__file__))
    return scriptDir + os.path.sep + relative_path

def set_style(app: QApplication):
    app.setStyle('Fusion')

    palette = QPalette()
    palette.setColor(QPalette.ColorRole.Window, QColor(220, 220, 220))
    palette.setColor(QPalette.ColorRole.WindowText, Qt.GlobalColor.black)
    palette.setColor(QPalette.ColorRole.Base, QColor(242, 242, 242))
    palette.setColor(QPalette.ColorRole.Text, Qt.GlobalColor.black)
    palette.setColor(QPalette.ColorRole.Button, QColor(70, 152, 27))
    palette.setColor(QPalette.ColorRole.ButtonText, Qt.GlobalColor.black)
    palette.setColor(QPalette.ColorRole.Link, QColor(32, 121, 0))
    palette.setColor(QPalette.ColorRole.Highlight, QColor(216, 234, 216))
    palette.setColor(QPalette.ColorRole.HighlightedText, Qt.GlobalColor.black)
    app.setPalette(palette)


def start():
    print('Starting app')
    app = QApplication(sys.argv)
    set_style(app)
    connect.create_connection(CONFIG.DRIVER_NAME,
                              CONFIG.SERVER_NAME, CONFIG.DATABASE_NAME)
    global db
    from connect import db

    main_window = MainWidget(CONFIG.DATABASE_NAME, CONFIG.TABLE_NAME)
    main_window.show()

    sys.exit(app.exec())
